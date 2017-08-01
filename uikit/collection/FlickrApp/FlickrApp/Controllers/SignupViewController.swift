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
    }

    func userAuthenticateCallback(notification:Notification) {
        if let url = notification.object as? URL {
            FlickrClient.sharedInstance.completeAuthWithURL(url: url, completionHandler: { [unowned self] (userName, userId, fullName, error) in
                if error != nil {
                    return
                } else {
                    self.userLogin(by: userName!, by: userId!)
                    let photoViewController = PhotoViewController()
                    let navigationViewController = UINavigationController(rootViewController: photoViewController)
                    self.present(navigationViewController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func userLogin(by name:String, by id:String ) {
        print(name)
        print(name)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // complete auth:
    @IBAction func signUpAction(_ sender: Any) {
        if let storyboard = self.storyboard {
            let flickrAuthViewController = storyboard.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! FlickrAuthViewController
            let navigationViewController = UINavigationController(rootViewController: flickrAuthViewController);
            self.present(navigationViewController, animated: true, completion: nil);
        }
    }
}

class FlickrClient {
    static let sharedInstance = FlickrClient()
    
    typealias FlickrClientSuccess = (_ error:Error?, _ data:AnyObject?) -> Void
    typealias FLickrClientFailure = (_ error:Error?) -> Void
    
    var flickrClientSuccessBlock:FlickrClientSuccess?
    var flickrClientFailureBlock:FLickrClientFailure?
    
    var authSecret: String?
    var authToken: String?
    
    private init(){
        
    }
    
    func handleCallbackURL(url: URL?) {
        if let url = url {
            self.completeAuthWithURL(url: url, completionHandler: { (userName, userId, fullName, error) in
                if let error = error {
                    print(error)
                    return;
                } else {
                    if let userName = userName {
                        print("Function: \(#function), line: \(#line):\(userName)" )
                    }
                    if let userId = userId {
                        print("Function: \(#function), line: \(#line):\(userId)" )
                    }
                    if let fullName = fullName {
                        print("Function: \(#function), line: \(#line):\(fullName)" )
                    }
                    
                    DispatchQueue.main.async {
                        let window = UIApplication.shared.windows[0]
                        let photoViewController = PhotoViewController()
                        window.rootViewController = photoViewController;
                    }
                }
            })
        }
    }
    
//    func userAuthenticateCallback(notification:Notification) {
//        if let url = notification.object as? URL {
//            self.completeAuthWithURL(url: url, completionHandler: { [unowned self] (userName, userId, fullName, error) in
//                if error != nil {
//                    return
//                } else {
//                    self.userLogin(by: userName!, by: userId!)
//                    let photoViewController = PhotoViewController()
//                    let navigationViewController = UINavigationController(rootViewController: photoViewController)
//                    self.present(navigationViewController, animated: true, completion: nil)
//                }
//            })
//        }
//    }
    
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
                    UserDefaults.standard.set(fn, forKey: "kFKStoredTokenKey")
                    UserDefaults.standard.set(fn, forKey: "kFKStoredTokenSecret")
                    UserDefaults.standard.synchronize()
                    self.flickrClientSuccessBlock = {(error, result) -> Void in
                        
                    }
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
        return newArgs
    }
    
    func userAuthorizationURLWithRequestToken(inRequestToken:String) -> URL?{
        let URLString = "https://www.flickr.com/services/oauth/authorize?oauth_token=\(inRequestToken)"
        return URL(string: URLString)
    }
    
    func FKGenerateOauthNonce() -> String {
        let uuid = FKGenerateUUID()
        let endIndex = uuid.index(uuid.startIndex, offsetBy: 8)
        return uuid.substring(to: endIndex)
    }
    
    func FKGenerateUUID() -> String {
        let uuid = NSUUID().uuidString
        return uuid
    }
    
    
}

extension SignupViewController {
    

    
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
