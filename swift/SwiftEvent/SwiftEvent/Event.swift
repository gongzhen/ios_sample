
//
//  Event.swift
//  SwiftEvent
//
//  Created by zhen gong on 7/5/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//  https://gist.github.com/ColinEberhardt/05fafaca143ac78dbe09
//


import Foundation

public protocol Disposable {
    func dispose()
}

public class Event<T> {
    
    typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [Invocable]()
    
    public init() {
        
    }
    
    func addHandler<U: AnyObject>(target: U, handler:@escaping (U) -> EventHandler) -> Disposable {
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }
    
    public func raise(data:T) {
        for handler in eventHandlers {
            handler.invoke(data: data)
        }
    }
    
}

private protocol Invocable:class {
    func invoke(data: Any)
}

private class EventHandlerWrapper<T:AnyObject, U>: Invocable, Disposable {
    
    weak var target:T?
    
    let handler: (T) -> (U) -> ()
    
    let event:Event<U>
    
    init(target:T?, handler: @escaping (T) -> (U) -> (), event:Event<U>) {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(data:Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter({ (invocable) -> Bool in
            return invocable !== self
        })
    }
    
}


