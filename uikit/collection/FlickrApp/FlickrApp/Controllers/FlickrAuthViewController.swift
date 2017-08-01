//
//  FlickrAuthViewController.swift
//  FlickrApp
//
//  Created by zhen gong on 6/17/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class FlickrAuthViewController: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    var urlRequest: URLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        
        navigationItem.title = "Flickr Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    // begin auth
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let callbackURLString = "flickrApp://auth"
        let url = NSURL(string: callbackURLString)!
        
        FlickrClient.sharedInstance.beginAuthWithCallbackURL(url, permission: nil) { (flickrLoginPageURL, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if let flickrLoginPageURL = flickrLoginPageURL {
                    print("Function: \(#function), line: \(#line):\(flickrLoginPageURL)" )
                    // line: 65:https://www.flickr.com/services/oauth/authorize?oauth_token=72157684045594134-3779866796125927
                    let urlRequest = URLRequest(url: flickrLoginPageURL)
                    print("Function: \(#function), line: \(#line):\(flickrLoginPageURL)" )
                    self.webView.loadRequest(urlRequest)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }

}

extension FlickrAuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let urlString = webView.request?.url?.absoluteString {
            print("webViewDidFinishLoad: \(urlString)")
            if urlString.contains("authorize.gne") {

            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webview did start loading")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        if let url = request.url {
            if url.scheme != "http" && url.scheme != "https" {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return false
            }
        }
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        print("webview did fail load with error: \(error)")

    }

}
