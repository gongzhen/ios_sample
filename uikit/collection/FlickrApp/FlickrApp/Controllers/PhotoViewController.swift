//
//  PhotoViewController.swift
//  FlickrApp
//
//  Created by zhen gong on 6/14/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    // MARK: Properties
    
    var keyboardOnScreen = false
    
    var collectionView:UICollectionView!
    // var collectionViewConstraint:NSLayoutConstraint! // Implicitly Unwrapped Optionals an optional’s value is confirmed to exist immediately after the optional is first defined
    var pictures:[Picture] = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addElements()
        NetworkingManager.sharedInstance.displayImageFromFlickrByGetList { (pictures, error) in
            if let error = error {
                print(error)
            } else if let pictures = pictures {
                self.pictures = pictures
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func addElements() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100.0, height: 100.0)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.lightGray
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary:[String: AnyObject] = ["collectionView": collectionView]
        let horizontalFormatString = "H:|-[collectionView]-|"
        let verticalFormatString = "V:|-[collectionView]-|"
        
        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: horizontalFormatString,
            options: [],
            metrics: nil,
            views: viewsDictionary)
        NSLayoutConstraint.activate(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: verticalFormatString,
            options: [],
            metrics: nil,
            views: viewsDictionary)
        NSLayoutConstraint.activate(verticalConstraint)
    }

    // MARK: Flickr API
    
    private func displayImageFromFlickrByGetList(_ methodParameters:[String: AnyObject]) {
        let session = URLSession.shared
        var component = URLComponents()
        component.host = "api.flickr.com"
        component.path = "/services/rest"
        component.scheme = "https"
        
        // initialize queryItems array.
        component.queryItems = [URLQueryItem]()
        
        for (key, value) in methodParameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            component.queryItems?.append(queryItem)
        }
        
        guard let url = component.url else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func displayError(_ error: String) {
                print(error)
                
            }
            
            guard error == nil else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= statusCode else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let parsedData:[String: AnyObject]
            
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let stat = parsedData["stat"] as? String, stat == "ok" else {
                displayError("Flickr API returned an error. See error code and message in \(parsedData)")
                return
            }
            
            guard let photosDictionary = parsedData["photos"] as? [String: AnyObject] else {
                displayError("Cannot find key photos in \(parsedData)")
                return
            }
            
            guard let photosArray = photosDictionary["photo"] as? [[String:AnyObject]] else {
                return
            }
            
            if photosArray.count  == 0 {
                displayError("No Photos Found. Search Again.")
                return
            } else {
                for photoDict in photosArray {
                    let photo = Picture(dictionary: photoDict)
                    print(photo)
                    self.pictures.append(photo)
                }
                // Update UI from background thread will cause program crash.
                // This application is modifying the autolayout engine from a background thread after the engine was accessed from the main thread. This can lead to engine corruption and weird crashes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }

    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
}

// MARK: - ViewController: UITextFieldDelegate

extension PhotoViewController: UITextFieldDelegate {
    
}

// MARK: - ViewController (Configure UI)

private extension PhotoViewController {
    
}

// MARK: - ViewController (Notifications)

private extension PhotoViewController {
    

}

// MARK: - ViewController (UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout)

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(frame: cell.contentView.frame)
        cell.contentView.addSubview(imageView)
        
        let picture = self.pictures[indexPath.row]
        let urlString = picture.url_q
        
        let session = URLSession.shared
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func displayError(_ error: String) {
                print(error)
                return
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                imageView.image = image
            }            
        }
        task.resume()
        return cell
    }
    
}
