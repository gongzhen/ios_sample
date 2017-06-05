//
//  main.swift
//  HashSet
//
//  Created by zhen gong on 6/4/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation
// https://stackoverflow.com/questions/35840888/putting-two-generic-arrays-into-one-swift-dictionary-with-generics
enum Key: Equatable, Hashable {
    case IntKey(Int)
    case StringKey(String)
    
    var hashValue: Int {
        switch self {
        case .IntKey(let value)     : return 0.hashValue ^ value.hashValue
        case .StringKey(let value)  : return 1.hashValue ^ value.hashValue
        }
    }
    
    init(_ value: Int)    { self = .IntKey(value) }
    init(_ value: String) { self = .StringKey(value) }
}

func == (lhs: Key, rhs: Key) -> Bool {
    switch (lhs, rhs) {
    case (.IntKey(let lhsValue),    .IntKey(let rhsValue))    : return lhsValue == rhsValue
    case (.StringKey(let lhsValue), .StringKey(let rhsValue)) : return lhsValue == rhsValue
    default: return false
    }
}

//enum Value {
//    case IntValue(Int)
//    case StringValue(String)
//    
//    init(_ value: Int)    { self = .IntValue(value) }
//    init(_ value: String) { self = .StringValue(value) }
//}

var dict = [Key: Bool]()

dict[Key(1)] = true
dict[Key(2)] = true
dict[Key("Three")] = false
dict[Key("Four")] = false

var set = HashSet(dictionary: dict)

print(set.allElements())

let key1 = Key.IntKey(5)

set.insert(element: key1)
print(set.allElements())
set.insert(element: key1)
print(set.allElements())

print("Hello, World!")

struct Country {
    let name: String
    let capital: String
    var visited: Bool
}

extension Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name &&
            lhs.capital == rhs.capital &&
            lhs.visited == rhs.visited
    }
}

extension Country: Hashable {
    var hashValue: Int {
        return name.hashValue ^ capital.hashValue ^ visited.hashValue
    }
}

let british = Country(name: "British", capital: "London", visited: false)
let france = Country(name: "France", capital: "Paris", visited: false)

var dict1 = [Country: Bool]()
dict1[british] = true
dict1[france] = true

var countrySet = HashSet(dictionary: dict1)

print(countrySet.allElements())

