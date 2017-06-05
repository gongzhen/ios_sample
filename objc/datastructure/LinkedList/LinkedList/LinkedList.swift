
//
//  LinkedList.swift
//  LinkedList
//
//  Created by zhen gong on 6/4/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

public final class LinkedList<T> {
    
    public class LinkedListNode<T> {
        var value:T
        var next:LinkedListNode?
        
        weak var previous:LinkedListNode?
        
        public init(value:T) {
            self.value = value
        }
    }
    
    public typealias Node = LinkedListNode<T>
    
    fileprivate var head:Node?
    
    public init() {}
    
    public var isEmpty:Bool {
        return head == nil
    }
    
    public var first:Node? {
        return head
    }
    
    public var last:Node? {
        if var node = head {
//            while case let next? = node.next {
//                node = next
//            }
            
            while node.next != nil {
                node = node.next!
            }
            return node
        } else {
            return nil
        }
    }
    
    public var count: Int {
        if var node = head {
            var c = 1
            while case let next? = node.next {
                node = next
                c += 1
            }
            return c
        } else {
            return 0
        }
    }
    
    public func node(atIndex index: Int) -> Node? {
        if index >= 0 {
            var node = head
            var i = 0
            while i != index {
                if node == nil {
                    break
                }
                node = node!.next
                i += 1
            }
            
            return node
        } else {
            return nil
        }
    }
    
    public subscript(index: Int) -> T {
        let node = self.node(atIndex: index)
        assert(node != nil)
        return node!.value
    }
    
    public func append(_ value: T) {
        let newNode = Node(value: value)
        self.append(newNode)
    }
    
    public func append(_ node: Node) {
        let newNode = LinkedListNode(value: node.value)
        if let lastNode = self.last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    
    public func append(_ list: LinkedList) {
        var nodeToCopy = list.head
        while let node = nodeToCopy {
            self.append(node.value)
            nodeToCopy = node.next
        }
    }
    
    // By Chris
    private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
        assert(index >= 0)
        let i = index
        var prev:Node?
        if  i - 1 < 0 {
            prev = nil
        } else {
            prev = self.node(atIndex: i - 1)
        }
        
        var next:Node?
        if i >= self.count {
            next = nil
        } else {
            next = self.node(atIndex: i)
        }
        return (prev, next)
    }
    
    public func insert(_ value: T, atIndex index: Int) {
        let newNode = Node(value: value)
        self.insert(newNode, atIndex: index)
    }

    public func insert(_ node: Node, atIndex index: Int) {
        let (prev, next) = self.nodesBeforeAndAfter(index: index)
        let newNode = LinkedListNode(value: node.value)
        newNode.previous = prev
        newNode.next = next
        prev?.next = newNode
        next?.previous = newNode
        if prev == nil {
            head = newNode
        }
    }
    
    // By Chris
    public func insert(_ list: LinkedList, atIndex index: Int) {
        if list.isEmpty { return }
        
        let (prev, next) = self.nodesBeforeAndAfter(index: index)
        
        let insertedHead = list.head
        let insertedLast = list.last
        
        insertedHead?.previous = prev
        prev?.next = insertedHead
        insertedLast?.next = next
        next?.previous = insertedLast
        
        if prev == nil {
            head = insertedHead
        }
    }
    
    public func removeAll() {
        head = nil
    }
    
    @discardableResult public func remove(node: Node) -> T {
        // how to check node is at the list.
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        
        next?.previous = prev
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    @discardableResult public func removeLast() -> T {
        assert(self.isEmpty != true)
        return self.remove(node: self.last!)
    }
    
    @discardableResult public func remove(atIndex index: Int) -> T {
        let node = self.node(atIndex: index)
        assert(node != nil)
        return self.remove(node: node!)
    }
    
}

extension LinkedList:CustomStringConvertible {
    public var description:String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

extension LinkedList {
    // By Gong Zhen:
    //@todo:swap two objects.
    public func reverseByChris() {
        var currentNode = self.head
        var tmp:Node?
        while currentNode != nil {
            tmp = currentNode?.previous
            currentNode?.previous = currentNode?.next
            currentNode?.next = tmp
            print(tmp?.value ?? "No value")
            print(currentNode?.value ?? "No value")
            print(currentNode?.previous?.value ?? "No value")
            print(currentNode?.next?.value ?? "No value")
            currentNode = currentNode?.previous
        }
        self.head = tmp
    }
    
    public func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
}

extension LinkedList {
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while node != nil {
            result.append(transform(node!.value))
            node = node!.next
        }
        return result
    }
    
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while node != nil {
            if predicate(node!.value) {
                result.append(node!.value)
            }
            node = node!.next
        }
        return result
    }

}

extension LinkedList {
    
    convenience init(array: Array<T>) {
        self.init()
        
        for element in array {
            self.append(element)
        }
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        
        for element in elements {
            self.append(element)
        }
    }
}
