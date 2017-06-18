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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        if let urlRequest = urlRequest {
            print(urlRequest)
            webView.loadRequest(urlRequest)
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
            print("webview did finish load! \(urlString)")
            
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webview did start loading")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        print("webview asking for permission to start loading")
        if let url = request.url {
            print(url.absoluteString)
        }
        
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        print("webview did fail load with error: \(error)")

    }

}
