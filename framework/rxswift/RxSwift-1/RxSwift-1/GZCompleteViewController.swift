//
//  GZCompleteViewController.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import UIKit

class GZCompleteViewController: UIViewController {

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var creditCardIcon: UIImageView!
    
    var cardType: CardType = .Unknown {
        didSet {
            configureIconForCardType()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Configuration methods
    
    private func configureIconForCardType() {
        guard let imageView = creditCardIcon else {
            //View hasn't loaded yet, come back later.
            return
        }
        
        imageView.image = cardType.image
    }
    
    private func configureLabelsFromCart() {
        guard let costLabel = costLabel else {
            //View hasn't loaded yet, come back later.
            return
        }
        
        let cart = ShoppingCart.sharedCart
        
        costLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: cart.totalCost())
        
        orderLabel.text = cart.itemCountString()
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
