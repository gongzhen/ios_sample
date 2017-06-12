//
//  Array.swift
//  TestGCD
//
//  Created by zhen gong on 6/11/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/28891878/how-to-declare-a-multidimensional-boolean-array-in-swift
// https://gist.github.com/hansott/a50f11dd106bf82f83ad
class Array2D<T> {
    let columns: Int
    let rows: Int
    
    var array:Array<Array<T>>
    
    init(columns:Int, rows:Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        self.array = Array(repeating:Array(repeating:initialValue, count:columns), count:rows)
    }
    
    subscript(row:Int, column:Int) -> T {
        get {
            return array[row][column]
        }
        set(newValue) {
            array[row][column] = newValue
        }
    }
}

//[[false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false, false, false, false]]
