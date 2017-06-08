//
//  main.swift
//  Binary Search Tree
//
//  Created by zhen gong on 6/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

let tree = BinarySearchTree<Int>()

tree.insert(value: 5)
tree.insert(value: 1)
tree.insert(value: 9)
tree.insert(value: 6)
tree.insert(value: 7)
tree.insert(value: 12)
tree.insert(value: 10)
tree.insert(value: 15)

tree.printTree()

let toDelete = tree.search(value: 5)
print(toDelete?.getValue() ?? "no delete") // 6
print(toDelete?.getParent()?.getValue() ?? "no node") // 9
//let toTest = tree.search(value: 12)
//print(toTest?.parent?.value ?? "no parent") // 9
//let notFound = tree.search(value: 11)
//print(notFound?.value ?? "Not found") // no found
//let toLast = tree.search(value: 15)
//print(toLast?.parent?.value ?? "no parent") // 12
let result = tree.remove(node: toDelete!)
print(result?.getValue() ?? "nil") // 6 to replace 5
tree.printTree()
print(tree.debugDescription)




