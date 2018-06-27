//
//  AFAutoPurgingImageCache.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/24/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "AFAutoPurgingImageCache.h"

@interface AFCachedImage : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) UInt64 totalBytes;
@property (nonatomic, strong) NSDate *lastAccessDate;
@property (nonatomic, assign) UInt64 currentMemoryUsage;

@end

@implementation AFCachedImage

-(instancetype)initWithImage:(UIImage *)image identifier:(NSString *)identifier {
    if (self = [self init]) {
        self.image = image;
        self.identifier = identifier;
        
        CGSize imageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
        CGFloat bytesPerPixel = 4.0;
        CGFloat bytesPerSize = imageSize.width * imageSize.height;
        self.totalBytes = (UInt64)bytesPerPixel * (UInt64)bytesPerSize;
        self.lastAccessDate = [NSDate date];
    }
    return self;
}

- (UIImage*)accessImage {
    self.lastAccessDate = [NSDate date];
    return self.image;
}

- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"Idenfitier: %@  lastAccessDate: %@ ", self.identifier, self.lastAccessDate];
    return descriptionString;
    
}

@end

@interface AFAutoPurgingImageCache ()
@property (nonatomic, strong) NSMutableDictionary <NSString* , AFCachedImage*> *cachedImages;
@property (nonatomic, assign) UInt64 currentMemoryUsage;
@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@end

@implementation AFAutoPurgingImageCache

- (instancetype)init {
    //默认为内存100M，后者为缓存溢出后保留的内存
    return [self initWithMemoryCapacity:100 * 1024 * 1024 preferredMemoryCapacity:60 * 1024 * 1024];
}

/*
 声明了一个默认的内存缓存大小100M，还有一个意思是如果超出100M之后，我们去清除缓存，此时仍要保留的缓存大小60M。（如果还是不理解，可以看后文，源码中会讲到）
 创建了一个并行queue，这个并行queue，这个类除了初始化以外，所有的方法都是在这个并行queue中调用的。
 创建了一个cache字典，我们所有的缓存数据，都被保存在这个字典中，key为url，value为AFCachedImage。
 关于这个AFCachedImage，其实就是Image之外封装了几个关于这个缓存的参数，如下：
 */
- (instancetype)initWithMemoryCapacity:(UInt64)memoryCapacity preferredMemoryCapacity:(UInt64)preferredMemoryCapacity {
    if (self = [super init]) {
        //内存大小
        self.memoryCapacity = memoryCapacity;
        self.preferredMemoryUsageAfterPurge = preferredMemoryCapacity;
        //cache的字典
        self.cachedImages = [[NSMutableDictionary alloc] init];
        
        NSString *queueName = [NSString stringWithFormat:@"com.alamofire.autopurgingimagecache-%@", [[NSUUID UUID] UUIDString]];
        //并行的queue
        self.synchronizationQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        
        //添加通知，收到内存警告的通知
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(removeAllImages)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UInt64)memoryUsage {
    __block UInt64 result = 0;
    dispatch_sync(self.synchronizationQueue, ^{
        result = self.currentMemoryUsage;
    });
    return result;
}

- (void)addImage:(UIImage *)image withIdentifier:(NSString *)identifier {
    //用dispatch_barrier_async，来同步这个并行队列
    dispatch_barrier_async(self.synchronizationQueue, ^{
        //生成cache对象
        AFCachedImage *cacheImage = [[AFCachedImage alloc] initWithImage:image identifier:identifier];
        //去之前cache的字典里取
        AFCachedImage *previousCachedImage = self.cachedImages[identifier];
        //如果有被缓存过
        if (previousCachedImage != nil) {
            //当前已经使用的内存大小减去图片的大小
            self.currentMemoryUsage -= previousCachedImage.totalBytes;
        }
        //把新cache的image加上去
        self.cachedImages[identifier] = cacheImage;
        //加上内存大小
        self.currentMemoryUsage += cacheImage.totalBytes;
    });
    
    //做缓存溢出的清除，清除的是早期的缓存
    dispatch_barrier_async(self.synchronizationQueue, ^{
        //如果使用的内存大于我们设置的内存容量
        if (self.currentMemoryUsage > self.memoryCapacity) {
            //拿到使用内存 - 被清空后首选内存 =  需要被清除的内存
            UInt64 bytesToPurge = self.currentMemoryUsage - self.preferredMemoryUsageAfterPurge;
            //拿到所有缓存的数据
            NSMutableArray <AFCachedImage*> *sortedImages = [NSMutableArray arrayWithArray:self.cachedImages.allValues];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastAccessDate"
                                                                           ascending:YES];
            [sortedImages sortUsingDescriptors:@[sortDescriptor]];
            
            UInt64 bytesPurged = 0;
            
            for (AFCachedImage *cachedImage in sortedImages) {
                [self.cachedImages removeObjectForKey:cachedImage.identifier];
                bytesPurged += cachedImage.totalBytes;
                if (bytesPurged >= bytesToPurge) {
                    break ;
                }
            }
            self.currentMemoryUsage -= bytesPurged;
        }
    });
}

/*
 注意这个类大量的使用了dispatch_barrier_sync与dispatch_barrier_async，小伙伴们如果对这两个方法有任何疑惑，可以看看这篇文章：dispatch_barrier_async与dispatch_barrier_sync异同。
 1）这里我们可以看到使用了dispatch_barrier_sync，这里没有用锁，但是因为使用了dispatch_barrier_sync，不仅同步了synchronizationQueue队列，而且阻塞了当前线程，所以保证了里面执行代码的线程安全问题。
 2）在这里其实使用锁也可以，但是AF在这的处理却是使用同步的机制来保证线程安全，或许这跟图片的加载缓存的使用场景，高频次有关系，在这里使用sync，并不需要在去开辟新的线程，浪费性能，只需要在原有线程，提交到
 synchronizationQueue队列中，阻塞的执行即可。这样省去大量的开辟线程与使用锁带来的性能消耗。（当然这仅仅是我的一个猜测，有不同意见的朋友欢迎讨论~）
 在这里用了dispatch_barrier_sync，因为synchronizationQueue是个并行queue，所以在这里不会出现死锁的问题。
 关于保证线程安全的同时，同步还是异步，与性能方面的考量，可以参考这篇文章：Objc的底层并发API。
 */
- (BOOL)removeImageWithIdentifier:(NSString *)identifier {
    __block BOOL removed = NO;
    dispatch_barrier_sync(self.synchronizationQueue, ^{
        AFCachedImage *cachedImage = self.cachedImages[identifier];
        if (cachedImage != nil) {
            [self.cachedImages removeObjectForKey:identifier];
            self.currentMemoryUsage -= cachedImage.totalBytes;
            removed = YES;
        }
    });
    return removed;
}

- (BOOL)removeAllImages {
    __block BOOL removed = NO;
    dispatch_barrier_sync(self.synchronizationQueue, ^{
        if (self.cachedImages.count > 0) {
            [self.cachedImages removeAllObjects];
            self.currentMemoryUsage = 0;
            removed = YES;
        }
    });
    return removed;
}

- (nullable UIImage *)imageWithIdentifier:(NSString *)identifier {
    __block UIImage *image = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        AFCachedImage *cachedImage = self.cachedImages[identifier];
        image = [cachedImage accessImage];
    });
    return image;
}

- (void)addImage:(UIImage *)image forRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    [self addImage:image withIdentifier:[self imageCacheKeyFromURLRequest:request withAdditionalIdentifier:identifier]];
}

- (BOOL)removeImageforRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    return [self removeImageWithIdentifier:[self imageCacheKeyFromURLRequest:request withAdditionalIdentifier:identifier]];
}

- (nullable UIImage *)imageforRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    return [self imageWithIdentifier:[self imageCacheKeyFromURLRequest:request withAdditionalIdentifier:identifier]];
}

- (NSString *)imageCacheKeyFromURLRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)additionalIdentifier {
    NSString *key = request.URL.absoluteString;
    if (additionalIdentifier != nil) {
        key = [key stringByAppendingString:additionalIdentifier];
    }
    return key;
}

@end
#endif
