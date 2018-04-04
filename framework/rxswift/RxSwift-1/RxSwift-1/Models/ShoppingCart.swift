//
//  ShoppingCart.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import Foundation

class ShoppingCart {
    static let sharedCart = ShoppingCart()
    
    var chocolates = [Chocolate]()
    
    //MARK: Non-Mutating Functions
    
    func totalCost() -> Float {
        return chocolates.reduce(0) {
            runningTotal, chocolate in
            return runningTotal + chocolate.priceInDollars
        }
    }
    
    func itemCountString() -> String {
        guard chocolates.count > 0 else {
            return "🚫🍫"
        }
        
        //Unique the chocolates
        let setOfChocolates = Set<Chocolate>(chocolates)
        
        //Check how many of each exists
        let itemStrings: [String] = setOfChocolates.map {
            chocolate in
            let count: Int = chocolates.reduce(0) {
                runningTotal, reduceChocolate in
                if chocolate == reduceChocolate {
                    return runningTotal + 1
                }
                
                return runningTotal
            }
            
            return "\(chocolate.countryFlagEmoji)🍫: \(count)"
        }
        
        return itemStrings.joined(separator: "\n")
    }
}
