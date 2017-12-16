//
//  FriendCell.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/26/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!    
    @IBOutlet weak var nameLabel: UILabel!
    
    var item:Friend? {
        didSet {
            guard let item = item  else {
                return
            }
            if let pictureUrl = item.pictureUrl {
                pictureImageView.image = UIImage(named: pictureUrl)
            }
            nameLabel.text = item.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImageView.layer.cornerRadius = 40
        pictureImageView.clipsToBounds = true
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
