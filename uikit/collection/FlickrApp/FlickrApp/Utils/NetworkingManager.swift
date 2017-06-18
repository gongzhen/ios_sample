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
    
    // shared session
    fileprivate var session = URLSession.shared
    
    static let sharedInstance = NetworkingManager()
    
    override init() {
        super.init()
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
    
    struct Flickr {
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    struct FlickrParameterKeys {
        static let APIKey = "api_key"
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
