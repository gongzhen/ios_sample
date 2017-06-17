//
//  main.swift
//  LinkedList
//
//  Created by zhen gong on 6/4/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

var list = LinkedListSequence<Int>()
list.append(value: 10)
list.append(value: 20)
list.append(value: 30)

for node in list {
    print("\(node)")
}

let values: [Int] = list.map {
    $0.value
}

print(list.start ?? "No start")
print(list.end ?? "No end")

print(list.count)

print(list.nodeAt(index: 0))
print(list.nodeAt(index: 1))
print(list.nodeAt(index: 2))

//let result = list.iterate { (node, index) -> Node<Int>? in
//    print("node:\(node.value)")
//    return node
//}
//print(result ?? "iterate nil")

// oneTwoThree is list
let oneTwoThree = 1...3

var listSequence = LinkedListSequence<Int>(oneTwoThree)
for node in listSequence {
    print("\(node)")
}

print("Hello, World!")

