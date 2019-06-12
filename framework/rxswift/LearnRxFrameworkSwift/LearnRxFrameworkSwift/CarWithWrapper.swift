//
//  CarWithWrapper.swift
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

import Foundation

typealias SpeedUpdateHandlerClosure = (Float) -> ()

typealias ObserverToken = String

class SpeedUpdateHandlerWrapper {
    let identity: ObserverToken = UUID().uuidString
    let observer: SpeedUpdateHandlerClosure
    
    init(wrapping observer: @escaping SpeedUpdateHandlerClosure) {
        self.observer = observer
    }
}


final class CarWithWrapper {

    private var observers: [SpeedUpdateHandlerWrapper] = [] // 2 List of registered observers
    var speed: Float = 0 {
        didSet {
            for wrapper in observers { // 3 Notify all observers of the change
                wrapper.observer(speed)
            }
        }
    }
    
    func add(observer: @escaping SpeedUpdateHandlerClosure) -> ObserverToken {
        let wrapper = SpeedUpdateHandlerWrapper(wrapping: observer)
        observers.append(wrapper)
        return wrapper.identity
    }
    
    func removeObserver(token: ObserverToken) {
        observers.removeAll { $0.identity == token }
    }
    
    func accelerate(amount: Float) {
        speed += amount
    }
}

// MARK - Usage

class SpeedometerWrapper {
    func show(speed: Float) {
        print("New speed \(speed)")
    }
    
    var car: CarWithWrapper
    var observerToken: ObserverToken!
    
    init(car: CarWithWrapper) {
        self.car = car
        self.observerToken = car.add { [weak self] speed in
            self?.show(speed: speed)
        }
    }
    
    deinit {
        car.removeObserver(token: observerToken)
    }
}

public class MainWrapper {
    public func main() {
        // protocol
        observableWrapper()
    }
    
    public func observableWrapper() {
        let car = CarWithWrapper() // 4 Instantiate a car
        
        var speedometer: SpeedometerWrapper? = SpeedometerWrapper(car: car)
        
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
