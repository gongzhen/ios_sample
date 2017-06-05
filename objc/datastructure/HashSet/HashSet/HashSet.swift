
//
//  HashSet.swift
//  HashSet
//
//  Created by zhen gong on 6/4/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

public struct HashSet<T: Hashable> {
    // Create dictionary for storing data
    internal var dictionary = Dictionary<T, Bool>()
    
    public mutating func insert(element: T) {
        dictionary[element] = true
    }
    
    public mutating func remove(element: T) {
        dictionary[element] = nil
    }
    
    public func contains(element: T) -> Bool {
        return dictionary[element] != nil
    }
    
    public func allElements() -> [T] {
        return Array(dictionary.keys)
    }
    
    public var count: Int {
        return dictionary.count
    }
    
    public var isEmpty: Bool {
        return dictionary.isEmpty
    }
}

extension HashSet {
    public func union(otherSet: HashSet<T>) -> HashSet<T> {
        var combined = HashSet<T>()
        for obj in dictionary.keys {
            combined.insert(element: obj)
        }
        for obj in otherSet.dictionary.keys {
            combined.insert(element: obj)
        }
        return combined
    }
    
    public func intersect(otherSet: HashSet<T>) -> HashSet<T> {
        var common = HashSet<T>()
        for obj in dictionary.keys {
            if otherSet.contains(element: obj) {
                common.insert(element: obj)
            }
        }
        return common
    }
    
    public func difference(otherSet: HashSet<T>) -> HashSet<T> {
        var diff = HashSet<T>()
        for obj in dictionary.keys {
            if !otherSet.contains(element: obj) {
                diff.insert(element: obj)
            }
        }
        return diff
    }
}
