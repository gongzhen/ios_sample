//
//  BinarySearchTree.swift
//  Binary Search Tree
//
//  Created by zhen gong on 6/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

public class BinarySearchTree<T: Comparable> {
    
    public class BinarySearchTreeNode<T> {
        var value: T
        var left:BinarySearchTreeNode?
        var right:BinarySearchTreeNode?
        var parent:BinarySearchTreeNode?
        
        public init(value: T, left:BinarySearchTreeNode?, right:BinarySearchTreeNode?, parent:BinarySearchTreeNode?) {
            self.value = value
            self.left = left
            self.right = right
            self.parent = parent
        }
        
        public func getParent() -> BinarySearchTreeNode? {
            return parent
        }
        
        public func reconnectParentToNode(replacement:BinarySearchTreeNode?) {
            if let parent = self.parent {
                if self.isLeftChild {
                    parent.left = replacement
                } else if self.isRightChild {
                    parent.right = replacement
//                    print("inside reconnectParentToNode self.value :", terminator:"")
//                    print(self.value)
//                    print("inside reconnectParentToNode self.parent.value :", terminator:"")
//                    print(self.parent?.value ?? "node no value")
//                    print("inside reconnectParentToNode self.parent.right?.value :", terminator:"")
//                    print(self.parent?.right?.value ?? "node no value")// no value
//                    print("inside reconnectParentToNode replacement node :", terminator:"")
//                    print(replacement?.value ?? "replacement is nill") //
//                    print("inside reconnectParentToNode self.value :", terminator:"")
//                    print(self.value)
                    
                }
            }
            replacement?.parent = parent
        }
        
        public var isLeftChild:Bool {
            return self.parent?.left === self
        }
        
        public var isRightChild: Bool {
            return self.parent?.right === self
        }
    }

    public typealias Node = BinarySearchTreeNode<T>
    
    fileprivate var root:Node?
    
    public init() {}
    
    public var rootNode:Node? {
        return root
    }
    
    
}

extension BinarySearchTree {
    
    // MARK: - Adding items
    
    public func insert(value: T) {
        self.root = self.insertRecursive(node: &root, value: value, parent: nil)
    }
    
    // MARK: - Searching item
    
    public func search(value: T) -> Node? {
        return search(node: root, value: value)
    }
    
    private func search(node: Node?, value: T) -> Node? {
        if let node = node {
            if value == node.value {
                return node
            } else if value < node.value {
                return self.search(node: node.left, value: value)
            } else {
                return self.search(node: node.right, value: value)
            }
        }
        return nil
    }
    
    @discardableResult public func remove(node:Node?) -> Node? {
        let replacement:Node?
        
        if let right = node?.right {
            replacement = minimum(node: right)
        } else if let left = node?.left {
            replacement = maximum(node: left)
        } else {
            replacement = nil
        }
        
        if let replacement = replacement {
            remove(node: replacement)
        }

//        print("reconnectParentToNode self.parent :", terminator:"")
//        print(parent.value)
//        print("reconnectParentToNode parent.right = node self.parent.right :", terminator:"")
//        print(parent.right?.value ?? "parent no right value")
        
        replacement?.right = node?.right
        replacement?.left = node?.left
        node?.right?.parent = replacement
        node?.left?.parent = replacement
        
        // remove node
        // repaced by replacement
        
        print("before reconnectParentToNode node :", terminator:"")
        print(node?.value ?? "node no value")
        print("before reconnectParentToNode node :", terminator:"")
        print(node?.value ?? "node no value")
        
        node?.reconnectParentToNode(replacement: replacement)
        
        print("after reconnectParentToNode node :", terminator:"")
        print(node?.value ?? "node no value")
        print("after reconnectParentToNode node :", terminator:"")
        print(node?.value ?? "node no value")
        
        if node?.parent == nil {
            // node is root
            self.root = replacement
        }
        node?.parent = nil
        node?.left = nil
        node?.right = nil
        return replacement
    }
    
    
    private func minimum(node:Node?) -> Node? {
        if var node = node {
            while case let left? = node.left {
                node = left
            }
            return node
        } else {
            return nil
        }
    }
    
    private func maximum(node: Node?) -> Node? {
        if var node = node {
            while case let right? = node.right {
                node = right
            }
            return node
        } else {
            return nil
        }
    }
    

    
    private func insertRecursive(node: inout Node?, value:T, parent: Node?) -> Node? {
        if let node = node {
            if value <= node.value {
                node.left = insertRecursive(node: &(node.left), value: value, parent:node)
            } else {
                node.right = insertRecursive(node:&(node.right), value: value, parent:node)
            }
        } else {
            node = Node(value: value, left: nil, right: nil, parent: parent)
        }
        return node
    }
    
    // MARK: - Print tree
    public func printTree() {
        if let root = root {
            var queue:[Node] = []
            queue.append(root)
            
            while !queue.isEmpty {
                let size = queue.count
                for _ in 0..<size {
                    let node = queue.remove(at: 0)
                    print("\(node.value),", terminator:"")
                    if let left = node.left {
                        queue.append(left)
                    }
                    if let right = node.right {
                       queue.append(right)
                    }
                }
                print("\n")
            }
        }
    }

}
