//
//  GZTableViewController.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GZTableViewController: UIViewController {
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    // let europeanChocolates = Chocolate.ofEurope
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chocolate!!!"
//        tableView.dataSource = self
//        tableView.delegate = self
        // tableView will be relaod here.
        setupCellConfiguration()
    }
    
    //MARK: Rx Set up
    
    private func setupCellConfiguration() {
        europeanChocolates
            .bind(to: tableView
            .rx.items(cellIdentifier: ChocolateCell.Identifier, cellType: ChocolateCell.self)) {
                row, chocolate, cell in
                cell.configureWithChocolate(chocolate: chocolate)
            }.disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        updateCartButton();
    }
    
    func updateCartButton() {
//        cartButton.title = "\(ShoppingCart.sharedCart.chocolates.count) 🍫"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension GZTableViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return europeanChocolates.count
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
//            //Something went wrong with the identifier.
//            return UITableViewCell()
//        }
//
//        let chocolate = europeanChocolates[indexPath.row]
//        cell.configureWithChocolate(chocolate: chocolate)
//
//        return cell
//    }
//}
//
//extension GZTableViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let chocolate = europeanChocolates[indexPath.row]
//        ShoppingCart.sharedCart.chocolates.append(chocolate)
//        updateCartButton()
//    }
//}

