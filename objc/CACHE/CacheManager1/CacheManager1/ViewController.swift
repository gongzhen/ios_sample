//
//  ViewController.swift
//  CacheManager1
//
//  Created by zhen gong on 6/26/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var imageView:UIImageView!
    let cache = NSCache<NSString, AnyObject>()
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cache.countLimit = 10
        print("viewDidLoad")
        tableView = UITableView(frame: view.frame, style: UITableViewStyle.plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cachedImage: UIImage? = cache.object(forKey: "\(indexPath.row)" as NSString) as? UIImage
        if let cachedImage = cachedImage {
            print("cached Image_\(indexPath.row):\(cachedImage)")
            cell.imageView?.image = cachedImage
            cell.textLabel?.text = "cached Image_\(indexPath.row))"
        } else {
            let image:UIImage = UIImage(color:getRandomColor(), size: CGSize(width: 240, height: 240))!
            cell.imageView?.image = image
            cache.setObject(image, forKey: "\(indexPath.row)" as NSString)
            cell.textLabel?.text = "new Image_\(indexPath.row) is cached."
            print("new Image_\(indexPath.row):\(image) is cached.")
        }
        return cell
    }
    
    func getRandomColor() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }

}

