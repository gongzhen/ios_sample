//
//  CarWithClosure.swift
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

import UIKit

typealias SpeedUpdateHandler = (Float) -> ()

final class CarWithClousre {
    private var observers: [SpeedUpdateHandler] = [] // 2 List of registered observers
    var speed: Float = 0 {
        didSet {
            for observer in observers { // 3 Notify all observers of the change
                print("didSet spped:\(speed)")
                observer(speed)
            }
        }
    }
    
    func add(observer: @escaping SpeedUpdateHandler) {
        observers.append(observer)
    }
    
    func accelerate(amount: Float) {
        speed += amount
    }
}

public class MainClosure {
    public func main() {
        // protocol
        observableClosure()
    }
    
    public func observableClosure() {
        let car = CarWithClousre() // 4 Instantiate a car
        
        car.add(observer: { speed in
            print("Current speed: \(speed)")
        }) // 5 Register an observer
        
        car.accelerate(amount: 10) // 6 call method that triggers updates
        car.accelerate(amount: 20)
        car.accelerate(amount: 30)
    }
}
