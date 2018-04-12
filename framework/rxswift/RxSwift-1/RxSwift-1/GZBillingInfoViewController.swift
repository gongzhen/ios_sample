//
//  GZBillingInfoViewController.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import UIKit
import RxSwift

class GZBillingInfoViewController: UIViewController {

    @IBOutlet weak var creditCardNumberTextField: ValidatingTextField!
    @IBOutlet weak var creditCardImageView: UIImageView!
    @IBOutlet weak var expirationDateTextField: ValidatingTextField!
    @IBOutlet weak var cvvTextField: ValidatingTextField!
    @IBOutlet weak var purchaseButton: UIButton!
    
    private let cardType: Variable<CardType> = Variable(.Unknown)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "💳 Info"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let identifier = identifierForSegue(segue: segue)
        
        switch identifier {
        case .PurchaseSuccess:
            guard let destination = segue.destination as? GZCompleteViewController else {
                assertionFailure("Couldn't get chocolate is coming VC!")
                return
            }
            
            destination.cardType = cardType.value
        }
    }

}

// MARK: - SegueHandler
extension GZBillingInfoViewController: SegueHandler {
    enum SegueIdentifier: String {
        case
        PurchaseSuccess
    }
}
