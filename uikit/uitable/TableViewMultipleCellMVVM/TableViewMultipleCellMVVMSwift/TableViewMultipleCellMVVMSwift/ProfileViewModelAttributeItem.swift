//
//  ProfileViewModelAttributeItem.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/26/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import Foundation

class ProfileViewModelAttributeItem: ProfileViewModelItem {
    
    var type: ProfileViewModelItemType {
        return .attribute
    }
    
    var sectionTitle: String {
        return "Attributes"
    }
    
    var rowCount: Int {
        return  attributes.count
    }
    
    var attributes:[Attribute]
    
    init(attributes:[Attribute]) {
        self.attributes = attributes
    }
}
