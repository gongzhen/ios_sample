//
//  BinarySearchTree.swift
//  Binary Search Tree
//
//  Created by zhen gong on 6/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//  Resource: http://interactivepython.org/runestone/static/pythonds/Trees/SearchTreeImplementation.html#fig-bstdel2
//  https://stackoverflow.com/questions/13373854/binary-search-tree-java-implementation
//  http://algorithms.tutorialhorizon.com/binary-search-tree-complete-implementation/

import Foundation

public class BinarySearchTree<T: Comparable> {
    
    public class BinarySearchTreeNode<T> {
        fileprivate var value: T
        fileprivate var left:BinarySearchTreeNode?
        fileprivate var right:BinarySearchTreeNode?
        fileprivate var parent:BinarySearchTreeNode?
        
        public init(value: T, left:BinarySearchTreeNode?, right:BinarySearchTreeNode?, parent:BinarySearchTreeNode?) {
            self.value = value
            self.left = left
            self.right = right
            self.parent = parent
        }
        
        public func getParent() -> BinarySearchTreeNode? {
            return parent
        }
        
        public func getValue() -> T {
            return value
        }
        
        public var isLeftChild:Bool {
            return self.parent?.left === self
        }
        
        public var isRightChild: Bool {
            return self.parent?.right === self
        }
        
        // set self's parent's left or right point to replacement node.
        public func reconnectParentToNode(replacement:BinarySearchTreeNode?) {
            if let parent = self.parent {
                if self.isLeftChild {
                    parent.left = replacement
                } else if self.isRightChild {
                    parent.right = replacement
                }
            }
            replacement?.parent = parent
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

}

extension BinarySearchTree {
    
    // MARK: - Deleting items
    @discardableResult public func remove(node:Node?) -> Node? {
        let replacement:Node?
        
        if let right = node?.right {
            replacement = minimum(node: right)
        } else if let left = node?.left {
            replacement = maximum(node: left)
        } else {
            replacement = nil
        }
        
        // recusivly remove replacement.
        if let replacement = replacement {
            remove(node: replacement)
        }
        
        replacement?.right = node?.right
        replacement?.left = node?.left
        node?.right?.parent = replacement
        node?.left?.parent = replacement
        
        // remove node
        node?.reconnectParentToNode(replacement: replacement)
        
        if node?.parent == nil {
            // node is root
            self.root = replacement
        }
        node?.parent = nil
        node?.left = nil
        node?.right = nil
        return replacement
    }
    
}

// MARK: - Searching 

extension BinarySearchTree {
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
}

extension BinarySearchTree {
    
    
    public func minimum(node:Node?) -> Node? {
        if var node = node {
            while case let left? = node.left {
                node = left
            }
            return node
        } else {
            return nil
        }
    }
    
    public func maximum(node: Node?) -> Node? {
        if var node = node {
            while case let right? = node.right {
                node = right
            }
            return node
        } else {
            return nil
        }
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

extension BinarySearchTree: CustomDebugStringConvertible {
    
    public var debugDescription:String {
        var s = ""
        if let left = self.root?.left {
            s += "\(left.getValue()) <-"
        }
        
        if let root = self.root {
            s += "\(root.getValue())"
        } else {
            s = "no root"
        }
        
        if let right = self.root?.right {
            s += "-> \(right.getValue()) <-"
        }
        return s
    }
}
