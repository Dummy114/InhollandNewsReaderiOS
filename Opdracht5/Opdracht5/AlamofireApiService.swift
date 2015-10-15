//
//  AlamofireApiService.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamofireApiService {
    
    static let instance = AlamofireApiService()
    
    let _baseUrl = "https://inhollandbackend.azurewebsites.net";
    
    func GetArticles (callbackSuccess: (results: ResultModel) -> () , callbackFailure: (results: String) ->()) {
        let _url = _baseUrl + "/api/articles"
        Alamofire.request(.GET, _url).responseJSON{ res in
            
            if res.result.error != nil {
                callbackFailure(results: "FAILURE")
            }
            else{
                let _results = JSON(res.result.value!)
                let _res : ResultModel  = self.parseJsonToArticleList(_results)
                callbackSuccess(results: _res)
            }
        }
    }
    func GetNextArticles(nextId:Int, callbackSuccess:(results: ResultModel) -> (), callbackFailure: (results: String) -> ()){
        let _url = _baseUrl + "/api/articles/" + String(nextId)
        Alamofire.request(.GET, _url, parameters : ["count" : "20"]).responseJSON{res in
            if res.result.error != nil{
                callbackFailure(results: "FAILURE")
            }
            else{
                let _results = JSON(res.result.value!)
                let _res : ResultModel = self.parseJsonToArticleList(_results)
                callbackSuccess(results: _res)
            }
        }
    }
    
    private func parseJsonToArticleList (_articles: JSON ) -> ResultModel {
        let _result = ResultModel(json: _articles)
        return _result;
        
    }
    
}


