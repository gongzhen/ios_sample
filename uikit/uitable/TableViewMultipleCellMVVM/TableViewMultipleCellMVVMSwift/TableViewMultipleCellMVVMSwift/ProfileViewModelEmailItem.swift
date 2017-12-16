//
//  ProfileViewModelEmailItem.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/26/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import Foundation

class ProfileViewModelEmailItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .email
    }
    
    var sectionTitle: String {
        return "Email"
    }
    
    var rowCount: Int {
        return 1
    }
    
    var email:String
    
    init(email: String) {
        self.email = email
    }
}
