#import "KSPromise.h"

#include <pthread.h>

#if OS_OBJECT_USE_OBJC_RETAIN_RELEASE == 0
#   define KS_DISPATCH_RELEASE(q) (dispatch_release(q))
#else
#   define KS_DISPATCH_RELEASE(q)
#endif


@interface KSPromiseCallbacks : NSObject

@property (copy, nonatomic) promiseValueCallback fulfilledCallback;
@property (copy, nonatomic) promiseErrorCallback errorCallback;

@property (copy, nonatomic) deferredCallback deprecatedFulfilledCallback;
@property (copy, nonatomic) deferredCallback deprecatedErrorCallback;
@property (copy, nonatomic) deferredCallback deprecatedCompleteCallback;

@property (strong, nonatomic) KSPromise *childPromise;

@end


NSString *const KSPromiseWhenErrorDomain = @"KSPromiseJoinError";
NSString *const KSPromiseWhenErrorErrorsKey = @"KSPromiseWhenErrorErrorsKey";
NSString *const KSPromiseWhenErrorValuesKey = @"KSPromiseWhenErrorValuesKey";


@implementation KSPromiseCallbacks

- (id)initWithFulfilledCallback:(promiseValueCallback)fulfilledCallback
                  errorCallback:(promiseErrorCallback)errorCallback
                    cancellable:(id<KSCancellable>)cancellable {
    self = [super init];
    if (self) {
        self.fulfilledCallback = fulfilledCallback;
        self.errorCallback = errorCallback;
        self.childPromise = [[KSPromise alloc] init];
        [self.childPromise addCancellable:cancellable];
    }
    return self;
}

@end

@interface KSPromise () <KSCancellable> {
    dispatch_semaphore_t _sem;
    pthread_mutex_t _mutex;
}

@property (strong, nonatomic) NSMutableArray *callbacks;
@property (copy, nonatomic) NSArray *parentPromises;

@property (strong, nonatomic, readwrite) id value;
@property (strong, nonatomic, readwrite) NSError *error;

@property (assign, nonatomic) BOOL fulfilled;
@property (assign, nonatomic) BOOL rejected;
@property (assign, nonatomic) BOOL cancelled;
@property (assign, nonatomic) BOOL resolvedOnTheMainThread;

@property (strong, nonatomic) NSHashTable *cancellables;

@end

@implementation KSPromise

- (id)init {
    self = [super init];
    if (self) {
        self.callbacks = [NSMutableArray array];
        self.cancellables = [NSHashTable weakObjectsHashTable];
        _sem = dispatch_semaphore_create(0);
        pthread_mutexattr_t mutexattr;
        pthread_mutexattr_init(&mutexattr);
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_mutex, &mutexattr);
        pthread_mutexattr_destroy(&mutexattr);
    }
    return self;
}

- (void)dealloc {
    KS_DISPATCH_RELEASE(_sem);
    pthread_mutex_destroy(&_mutex);
}

+ (KSPromise *)promise:(void (^)(resolveType resolve, rejectType reject))promiseCallback {
    KSPromise *promise = [[KSPromise alloc] init];
    
    promiseCallback(
                    ^(id value){
                        [promise resolveWithValue:value];
                    },
                    ^(NSError *error) {
                        [promise rejectWithError:error];
                    });
    
    return promise;
}

+ (KSPromise *)resolve:(id)value {
    KSPromise *promise = [[KSPromise alloc] init];
    [promise resolveWithValue:value];
    return promise;
}

+ (KSPromise *)reject:(NSError *)error {
    KSPromise *promise = [[KSPromise alloc] init];
    [promise rejectWithError:error];
    return promise;
}

+ (KSPromise *)when:(NSArray *)promises {
    KSPromise *promise = [[KSPromise alloc] init];
    promise.parentPromises = promises;
    
    if ([promise.parentPromises count] == 0) {
        [promise joinedPromiseFulfilled:nil];
    }
    else {
        for (KSPromise *joinedPromise in promises) {
            for (id<KSCancellable> cancellable in joinedPromise.cancellables) {
                [promise addCancellable:cancellable];
            }
            [joinedPromise finally:^ {
                [promise joinedPromiseFulfilled:joinedPromise];
            }];
        }
    }
    return promise;
}

+ (KSPromise *)all:(NSArray *)promises {
    return [self when:promises];
}

+ (KSPromise *)join:(NSArray *)promises {
    return [self when:promises];
}

- (KSPromise *)then:(promiseValueCallback)fulfilledCallback
              error:(promiseErrorCallback)errorCallback {
    pthread_mutex_lock(&_mutex);
    if (self.cancelled) {
        pthread_mutex_unlock(&_mutex);
        return nil;
    }
    if (![self completed]) {
        KSPromiseCallbacks *callbacks = [[KSPromiseCallbacks alloc] initWithFulfilledCallback:fulfilledCallback
                                                                                errorCallback:errorCallback
                                                                                  cancellable:self];
        [self.callbacks addObject:callbacks];
        pthread_mutex_unlock(&_mutex);
        return callbacks.childPromise;
    }
    BOOL needResolvedOnTheMainThread = self.resolvedOnTheMainThread && ![NSThread isMainThread];
    __block id nextValue;
    if (self.fulfilled) {
        nextValue = self.value;
        if (fulfilledCallback) {
            if (needResolvedOnTheMainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    nextValue = fulfilledCallback(self.value);
                });
            } else {
                nextValue = fulfilledCallback(self.value);
            }
        }
    } else if (self.rejected) {
        nextValue = self.error;
        if (errorCallback) {
            nextValue = errorCallback(self.error);
        }
    }
    KSPromise *promise = [[KSPromise alloc] init];
    promise.resolvedOnTheMainThread = self.resolvedOnTheMainThread;
    [promise addCancellable:self];
    if (needResolvedOnTheMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resolvePromise:promise withValue:nextValue];
        });
    } else {
        [self resolvePromise:promise withValue:nextValue];
    }
    pthread_mutex_unlock(&_mutex);
    return promise;
}

- (KSPromise *)then:(promiseValueCallback)fulfilledCallback {
    return [self then:fulfilledCallback error:nil];
}

- (KSPromise *)error:(promiseErrorCallback)errorCallback {
    return [self then:nil error:errorCallback];
}

- (KSPromise *)finally:(void(^)(void))callback {
    return [self then:^id (id value) {
        callback();
        return value;
    } error:^id (NSError *error) {
        callback();
        return error;
    }];
}

- (void)addCancellable:(id<KSCancellable>)cancellable
{
    pthread_mutex_lock(&_mutex);
    [self.cancellables addObject:cancellable];
    pthread_mutex_unlock(&_mutex);
}

- (void)cancel {
    pthread_mutex_lock(&_mutex);
    self.cancelled = YES;
    for (id<KSCancellable> cancellable in self.cancellables) {
        if (cancellable == self) {
            continue;
        }
        [cancellable cancel];
    }
    [self.callbacks removeAllObjects];
    pthread_mutex_unlock(&_mutex);
}

- (id)waitForValue {
    return [self waitForValueWithTimeout:0];
}

- (id)waitForValueWithTimeout:(NSTimeInterval)timeout {
    pthread_mutex_lock(&_mutex);
    if (![self completed]) {
        pthread_mutex_unlock(&_mutex);
        dispatch_time_t time = timeout == 0 ? DISPATCH_TIME_FOREVER : dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC);
        dispatch_semaphore_wait(_sem, time);
        pthread_mutex_lock(&_mutex);
    }
    if (self.fulfilled) {
        pthread_mutex_unlock(&_mutex);
        return self.value;
    } else if (self.rejected) {
        pthread_mutex_unlock(&_mutex);
        return self.error;
    }
    pthread_mutex_unlock(&_mutex);
    return [NSError errorWithDomain:@"KSPromise" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Timeout exceeded while waiting for value"}];
}

#pragma mark - Resolving and Rejecting

- (void)setResolvedOnTheMainThread:(BOOL)resolvedOnTheMainThread {
    pthread_mutex_lock(&_mutex);
    _resolvedOnTheMainThread = resolvedOnTheMainThread;
    pthread_mutex_unlock(&_mutex);
}

- (void)resolveWithValue:(id)value {
    pthread_mutex_lock(&_mutex);
    NSAssert(!self.completed, @"A fulfilled promise can not be resolved again.");
    if (self.completed || self.cancelled) {
        pthread_mutex_unlock(&_mutex);
        return;
    }
    self.resolvedOnTheMainThread = [NSThread isMainThread];
    self.value = value;
    self.fulfilled = YES;
    for (KSPromiseCallbacks *callbacks in self.callbacks) {
        id nextValue = self.value;
        if (callbacks.fulfilledCallback) {
            nextValue = callbacks.fulfilledCallback(value);
        } else if (callbacks.deprecatedFulfilledCallback) {
            callbacks.deprecatedFulfilledCallback(self);
            continue;
        }
        [self resolvePromise:callbacks.childPromise withValue:nextValue];
    }
    [self finish];
    pthread_mutex_unlock(&_mutex);
}

- (void)rejectWithError:(NSError *)error {
    pthread_mutex_lock(&_mutex);
    NSAssert(!self.completed, @"A fulfilled promise can not be rejected again.");
    if (self.completed || self.cancelled) {
        pthread_mutex_unlock(&_mutex);
        return;
    }
    self.error = error;
    self.rejected = YES;
    for (KSPromiseCallbacks *callbacks in self.callbacks) {
        id nextValue = self.error;
        if (callbacks.errorCallback) {
            nextValue = callbacks.errorCallback(error);
        } else if (callbacks.deprecatedErrorCallback) {
            callbacks.deprecatedErrorCallback(self);
            continue;
        }
        [self resolvePromise:callbacks.childPromise withValue:nextValue];
    }
    [self finish];
    pthread_mutex_unlock(&_mutex);
}

- (void)resolvePromise:(KSPromise *)promise withValue:(id)value {
    pthread_mutex_lock(&_mutex);
    if ([value isKindOfClass:[KSPromise class]]) {
        [value then:^id(id value) {
            [promise resolveWithValue:value];
            return value;
        } error:^id(NSError *error) {
            [promise rejectWithError:error];
            return error;
        }];
    } else if ([value isKindOfClass:[NSError class]]) {
        [promise rejectWithError:value];
    } else {
        [promise resolveWithValue:value];
    }
    pthread_mutex_unlock(&_mutex);
}

- (void)finish {
    pthread_mutex_lock(&_mutex);
    for (KSPromiseCallbacks *callbacks in self.callbacks) {
        if (callbacks.deprecatedCompleteCallback) {
            callbacks.deprecatedCompleteCallback(self);
        }
    }
    [self.callbacks removeAllObjects];
    dispatch_semaphore_signal(_sem);
    pthread_mutex_unlock(&_mutex);
}

- (BOOL)completed {
    pthread_mutex_lock(&_mutex);
    BOOL completed = self.fulfilled || self.rejected;
    pthread_mutex_unlock(&_mutex);
    return completed;
}

#pragma mark - Deprecated methods
- (void)whenResolved:(deferredCallback)callback {
    pthread_mutex_lock(&_mutex);
    if (self.fulfilled) {
        callback(self);
        pthread_mutex_unlock(&_mutex);
    } else if (!self.cancelled) {
        KSPromiseCallbacks *callbacks = [[KSPromiseCallbacks alloc] init];
        callbacks.deprecatedFulfilledCallback = callback;
        [self.callbacks addObject:callbacks];
        pthread_mutex_unlock(&_mutex);
    }
}

- (void)whenRejected:(deferredCallback)callback {
    pthread_mutex_lock(&_mutex);
    if (self.rejected) {
        callback(self);
        pthread_mutex_unlock(&_mutex);
    } else if (!self.cancelled) {
        KSPromiseCallbacks *callbacks = [[KSPromiseCallbacks alloc] init];
        callbacks.deprecatedErrorCallback = callback;
        [self.callbacks addObject:callbacks];
        pthread_mutex_unlock(&_mutex);
    }
}

- (void)whenFulfilled:(deferredCallback)callback {
    pthread_mutex_lock(&_mutex);
    if ([self completed]) {
        callback(self);
        pthread_mutex_unlock(&_mutex);
    } else if (!self.cancelled) {
        KSPromiseCallbacks *callbacks = [[KSPromiseCallbacks alloc] init];
        callbacks.deprecatedCompleteCallback = callback;
        [self.callbacks addObject:callbacks];
        pthread_mutex_unlock(&_mutex);
    }
}

#pragma mark - Private methods
- (void)joinedPromiseFulfilled:(KSPromise *)promise {
    pthread_mutex_lock(&_mutex);
    if ([self completed]) {
        pthread_mutex_unlock(&_mutex);
        return;
    }
    
    BOOL fulfilled = YES;
    NSMutableArray *errors = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    for (KSPromise *joinedPromise in self.parentPromises) {
        fulfilled = fulfilled && joinedPromise.completed;
        if (joinedPromise.rejected) {
            id error = joinedPromise.error ? joinedPromise.error : [NSNull null];
            [errors addObject:error];
        } else if (joinedPromise.fulfilled) {
            id value = joinedPromise.value ? joinedPromise.value : [NSNull null];
            [values addObject:value];
        }
    }
    if (fulfilled) {
        if (errors.count > 0) {
            NSDictionary *userInfo = @{KSPromiseWhenErrorErrorsKey: errors,
                                       KSPromiseWhenErrorValuesKey: values};
            NSError *whenError = [NSError errorWithDomain:KSPromiseWhenErrorDomain
                                                     code:1
                                                 userInfo:userInfo];
            [self rejectWithError:whenError];
        } else {
            [self resolveWithValue:values];
        }
    }
    pthread_mutex_unlock(&_mutex);
}

@end
