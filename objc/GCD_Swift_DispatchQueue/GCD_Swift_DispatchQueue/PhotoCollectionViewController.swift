//
//  PhotoCollectionViewController.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let backgroundImageOpacity: CGFloat = 0.1

class PhotoCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background image setup
        let backgroundImageView = UIImageView(image: UIImage(named:"background"))
        backgroundImageView.alpha = backgroundImageOpacity
        backgroundImageView.contentMode = .center
        collectionView?.backgroundView = backgroundImageView
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentChangedNotification(_:)),
            name: NSNotification.Name(rawValue: photoManagerContentUpdatedNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentChangedNotification(_:)),
            name: NSNotification.Name(rawValue: photoManagerContentAddedNotification),
            object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOrHideNavPrompt()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }    

    // MARK: - IBAction Methods
    @IBAction func addPhotoAssets(_ sender: Any) {
        let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .actionSheet)
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Photo library button
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {
            _ in
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsStoryboard") as? UINavigationController
            if let viewController = viewController,
                let albumsTableViewController = viewController.topViewController as? AlbumsTableViewController {
                albumsTableViewController.assetPickerDelegate = self
                self.present(viewController, animated: true, completion: nil)
            }
        }
        alert.addAction(libraryAction)
        
        // Internet button
        let internetAction = UIAlertAction(title: "Le Internet", style: .default) { _ in
            self.downloadImageAssets()
        }
        alert.addAction(internetAction)
        
        // Present alert
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBAction Methods for callback closure
    
    @IBAction func replyCallBack(_ sender: UIBarButtonItem) {
        let email:String = "replyCallBack@caknow.com"
        var chris : String = "";
        print("1: replyCallBack")
        self.signup(email: email, vc: self) { (error:Error?, user:String?) in
            if let error = error {
                print(error)
                return
            } else if let user = user {
                print("9:\(user)")
                chris = user
            } else {
                print("no user return")
            }
        }
        print("5:\(chris)")
    }
}

// MARK: - Private Methods for callback closure methods

typealias ERROR_DATA_COMP = (_ error: Error?, _ data: String?) -> Void
typealias ERROR_USER_COMP = ((_ error: Error?, _ user:String?) -> Void)?

private extension PhotoCollectionViewController {
    func signup(email:String, vc:UICollectionViewDelegate, completion:ERROR_USER_COMP) {
        print("2: signup")
        let url = "signup->\(email)"
        self.runPost(url: url, vc: self) { (error, data) in
            if let comp = completion {
                if let err = error {
                    comp(err, nil)
                    return
                }
                
                if let user = data {
                    print("8:signup->\(user)")
                    comp(nil, user)
                }
            }
        }
    }
    
    func runPost(url:String, vc:UICollectionViewDelegate, completion:@escaping ERROR_DATA_COMP) {
        let url = "runPost->\(url)"
        print("3:\(url)")
        self.dataTask(url: url) { (user, error) in
            if let err = error {
                completion(err, nil)
                return
            }
            
            let data = "runPost->\(user!)"
            print("7:\(data)")
            completion(nil, data)
        }
        
    }
    
    func dataTask(url:String, completion:@escaping (String?, Error?)->Void) {
        let task = "dataTask:\(url)"
        print("4:\(task)")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            print("6:\(task)")
            completion(task, nil);
        }
        
    }
}

// MARK: - Private Methods
private extension PhotoCollectionViewController {
    func showOrHideNavPrompt() {
        // Implement me!
        let delayInSeconds = 2.0 // 1
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { // 2
            let count = PhotoManager.sharedManager.photos.count
            if count > 0 {
                self.navigationItem.prompt = nil
            } else {
                self.navigationItem.prompt = "Add photos with faces to Googlyify them!"
            }
        }
    }
    
    func downloadImageAssets() {
        PhotoManager.sharedManager.downloadPhotosWithCompletion() { error in
            // This completion block currently executes at the wrong time
            let message = error?.localizedDescription ?? "The images have finished downloading"
            let alert = UIAlertController(title: "Download Complete", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Notification handlers
extension PhotoCollectionViewController {
    func contentChangedNotification(_ notification: Notification!) {
        collectionView?.reloadData()
        showOrHideNavPrompt()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.sharedManager.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        // Configure the cell
        let photoAssets = PhotoManager.sharedManager.photos
        let photo = photoAssets[indexPath.row]
        
        switch photo.statusThumbnail {
        case .goodToGo:
            cell.thumbnailImage = photo.thumbnail
        case .downloading:
            cell.thumbnailImage = UIImage(named: "photoDownloading")
        case .failed:
            cell.thumbnailImage = UIImage(named: "photoDownloadError")
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photos = PhotoManager.sharedManager.photos
        let photo = photos[indexPath.row]
        
        switch photo.statusImage {
        case .goodToGo:
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailStoryboard") as? PhotoDetailViewController
            if let viewController = viewController {
                viewController.image = photo.image
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        case .downloading:
            let alert = UIAlertController(title: "Downloading",
                                          message: "The image is currently downloading",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        case .failed:
            let alert = UIAlertController(title: "Image Failed",
                                          message: "The image failed to be created",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - AssetPickerDelegate

extension PhotoCollectionViewController: AssetPickerDelegate {
    func assetPickerDidCancel() {
        // Dismiss asset picker
        dismiss(animated: true, completion: nil)
    }
    
    func assetPickerDidFinishPickingAssets(_ selectedAssets: [PHAsset])  {
        // Add assets
        for asset in selectedAssets {
            let photo = AssetPhoto(asset: asset)
            PhotoManager.sharedManager.addPhoto(photo)
        }
        // Dismiss asset picker
        dismiss(animated: true, completion: nil)
    }
}
