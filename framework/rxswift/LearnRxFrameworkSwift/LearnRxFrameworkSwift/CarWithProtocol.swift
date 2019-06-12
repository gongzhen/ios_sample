//
//  Car.swift
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

import UIKit

import Foundation

protocol CarObserver { // Observable protocol declaration
    func car(_ car: CarWithProtocol, didUpdateSpeedTo speed: Float)
}

final class CarWithProtocol {
    private var observers: [CarObserver] = [] // List of registered observers
    
    func add(observer: CarObserver) {
        observers.append(observer)
    }
    
    func accelerate(amount: Float) {
        speed += amount
    }
  
    var speed: Float = 0 {
        didSet {
            for observer in observers {
                print("observer: \(observer)")
                observer.car(self, didUpdateSpeedTo: speed)
            }
        }
    }
}

final class Speedometer: CarObserver {
    func car(_ car: CarWithProtocol, didUpdateSpeedTo speed: Float) {
        print("Speed: \(speed)")
    }
}

public class MainProtocol {
    public func main() {
        // protocol
        observableProtocol()
    }
    
    public func observableProtocol() {
        let car = CarWithProtocol()
        let speed = Speedometer()
        car.add(observer: speed)
        car.speed = 100
        car.speed = 140
        
        car.accelerate(amount: 10) // 6 call method that triggers updates
        car.accelerate(amount: 20)
        car.accelerate(amount: 30)
    }
}
