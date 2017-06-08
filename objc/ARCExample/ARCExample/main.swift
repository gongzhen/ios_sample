//
//  main.swift
//  ARCExample
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

// weak reference

class Person {
    let name: String
    init(name:String) {self.name = name}
    var apartment:Apartment?
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    let unit: String
    init(unit:String) {self.unit = unit}
    weak var tanant:Person?
    deinit {
        print("\(unit) is being deinitialized")
    }
}

var john:Person?
var unit4A:Apartment?
john = Person(name: "john dan")
unit4A = Apartment(unit:"4A")

john!.apartment = unit4A
unit4A!.tanant = john

john = nil
unit4A = nil

// unowned reference

class Customer {
    let name: String
    var card: CreditCard?
    
    init(name:String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class CreditCard {
    let number:UInt64
    unowned let customer:Customer
    init(number:UInt64, customer:Customer) {
        self.number = number
        self.customer = customer
    }
    
    deinit { print("Card #\(number) is being deinitialized") }
}

var don:Customer?
don = Customer(name: "Don Dong")

don!.card = CreditCard(number: 123411111, customer: don!)

don = nil

// both properties should always have value

class Country {
    let name:String
    var capitalCity:City!
    init(name:String, capitalName:String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    
    init(name:String, country:Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")

print("Hello, World!")

// weak delegate
// https://krakendev.io/blog/weak-and-unowned-references-in-swift

class Jason: TrapStoneDelegate{
    // CIA holds a strong reference to Jason in its agent property
    let agent = CIA()
    init() {
        agent.delegate = self
    }
    
    deinit {
        print("Jason is being deinitialized")
    }
    
    func startTrapstone() {
        print("jason start trap stone")
    }
}

// class type protocol for reference semantics rather than value semantics.
protocol TrapStoneDelegate: class {
    func startTrapstone()
}

class CIA {
    // Non class type protocols cannot be marked as weak
    weak var delegate: TrapStoneDelegate?
    
    deinit {
        print("CIA is being deinitialized")
    }
    
    func takeOutJason() {
        delegate?.startTrapstone()
    }
}

var jason = Jason()
var cia = CIA()
jason.startTrapstone()
print(jason.agent)

