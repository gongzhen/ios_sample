//
//  PhotoManager.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

// Notification when new photo instances are added
let photoManagerContentAddedNotification = "com.raywenderlich.GooglyPuff.PhotoManagerContentAdded"
// Notification when content updates (i.e. Download finishes)
let photoManagerContentUpdatedNotification = "com.raywenderlich.GooglyPuff.PhotoManagerContentUpdated"

// Photo Credit: Devin Begley, http://www.devinbegley.com/
let overlyAttachedGirlfriendURLString = "http://i.imgur.com/UvqEgCv.png"
let successKidURLString = "http://i.imgur.com/dZ5wRtb.png"
let lotsOfFacesURLString = "http://i.imgur.com/tPzTg7A.jpg"

typealias PhotoProcessingProgressClosure = (_ completionPercentage: CGFloat) -> Void
typealias BatchPhotoDownloadingCompletionClosure = (_ error: NSError?) -> Void

private let _sharedManager = PhotoManager()

class PhotoManager {
    
    class var sharedManager: PhotoManager {
        return _sharedManager
    }
    
    fileprivate let concurrentPhotoQueue = DispatchQueue(
        label: "com.raywenderlich.GooglyPuff.photoQueue", // 1: descriptive name that is helpful during debugging
        attributes: .concurrent) // 2
    
    fileprivate var _photos: [Photo] = []
    
//    var photos: [Photo] {
//        return _photos
//    }
    var photos: [Photo] {
        var photosCopy: [Photo]!
        concurrentPhotoQueue.sync { // 1
            photosCopy = self._photos // 2
        }
        return photosCopy
    }

    func addPhoto(_ photo: Photo) {
        concurrentPhotoQueue.async(flags: .barrier) { // 1: asynchronously with a barrier
            self._photos.append(photo) // 2
            DispatchQueue.main.async { // 3
                self.postContentAddedNotification()
            }
        }
//        _photos.append(photo)
//        DispatchQueue.main.async {
//            self.postContentAddedNotification()
//        }
    }
    
    func downloadPhotosWithCompletion(_ completion: BatchPhotoDownloadingCompletionClosure?) {
        var storedError: NSError?
        let downloadGroup = DispatchGroup() // 2
        
        for address in [overlyAttachedGirlfriendURLString,
                        successKidURLString,
                        lotsOfFacesURLString] {
                            let url = URL(string: address)
                            downloadGroup.enter() // 3
                            let photo = DownloadPhoto(url: url!, completion: { (image, error) in
                                if error != nil {
                                    storedError = error
                                }
                                downloadGroup.leave() // 4
                            })
                            PhotoManager.sharedManager.addPhoto(photo)
        }
        
//        completion?(storedError)

//        Dispatch_Groups 1
//        downloadGroup.wait() // 5: After running for loop and dispatch completion queue here.
//        DispatchQueue.main.async { // 6
//            completion?(storedError)
//        }

//        Dispatch_Groups 2        
        downloadGroup.notify(queue: DispatchQueue.main) { // 2
            completion?(storedError)
        }
    }
    
    fileprivate func postContentAddedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: photoManagerContentAddedNotification), object: nil)
    }
}
