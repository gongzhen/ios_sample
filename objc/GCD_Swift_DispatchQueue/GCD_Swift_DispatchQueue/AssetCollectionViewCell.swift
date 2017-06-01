//
//  AssetCollectionViewCell.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class AssetCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet fileprivate var checkMark: UIView?
    
    var representedAssetIdentifier: String!
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkMark?.isHidden = !isSelected
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }


}
