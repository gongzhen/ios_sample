//
//  ImageFiltration.swift
//  NSOperationSwift
//
//  Created by zhen gong on 6/30/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ImageFiltration: Operation {
    let photoRecord: PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled{
            return
        }
        
        if self.photoRecord.state != .Downloaded {
            return
        }
        
        if let filteredImage = self.applySepiaFilter(image: self.photoRecord.image!) {
            self.photoRecord.image = filteredImage
            self.photoRecord.state = .Filtered
        }
    }
    
    func applySepiaFilter(image:UIImage) -> UIImage? {
        let inputImage = CIImage(data: UIImagePNGRepresentation(image)!)
        
        if self.isCancelled{
            return nil
        }
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: "inputIntensity")
        let outputImage = filter?.outputImage
        
        if self.isCancelled{
            return nil
        }
        
        let outImage = context.createCGImage(outputImage!, from: (outputImage?.extent)!)
        let returnImage = UIImage(cgImage: outImage!)
        return returnImage
    }
}
