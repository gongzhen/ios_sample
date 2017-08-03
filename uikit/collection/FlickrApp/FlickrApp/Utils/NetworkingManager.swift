//
//  NetworkingManager.swift
//  FlickrApp
//
//  Created by zhen gong on 6/14/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

class NetworkingManager: NSObject {

    // MARK: Properties
    var authSecret:String?
    var authToken:String?
    fileprivate var session = URLSession.shared
    static let sharedInstance = NetworkingManager()
    
    // MARK: Initializer
    override init() {
        super.init()
    }
    
    func beginAuthWithCallbackURL(_ url: URL, permission:String? = nil, completion:@escaping(_ flickrLoginPageURL:URL?, _ error: NSError?) -> Void) {
        
        let paramsDictionary = ["oauth_callback": url.absoluteString];
        let baseURLString = self.requestTokenURLFromBaseURL()
        let baseURL = URL(string: baseURLString)!
        let requestURL = self.oauthURLFromBaseURL(inURL: baseURL, httpMethod: .HttpMethodGET, httpParams: paramsDictionary as [String: AnyObject])
        let request = URLRequest(url: requestURL!)
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let responseString = String(data: data, encoding: String.Encoding.utf8) else {
                return
            }
            
            var oauthToken:String = ""
            var oauthTokenSecret:String = ""
            if let params = FKQueryParamDictionaryFromQueryString(responseString) {
                if let oauthTokenStr = params[FlickrParameterKeys.OAuthToken] as? String {
                    oauthToken = oauthTokenStr
                }
                if let oauthTokenSecretStr = params[FlickrParameterKeys.OAuthTokenSecret] as? String {
                    oauthTokenSecret = oauthTokenSecretStr
                }
            } else {
                completion(nil, NSError(domain: "Begin Auth with Callback URL", code: 1, userInfo: [NSLocalizedDescriptionKey: "beginAuthWithCallbackURL"]))
                return
            }
            
            if oauthToken.isEmpty || oauthTokenSecret.isEmpty {
                completion(nil, NSError(domain: "Begin Auth with Callback URL", code: 1, userInfo: [NSLocalizedDescriptionKey: "beginAuthWithCallbackURL"]))
                return
            }
            self.authToken = oauthToken
            self.authSecret = oauthTokenSecret
            guard let beginAuthURL = self.userAuthorizationURLWithRequestToken(inRequestToken:oauthToken) else {
                return
            }
            completion(beginAuthURL, nil)
        }
        task.resume()
    }
    
    func requestTokenURLFromBaseURL() -> String {
        return FlickrOAuth.BASE_URL + FlickrOAuth.ApiPath + "/" + FlickrParameterKeys.RequestToken
    }
    
    func oauthURLFromBaseURL(inURL:URL, httpMethod method:HttpMethod, httpParams params:[String:AnyObject]) -> URL? {
        let newArgs:[String: String] = self.signedOAuthHTTPQueryParameters(params, baseURL: inURL, method: method)
        var queryArray = [String]()
        for (key, value) in newArgs {
            let escapedValue = FKEscapedURLStringPlus(value)!
            queryArray.append("\(key)=\(escapedValue)")
        }
        let newURLStringWithQuery = "\(inURL.absoluteString)?\(queryArray.joined(separator: "&"))"
        return URL(string: newURLStringWithQuery)
    }
    
    func signedOAuthHTTPQueryParameters(_ params:[String: AnyObject]?, baseURL inURL:URL, method:HttpMethod) -> [String: String] {
        var newArgs:[String:String]
        var httpMethod:String
        switch method {
        case .HttpMethodGET:
            httpMethod = "GET"
            break;
        case .HttpMethodPOST:
            httpMethod = "POST"
            break;
        }
        
        if let params = params {
            newArgs = params as! [String: String]
        } else {
            newArgs = [String: String]()
        }
        
        newArgs[FlickrParameterKeys.OAuthNonce] = FKGenerateOauthNonce()
        let time = NSDate().timeIntervalSince1970
        newArgs[FlickrParameterKeys.OAuthTimestamp] = "\(time)"
        newArgs[FlickrParameterKeys.OAuthVersion] = FlickrParameterValues.OAuthVersion
        newArgs[FlickrParameterKeys.OAuthSignatureMethod] = FlickrParameterValues.OAuthSignatureMethod
        newArgs[FlickrParameterKeys.OAuthConsumerKey] = FlickrParameterValues.APIKey
        
        let signatureKey:String
        if let authSecret = self.authSecret {
            signatureKey = FlickrParameterValues.Secret + "&" + authSecret
        } else {
            signatureKey = FlickrParameterValues.Secret + "&"
        }
        
        var baseString: String = ""
        baseString += httpMethod
        baseString += "&"
        baseString += FKEscapedURLStringPlus(inURL.absoluteString)
        let sortedKeys = newArgs.keys.sorted { (s0, s1) -> Bool in
            return s0 < s1
        }
        baseString += "&"
        var baseStrArgs:[String] = []
        
        for key in sortedKeys {
            if let value = FKEscapedURLStringPlus(newArgs[key]!) {
                baseStrArgs.append("\(key)=\(value)")
            }
        }
        
        baseString.append(FKEscapedURLStringPlus(baseStrArgs.joined(separator: "&")))
        let signature = FKOFHMACSha1Base64(signatureKey, baseString)
        newArgs[FlickrParameterKeys.OAuthSignature] = signature
        return newArgs
    }
    
    func FKGenerateOauthNonce() -> String {
        let uuid = FKGenerateUUID()
        let endIndex = uuid.index(uuid.startIndex, offsetBy: 8)
        return uuid.substring(to: endIndex)
    }
    
    func FKGenerateUUID() -> String {
        return NSUUID().uuidString
    }
    
    func taskForGETMethod(_ method:String?, parameters:[String:AnyObject], completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let url = flickrURLFromParameters(parameters)
        print(url)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGet(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey:error]))
                return
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        task.resume()
        return task
    }
    
    func convertDataWithCompletionHandler(_ data:Data, completionHandlerForConvertData:(_ result:AnyObject?, _ error:NSError?) -> Void) {
        var parsedData:AnyObject! = nil
        do {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data as JSON::\(data)"]))
        }
        completionHandlerForConvertData(parsedData, nil)
    }
    
    private func flickrURLFromParameters(_ parameters:[String: AnyObject]) -> URL {
        var component = URLComponents()
        component.host = NetworkingManager.Flickr.ApiHost
        component.path = NetworkingManager.Flickr.ApiPath
        component.scheme = NetworkingManager.Flickr.ApiScheme
        
        component.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            component.queryItems?.append(queryItem)
        }
        return component.url!
    }
    
    func userAuthorizationURLWithRequestToken(inRequestToken:String) -> URL? {
        let URLString = FlickrOAuth.BASE_URL + FlickrOAuth.ApiPath + "/authorize?oauth_token=\(inRequestToken)"
        return URL(string: URLString)
    }
    
}

extension NetworkingManager {
    
    func userAuthenticateCallbackURL(url:URL) {
        
    }
    

    func displayImageFromFlickrByGetList(_ completionHandlerImageList:@escaping (_ result:[Picture]?, _ error: NSError?) -> Void) {
        let methodParameters = [
            NetworkingManager.FlickrParameterKeys.Method: NetworkingManager.FlickrParameterValues.Method,
            NetworkingManager.FlickrParameterKeys.APIKey: NetworkingManager.FlickrParameterValues.APIKey,
            NetworkingManager.FlickrParameterKeys.PerPage: NetworkingManager.FlickrParameterValues.PerPage,
            NetworkingManager.FlickrParameterKeys.Format: NetworkingManager.FlickrParameterValues.Format,
            NetworkingManager.FlickrParameterKeys.NoJSONCallback: NetworkingManager.FlickrParameterValues.NoJSONCallback,
            NetworkingManager.FlickrParameterKeys.Extras: NetworkingManager.FlickrParameterValues.Extras
        ]
        
        let _ = taskForGETMethod(nil, parameters: methodParameters as [String:AnyObject]) { (results, error) in
            
            guard error == nil else  {
                completionHandlerImageList(nil, error)
                return
            }
            
            guard let stat = results?[NetworkingManager.FlickrResponseKeys.Status] as? String, stat == "ok" else {
                completionHandlerImageList(nil, error)
                return
            }

            guard let photosDictionary = results?[NetworkingManager.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                completionHandlerImageList(nil, error)
                return
            }
            
            guard let pictureArray = photosDictionary[NetworkingManager.FlickrResponseKeys.Photo] as? [AnyObject] else {
                completionHandlerImageList(nil, error)
                return
            }
            
            var pictures = [Picture]()
            for picture in pictureArray {
                pictures.append(Picture(dictionary: picture as! [String: AnyObject]))
            }
            completionHandlerImageList(pictures, nil)
        }
    }
    

}

enum HttpMethod{
    case HttpMethodGET;
    case HttpMethodPOST;
}

extension NetworkingManager {
    
    struct FlickrOAuth {
        static let BASE_URL = "https://www.flickr.com"
        static let ApiPath = "/services/oauth"
    }
    
    struct Flickr {
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    struct FlickrParameterKeys {
        static let APIKey = "api_key"
        static let RequestToken = "request_token"
        static let OAuthCallback = "oauth_callback"
        static let OAuthToken = "oauth_token"
        static let OAuthTokenSecret = "oauth_token_secret"
        static let OAuthNonce = "oauth_nonce"
        
        static let OAuthTimestamp = "oauth_timestamp"
        static let OAuthVersion = "oauth_version"
        static let OAuthSignatureMethod = "oauth_signature_method"
        static let OAuthConsumerKey = "oauth_consumer_key"
        static let OAuthSignature = "oauth_signature"
        
        static let Secret = "secret"
        static let Method = "method"
        static let PerPage = "per_page"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let Extras = "extras"
    }
    
    struct FlickrParameterValues {
        static let APIKey = "6d0a75210d7fa6268d56f466540ea839"
        static let Secret = "11be804d16b24bbd"
        static let Method = "flickr.interestingness.getList"
        static let PerPage = "99"
        static let Format = "json"
        static let NoJSONCallback = "1"
        static let Extras = "url_q,url_z"
        static let OAuthVersion = "1.0"
        static let OAuthSignatureMethod = "HMAC-SHA1"
    }
    
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let PerPage = "perpage"
        static let Photo = "photo"
        static let Title = "title"
        static let Pages = "pages"
    }
}
