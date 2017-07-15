//
//  ListViewController.swift
//  NSOperationSwift
//
//  Created by zhen gong on 6/30/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")

class ListViewController: UITableViewController {

    var photos = [PhotoRecord]()
    var pendingOperations = PendingOperations()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Classic Photos"
        fetchPhotoDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        //1 To provide feedback to the user, create a UIActivityIndicatorView and set it as the cell’s accessory view.
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        
        //2 The data source contains instances of PhotoRecord. Fetch the right one based on the current row’s indexPath.
        let photoDetails = photos[indexPath.row]
        
        //3
        cell.textLabel?.text = photoDetails.name
        cell.imageView?.image = photoDetails.image
        
        //4 Inspect the record. Set up the activity indicator and text as appropriate, and kick off the operations (not yet implemented)
    
        switch (photoDetails.state){
        case .Filtered:
            indicator.stopAnimating()
        case .Failed:
            indicator.stopAnimating()
            cell.textLabel?.text = "Failed to load"
        case .New, .Downloaded:
            indicator.startAnimating()
            
            // tell the table view to start operation only if the tableView is not scrolling.
            if (!tableView.isDragging && !tableView.isDecelerating){
                self.startOperationsForPhotoRecord(photoDetails: photoDetails,indexPath:indexPath)
            }
        }
        
        return cell
    }
    
    func startOperationsForPhotoRecord(photoDetails: PhotoRecord, indexPath: IndexPath){
        switch (photoDetails.state) {
        case .New:
            startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
        case .Downloaded:
            startFiltrationForRecord(photoDetails: photoDetails, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }
    
    func startDownloadForRecord(photoDetails: PhotoRecord, indexPath: IndexPath){
        //1 First, check for the particular indexPath to see if there is already an operation in downloadsInProgress for it. If so, ignore it.
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        //2 If not, create an instance of ImageDownloader by using the designated initializer.
        let downloader = ImageDownloader(photoRecord: photoDetails)
        //3 Add a completion block which will be executed when the operation is completed.
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        //4 Add the operation to downloadsInProgress to help keep track of things.
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5 Add the operation to the download queue.
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func startFiltrationForRecord(photoDetails: PhotoRecord, indexPath: IndexPath){
        if pendingOperations.filtrationsInProgress[indexPath] != nil{
            return
        }
        
        let filterer = ImageFiltration(photoRecord: photoDetails)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath as IndexPath], with: .fade)
            })
        }
        pendingOperations.filtrationsInProgress[indexPath] = filterer
        pendingOperations.filtrationQueue.addOperation(filterer)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 1 As soon as the user starts scrolling, you will want to suspend all operations and take a look at
        // what the user wants to see. You will implement suspendAllOperations in just a moment.
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 2 If the value of decelerate is false, that means the user stopped dragging the table view. Therefore you want to resume suspended operations, cancel operations for offscreen cells, and start operations for onscreen cells.
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 3 This delegate method tells you that table view stopped scrolling.
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
        pendingOperations.filtrationQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
        pendingOperations.filtrationQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        //1
        if let pathsArray = tableView.indexPathsForVisibleRows {
            //2
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            allPendingOperations.formUnion(pendingOperations.filtrationsInProgress.keys)
            
            //3
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //4
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            // 5
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if let pendingFiltration = pendingOperations.filtrationsInProgress[indexPath] {
                    pendingFiltration.cancel()
                }
                pendingOperations.filtrationsInProgress.removeValue(forKey: indexPath)
            }
            
            // 6
            for indexPath in toBeStarted {
                let recordToProcess = self.photos[indexPath.row]
                startOperationsForPhotoRecord(photoDetails: recordToProcess, indexPath: indexPath)
            }
        }
    }

}

extension ListViewController {

    // method to download the phpto property list
    func fetchPhotoDetails() {
        let request = URLRequest(url: dataSourceURL!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= statusCode else {
                return
            }
            
            guard let data = data else {
                
                return
            }
            
            do {
                let datasourceDictionary = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.ReadOptions(rawValue:UInt(Int(PropertyListSerialization.MutabilityOptions.mutableContainers.rawValue))), format: nil) as! NSDictionary

                for (key, value) in datasourceDictionary {
                    let name = key as? String
                    let url = URL(string:value as? String ?? "")
                    if name != nil && url != nil {
                        let photoRecord = PhotoRecord(name:name!, url:url!)
                        self.photos.append(photoRecord)
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            } catch let error as NSError {
                let alertController = UIAlertController(title: "opps", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(okAction)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }.resume()
        
        //    let request = URLRequest(url:dataSourceURL!)
        //    UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //
        //    NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {response,data,error in
        //      if data != nil {
        //        let datasourceDictionary = PropertyListSerialization.propertyListWithData(data, options: Int(PropertyListSerialization.MutabilityOptions.Immutable.rawValue), format: nil, error: nil) as! NSDictionary
        //
        //        for(key : AnyObject,value : AnyObject) in datasourceDictionary {
        //          let name = key as? String
        //          let url = NSURL(string:value as? String ?? "")
        //          if name != nil && url != nil {
        //            let photoRecord = PhotoRecord(name:name!, url:url!)
        //            self.photos.append(photoRecord)
        //          }
        //        }
        //
        //        self.tableView.reloadData()
        //      }
        //
        //      if error != nil {
        //        let alert = UIAlertView(title:"Oops!",message:error?.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
        //        alert.show()
        //      }
        //      UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //    }
    }

}
