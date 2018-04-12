//
//  String+ExpirationDate.swift
//  RxSwift-1
//
//  Created by Admin  on 4/4/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import Foundation

extension String {
    
    func rw_addSlash() -> String {
        guard self.characters.count > 2 else {
            //Nothing to add
            return self
        }
        
        let index2 = self.index(self.startIndex, offsetBy: 2)
        // let firstTwo = self.substring(to: index2)
        let firstTwo = self[...index2]
        // let rest = self.substring(from: index2)
        let rest = self[index2...]
        
        return firstTwo + " / " + rest
    }
    
    func rw_removeSlash() -> String {
        let removedSpaces = self.rw_removeSpaces()
        return removedSpaces.replacingOccurrences(of: "/", with: "")
    }
    
    func rw_isValidExpirationDate() -> Bool {
        let noSlash = self.rw_removeSlash()
        
        guard noSlash.characters.count == 6 //Must be mmyyyy
            && noSlash.rw_allCharactersAreNumbers() else { //must be all numbers
                return false
        }
        
        let index2 = self.index(self.startIndex, offsetBy: 2)
        // let monthString = self.substring(to: index2)
        let monthString = self[...index2]
        // let yearString = self.substring(from: index2)
        let yearString = self[index2...]
        
        guard
            let month = Int(monthString),
            let year = Int(yearString) else {
                //We can't even check.
                return false
        }
        
        //Month must be between january and december.
        guard (month >= 1 && month <= 12) else {
            return false
        }
        
        let now = Date()
        let currentYear = now.rw_currentYear()
        
        guard year >= currentYear else {
            //Year is before current: Not valid.
            return false
        }
        
        if year == currentYear {
            let currentMonth = now.rw_currentMonth()
            guard month >= currentMonth else {
                //Month is before current in current year: Not valid.
                return false
            }
        }
        
        //If we made it here: Woo!
        return true
    }
}
