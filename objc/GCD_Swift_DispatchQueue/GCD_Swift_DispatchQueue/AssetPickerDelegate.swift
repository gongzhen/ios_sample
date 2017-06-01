//
//  AssetPickerDelegate.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation
import Photos

protocol AssetPickerDelegate {
    func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset])
    func assetPickerDidCancel()
}
