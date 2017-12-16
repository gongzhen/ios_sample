//
//  ViewController.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//
//  https://github.com/gongzhen/TableViewMVVM
//  https://medium.com/ios-os-x-development/ios-aimate-tableview-updates-dc3df5b3fe07
//
import UIKit

class ViewController: UIViewController {

    fileprivate let viewModel = ProfileViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = viewModel
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        // let nibName = UINib(nibName: "AboutCell", bundle: nil)
        tableView.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        tableView.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
        tableView.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
        tableView.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

