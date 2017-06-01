//
//  DownloadPhoto.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

typealias PhotoDownloadCompletionBlock = (_ image: UIImage?, _ error: NSError?) -> Void
typealias PhotoDownloadProgressBlock = (_ completed:Int, _ total: Int) -> Void

private let cellSize = CGSize(width: 64, height: 64)

class DownloadPhoto: Photo {
    var statusImage: PhotoStatus = .downloading
    var statusThumbnail: PhotoStatus = .downloading
    var image: UIImage?
    var thumbnail: UIImage?
    
    private let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    let url: URL
    
    init(url: URL, completion: PhotoDownloadCompletionBlock!) {
        self.url = url
        downloadImage(completion)
    }
    
    convenience init(url: URL) {
        self.init(url: url, completion: nil)
    }
    
    private func downloadImage(_ completion: PhotoDownloadCompletionBlock?) {
        let task = downloadSession.dataTask(with: url, completionHandler: {
            data, response, error in
            if let data = data {
                self.image = UIImage(data: data)
            }
            if error == nil && self.image != nil {
                self.statusImage = .goodToGo
                self.statusThumbnail = .goodToGo
            } else {
                self.statusImage = .failed
                self.statusThumbnail = .failed
            }
            
            self.thumbnail = self.image?.thumbnailImage(Int(cellSize.width),
                                                        transparentBorder: 0,
                                                        cornerRadius: 0,
                                                        interpolationQuality: CGInterpolationQuality.default)
            // (_ image: UIImage?, _ error: NSError?) -> Void
            completion?(self.image, error as NSError?)
            // It will send notification to notify change.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name(rawValue: photoManagerContentUpdatedNotification), object: nil)
            }
        })
        
        task.resume()
    }
}
