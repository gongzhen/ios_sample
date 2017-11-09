//
//  ProfileViewModel.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import UIKit

enum ProfileViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItem]()
    
    override init() {
        super.init()
        
        guard let data = dataFromFile("ServerData") else {
            return
        }
        
        print(data)
    }
    
}

extension ProfileViewModel : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
//        switch item.type {
//        case .nameAndPicture:
//
//        case .about:
//
//        case .email:
//
//        case .friend:
//
//        case .attribute:
//
//        }
        return UITableViewCell()
    }
}
