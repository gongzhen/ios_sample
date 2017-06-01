//
//  PhotoCollectionViewCell.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
