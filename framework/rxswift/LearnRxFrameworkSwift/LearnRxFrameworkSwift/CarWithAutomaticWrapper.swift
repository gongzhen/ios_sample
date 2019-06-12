//
//  CarWithAutomaticWrapper.swift
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

import Foundation

typealias AutomaticWrapperSpeedUpdateHandlerClosure = (Float) -> ()

class ObserverTokenClass {
    let unsubscribe: () -> ()
    
    init(unsubscribe: @escaping () -> ()) {
        self.unsubscribe = unsubscribe
    }
    
    deinit {
        unsubscribe()
    }
}

class AutomaticSpeedUpdateHandlerWrapper {
    let identity: String = UUID().uuidString
    let observer: SpeedUpdateHandler
    
    init(wrapping wrapped: @escaping SpeedUpdateHandler) {
        self.observer = wrapped
    }
}

class CarWithAutomaticWrapper {
    private var observers: [AutomaticSpeedUpdateHandlerWrapper] = [] // 2 List of registered observers
    var speed: Float = 0 {
        didSet {
            for wrapper in observers { // 3 Notify all observers of the change
                wrapper.observer(speed)
            }
        }
    }
    
    func add(observer: @escaping AutomaticWrapperSpeedUpdateHandlerClosure) -> ObserverTokenClass {
        let wrapper = AutomaticSpeedUpdateHandlerWrapper(wrapping: observer)
        observers.append(wrapper)
        return ObserverTokenClass(unsubscribe: {
            self.removeObserver(token: wrapper.identity)
        })
    }
    
    private func removeObserver(token: String) {
        observers.removeAll { $0.identity == token }
    }
    
    func accelerate(amount: Float) {
        speed += amount
    }
}

// MARK - Usage

class AutomaticWrapperSpeedometer {
    func show(speed: Float) {
        print("New speed \(speed)")
    }
    
    var car: CarWithAutomaticWrapper
    var observerToken: ObserverTokenClass!
    
    init(car: CarWithAutomaticWrapper) {
        self.car = car
        self.observerToken = car.add { [weak self] speed in
            self?.show(speed: speed)
        }
    }
    
    // REMOVE DEINIT FROM HERE
}

public class MainAutomaticWrapper {
    public func main() {
        // protocol
        observableAutomaticWrapper()
    }
    
    public func observableAutomaticWrapper() {
        let car = CarWithAutomaticWrapper() // 4 Instantiate a car
        
        var speedometer: AutomaticWrapperSpeedometer? = AutomaticWrapperSpeedometer(car: car)
        
        car.accelerate(amount: 10) // 6 call method that triggers updates
        car.accelerate(amount: 20)
        speedometer = nil // 7 dealloc speedometer remove observer
        car.accelerate(amount: 30) // 8 new updates do NOT get printed
        
        /*
         // CONSOLE OUTPUT:
         New speed 10.0
         New speed 30.0
         */
        
        
        //: [Next](@next)
    }
}

