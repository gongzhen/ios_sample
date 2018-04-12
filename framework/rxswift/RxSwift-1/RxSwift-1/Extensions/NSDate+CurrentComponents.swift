//
//  NSDate+CurrentComponents.swift
//  RxSwift-1
//
//  Created by Admin  on 4/4/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import Foundation

extension Date {
    
    static func rw_gregorianCalendar() -> NSCalendar {
        //All the years we're dealing with are in the gregorian calendar, so use that in case the system calendar is different.
        guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else {
            fatalError("Couldn't instantiate gregorian calendar?!")
        }
        
        return calendar
    }
    
    func rw_currentYear() -> Int {
        return Date
            .rw_gregorianCalendar()
            .component(.year, from: self)
    }
    
    func rw_currentMonth() -> Int {
        return Date
            .rw_gregorianCalendar()
            .component(.month, from: self)
    }
}
