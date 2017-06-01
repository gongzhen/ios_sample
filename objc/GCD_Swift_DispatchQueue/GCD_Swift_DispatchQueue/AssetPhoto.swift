
//
//  AssetPhoto.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation
import Photos

private let scale = UIScreen.main.scale
private let cellSize = CGSize(width: 64, height: 64)
private let thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
fileprivate let imageManager = PHImageManager()

class AssetPhoto: Photo {

    var statusImage: PhotoStatus = .downloading
    var statusThumbnail: PhotoStatus = .downloading
    var image: UIImage?
    var thumbnail: UIImage?
    
    let asset: PHAsset
    let representedAssetIdentifier: String
    private let targetSize: CGSize = CGSize(width:600, height:600)
    
    init(asset: PHAsset) {
        self.asset = asset
        self.representedAssetIdentifier = asset.localIdentifier
        fetchThumbnailImage()
        fetchImage()
    }
    
    private func fetchThumbnailImage() {
        // Request thumbnail
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        imageManager.requestImage(for: asset,
                                  targetSize: thumbnailSize,
                                  contentMode: .aspectFill,
                                  options: options)
        { image, info in
            if let image = image {
                if self.representedAssetIdentifier == self.asset.localIdentifier {
                    self.thumbnail = image
                    self.statusThumbnail = .goodToGo
                }
            } else if let info = info,
                let _ = info[PHImageErrorKey] as? NSError {
                self.statusThumbnail = .failed
            }
        }
    }
    
    private func fetchImage() {
        // Load a high quality image
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: targetSize,
                                              contentMode: .aspectFill,
                                              options: options)
        { image, info in
            if let image = image {
                if image.size.width < self.targetSize.width / 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: self.fetchImage)
                }
                if self.representedAssetIdentifier == self.asset.localIdentifier {
                    self.image = image
                    self.statusImage = .goodToGo
                }
            } else if let info = info,
                let _ = info[PHImageErrorKey] as? NSError {
                self.statusImage = .failed
            }
        }
    }
    
}
