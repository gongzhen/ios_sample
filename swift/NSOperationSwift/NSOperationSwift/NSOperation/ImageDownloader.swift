//
//  ImageDownloader.swift
//  NSOperationSwift
//
//  Created by zhen gong on 6/30/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ImageDownloader: Operation {

    //1 Add a constant reference to the PhotoRecord object related to the operation.
    let photoRecord : PhotoRecord
    
    //2 Create a designated initializer allowing the photo record to be passed in.
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    //3 main is the method you override in NSOperation subclasses to actually perform work.
    override func main(){
        
        //4 Check for cancellation before starting. Operations should regularly check if they have been cancelled before attempting long or intensive work.
        if self.isCancelled{
            return
        }
        //5 Download the image data.
        // let imageData = NSData(contentsOf: self.photoRecord.url as URL)
        // let imageData = Data(contentsOf: self.photoRecord.url)
        
        let imageData:Data? = try? Data(contentsOf: self.photoRecord.url)
        
        //6 Check again for cancellation.
        if self.isCancelled {
            return
        }
        
        //7 If there is data, create an image object and add it to the record, and move the state along. If there is no data, mark the record as failed and set the appropriate image.
        if (imageData?.count)! > 0 {
            self.photoRecord.image = UIImage(data: imageData! as Data)
            self.photoRecord.state = .Downloaded
        }
        else
        {
            self.photoRecord.state = .Failed
            self.photoRecord.image = UIImage(named: "Failed")
        }
        
    }

}
