//
//  SignupViewController.swift
//  FlickrApp
//
//  Created by zhen gong on 6/17/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController {
    
    var authSecret: String?
    var authToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(userAuthenticateCallback), name: NSNotification.Name(rawValue: "UserAuthCallbackNotification"), object: nil)
        
    }

    func userAuthenticateCallback(notification:Notification) {
        if let url = notification.object as? URL {
            self.completeAuthWithURL(url: url, completionHandler: { [unowned self] (userName, userId, fullName, error) in
                if error != nil {
                    return
                } else {
                    self.userLogin(by: userName!, by: userId!)
                }
            })
        }
        
    }
    
    func userLogin(by name:String, by id:String ) {
        print(name)
        print(name)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let callbackURLString = "flickrApp://auth"
        let url = NSURL(string: callbackURLString)!
        self.beginAuthWithCallbackURL(url, permission: nil) { (flickrLoginPageURL, error) in
            if let error = error {
                print(error)
                return
            } else {
                if let flickrLoginPageURL = flickrLoginPageURL {
                    let urlRequest = URLRequest(url: flickrLoginPageURL)
                    let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! FlickrAuthViewController
                    webViewController.urlRequest = urlRequest
                    
                    let webAuthNavigationController = UINavigationController()
                    webAuthNavigationController.pushViewController(webViewController, animated: false)
                    DispatchQueue.main.async {
                        self.present(webAuthNavigationController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension SignupViewController {
    
    func completeAuthWithURL(url:URL, completionHandler:@escaping(_ userName:String?, _ userId:String?, _ fullName: String?, _ error:NSError?) -> Void) {
        
        guard let result = FKQueryParamDictionaryFromURL(url) else {
            completionHandler(nil, nil, nil, NSError(domain: "completeAuthWithURL", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot obtain token/secret from URL"]))
            return
        }
        
        let token: String = result["oauth_token"] as! String
        let verifier: String = result["oauth_verifier"] as! String
        
        
        let paramsDictionary = ["oauth_token": token, "oauth_verifier": verifier]
        let baseURLString = "https://www.flickr.com/services/oauth/access_token"
        let baseURL = NSURL(string: baseURLString)
        let requestURL = self.oauthURLFromBaseURL(inURL: baseURL!, httpMethod: .HttpMethodGET, httpParams: paramsDictionary as [String: AnyObject])
        print(requestURL!)
        let session = URLSession.shared
        let request = URLRequest(url: requestURL!)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data, let _ = response else {
                return
            }
            
            guard var responseString = String(data: data, encoding: String.Encoding.utf8) else {
                return
            }
            
            responseString = responseString.removingPercentEncoding!
            print(responseString)
            if responseString.hasPrefix("oauth_problem=") {
                completionHandler(nil, nil, nil, NSError(domain: "completeAuthWithURL", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot obtain token/secret from URL"]))
                return
            }
            
            if let params:[String:String] = FKQueryParamDictionaryFromQueryString(responseString) as? [String : String] {
                let fn = params["fullname"]
                let oat = params["oauth_token"]
                let oats = params["oauth_token_secret"]
                let nsid = params["user_nsid"]
                let un = params["username"]
                
                if fn == nil || oat == nil || oats == nil || nsid == nil || un == nil {
                    completionHandler(nil, nil, nil, NSError(domain: "completeAuthWithURL", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot obtain token/secret from URL"]))
                    return
                } else {
//                    UserDefaults.standard.set(fn, forKey: "kFKStoredTokenKey")
//                    UserDefaults.standard.set(fn, forKey: "kFKStoredTokenSecret")
//                    UserDefaults.standard.synchronize()
                    completionHandler(un, nsid, fn, nil)
                    NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "UserAuthCallbackNotification") , object: nil)
                }
            }
        }
        
        task.resume()
    }
    
    func beginAuthWithCallbackURL(_ url: NSURL, permission:String? = nil, completion:@escaping(_ flickrLoginPageURL:URL?, _ error: NSError?) -> Void) {
        let paramsDictionary = ["oauth_callback": url.absoluteString!]
        let baseURLString = "https://www.flickr.com/services/oauth/request_token"
        let baseURL = NSURL(string: baseURLString)!
        let requestURL = self.oauthURLFromBaseURL(inURL: baseURL, httpMethod: HttpMethod.HttpMethodGET, httpParams: paramsDictionary as [String: AnyObject])
        let session = URLSession.shared
        let request = URLRequest(url: requestURL!)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let responseString = String(data: data, encoding: String.Encoding.utf8) else {
                return
            }
            print(responseString)
            var oauthToken:String?
            var oauthTokenSecret:String?
            if let params = FKQueryParamDictionaryFromQueryString(responseString) {
                if let oauthTokenStr = params["oauth_token"] as? String {
                    oauthToken = oauthTokenStr
                }
                if let oauthTokenSecretStr = params["oauth_token_secret"] as? String {
                    oauthTokenSecret = oauthTokenSecretStr
                }
            } else {
                completion(nil, NSError(domain: "beginAuthWithCallbackURL", code: 1, userInfo: [NSLocalizedDescriptionKey: "beginAuthWithCallbackURL"]))
                return
            }
            
            if oauthToken == nil || oauthTokenSecret == nil {
                completion(nil, NSError(domain: "beginAuthWithCallbackURL", code: 1, userInfo: [NSLocalizedDescriptionKey: "beginAuthWithCallbackURL"]))
                return                
            }
            self.authToken = oauthToken
            self.authSecret = oauthTokenSecret
            guard let beginAuthURL = self.userAuthorizationURLWithRequestToken(inRequestToken: oauthToken!) else {
                return
            }
            completion(beginAuthURL, nil)
        }
        task.resume()
    }
    
    func oauthURLFromBaseURL(inURL:NSURL, httpMethod method:HttpMethod, httpParams params:[String:AnyObject]) -> URL? {
        let newArgs:[String:String] = self.signedOAuthHTTPQueryParameters(params, baseURL: inURL, method: method)
        var queryArray = [String]()
        for (key, value) in newArgs {
            let escapedValue = FKEscapedURLStringPlus(value)!
            queryArray.append("\(key)=\(escapedValue)")
        }
        
        let newURLStringWithQuery = "\(inURL.absoluteString!)?\(queryArray.joined(separator: "&"))"
        print(newURLStringWithQuery)
        return URL(string: newURLStringWithQuery)
    }
    
    func signedOAuthHTTPQueryParameters(_ params:[String:AnyObject]?, baseURL inURL:NSURL, method:HttpMethod) -> [String: String]{
        var newArgs:[String:String]!
        var httpMethod :String
        switch method {
        case .HttpMethodGET:
            httpMethod = "GET"
            break
        case .HttpMethodPOST:
            httpMethod = "POST"
            break
        }
        
        if let params = params {
            newArgs = params as! [String: String]
        } else {
            newArgs = [String:String]()
        }
    
        newArgs["oauth_nonce"] = FKGenerateOauthNonce()
        let time = NSDate().timeIntervalSince1970
        newArgs["oauth_timestamp"] = "\(time)"
        newArgs["oauth_version"] = "1.0";
        newArgs["oauth_signature_method"] = "HMAC-SHA1";
        newArgs["oauth_consumer_key"] = NetworkingManager.FlickrParameterValues.APIKey
        
        
        let signatureKey:String!
        if let authSecret = self.authSecret {
            signatureKey = NetworkingManager.FlickrParameterValues.Secret + "&" + authSecret
        } else {
            signatureKey = NetworkingManager.FlickrParameterValues.Secret + "&"
        }
        
        
        var baseString: String = ""
        baseString += httpMethod
        baseString += "&"
        baseString += (FKEscapedURLStringPlus(inURL.absoluteString!)!)
        let sortedKeys = newArgs.keys.sorted {$0 < $1}
        baseString += "&"
        var baseStrArgs:[String] = []
        
        for key in sortedKeys {
            if let value = FKEscapedURLStringPlus(newArgs[key]!) {
                baseStrArgs.append("\(key)=\(value)")
            }
        }
        
        baseString.append(FKEscapedURLStringPlus(baseStrArgs.joined(separator: "&"))!)
        let signature = FKOFHMACSha1Base64(signatureKey, baseString)
        newArgs["oauth_signature"] = signature
        print(baseString)
        return newArgs
    }
    
    func userAuthorizationURLWithRequestToken(inRequestToken:String) -> URL?{
        let URLString = "https://www.flickr.com/services/oauth/authorize?oauth_token=\(inRequestToken)"
        return URL(string: URLString)
    }

}

extension SignupViewController {
    
    func FKGenerateOauthNonce() -> String {
        let uuid = FKGenerateUUID()
        let endIndex = uuid.index(uuid.startIndex, offsetBy: 8)
        return uuid.substring(to: endIndex)
    }
    
    func FKGenerateUUID() -> String {
        let uuid = NSUUID().uuidString
        return uuid
    }
    
//    func FKQueryParamDictionaryFromQueryString(queryString:String) ->[String:String]? {
//        if queryString.characters.count < 1 {
//            return nil
//        }
//        
//        let vars = queryString.components(separatedBy: "&")
//        var keyValues = [String:String]()
//        for query in vars {
//            let queryArry = query.components(separatedBy: "=")
//            if queryArry.count != 2 {
//                continue
//            }
//            keyValues[queryArry[0]] = queryArry[1]
//        }
//        return keyValues
//    }
    
//    func FKEscapedURLStringPlus(string:String) -> String? {
//        let unreleved = "`~!@#$^&*()=+[]\\{}|;':\",/<>?"
//        let allowed = NSMutableCharacterSet.alphanumeric()
//        allowed.addCharacters(in: unreleved)
//        return string.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
//    }
    
}

extension SignupViewController {

    struct Constants {
        let kFKStoredTokenKey = "kFKStoredTokenKey"
        let kFKStoredTokenSecret = "kFKStoredTokenSecret"
    }
}