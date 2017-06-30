//
//  UIImage+UIColor.swift
//  CacheManager1
//
//  Created by zhen gong on 6/26/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

public extension UIImage {
    
    public convenience init?(color:UIColor, size:CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }        
        self.init(cgImage: cgImage)
    }

}
