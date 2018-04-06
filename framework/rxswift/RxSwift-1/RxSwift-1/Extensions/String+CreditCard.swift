//
//  String+CreditCard.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import Foundation

// https://useyourloaf.com/blog/swift-string-cheat-sheet/
extension String {
    
    func rw_allCharactersAreNumbers() -> Bool {
        let nonNumberCharacterSet = NSCharacterSet.decimalDigits.inverted
        return (self.rangeOfCharacter(from: nonNumberCharacterSet) == nil)
    }
    
    
    func rw_integerValueOfFirst(characters: Int) -> Int {
        guard rw_allCharactersAreNumbers() else {
            return NSNotFound
        }
        
        if characters > self.characters.count {
            return NSNotFound
        }
        
        let indexToStopAt = self.index(self.startIndex, offsetBy: characters)
        // let substring = self.substring(to: indexToStopAt)
        let substring = self[...indexToStopAt]
        guard let integerValue = Int(substring) else {
            return NSNotFound
        }
        
        return integerValue
    }
    
    
    func rw_isLuhnValid() -> Bool {
        //https://www.rosettacode.org/wiki/Luhn_test_of_credit_card_numbers
        
        guard self.rw_allCharactersAreNumbers() else {
            //Definitely not valid.
            return false
        }
        
        let reversed = self.characters.reversed().map { String($0) }
        
        var sum = 0
        for (index, element) in reversed.enumerated() {
            guard let digit = Int(element) else {
                //This is not a number.
                return false
            }
            
            if index % 2 == 1 {
                //Even digit
                switch digit {
                case 9:
                    //Just add nine.
                    sum += 9
                default:
                    //Multiply by 2, then take the remainder when divided by 9 to get addition of digits.
                    sum += ((digit * 2) % 9)
                }
            } else {
                //Odd digit
                sum += digit
            }
        }
        
        //Valid if divisible by 10
        return sum % 10 == 0
    }
    
    func rw_removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
