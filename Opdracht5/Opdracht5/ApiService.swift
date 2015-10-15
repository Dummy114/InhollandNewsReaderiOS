//
//  ApiService.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation

class ApiService {
    
    static let instance = ApiService()
    
    private init(){
        
    }
    
    
    func runApiService (callback: (results: [[String:AnyObject]]) -> (), callbackFail: (onFailure: String) -> ()) {
        
        let _baseUrl = "https://inhollandbackend.azurewebsites.net"
        let _testUrl = _baseUrl + "/api/articles"
        
        
        if let _NSURL = NSURL (string: _testUrl){
            let _request = NSMutableURLRequest(URL: _NSURL)
            
            let _session = NSURLSession.sharedSession()
            _session.dataTaskWithRequest(_request,
                completionHandler:{ (optionalData: NSData?,
                    response: NSURLResponse?,
                    error: NSError?) -> () in
                    if let data = optionalData{
                        do{
                            let _jsonData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions())
                            
                            var _dict = _jsonData as! [String:AnyObject];
                            let _results = _dict["Results"] as! [[String:AnyObject]]
                            let _nextId = _dict["NextId"] as! Int
                            
                            callback(results: _results);
                            
                        }
                        catch{
                            callbackFail(onFailure: "DERP");
                            print("NO JSON CONVERSION")
                        }
                    }
            }).resume();
        }
        
    }
    
}
