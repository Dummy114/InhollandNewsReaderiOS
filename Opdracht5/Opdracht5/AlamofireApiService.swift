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
import Serialize
class AlamofireApiService {
    
    static let instance = AlamofireApiService()
    
    let _baseUrl = "https://inhollandbackend.azurewebsites.net";
    
    func GetArticles (isLoggedIn: UserAuth?, callbackSuccess: (results: ResultModel) -> () , callbackFailure: (results: Bool) ->()) {
        let _url = _baseUrl + "/api/articles"
        if isLoggedIn != nil {
            let _headers = [
                "x-authtoken" : isLoggedIn!.AuthToken
            ]
            Alamofire.request(.GET, _url, headers: _headers).responseJSON{res in
                if res.result.error != nil {
                    callbackFailure(results: false)
                }
                else{
                    let _results = JSON(res.result.value!)
                    let _res : ResultModel  = self.parseJsonToArticleList(_results)
                    callbackSuccess(results: _res)
                }
            }
        }
        else{
            Alamofire.request(.GET, _url).responseJSON{ res in
            
                if res.result.error != nil {
                    callbackFailure(results: false)
                }
                else{
                    let _results = JSON(res.result.value!)
                    let _res : ResultModel  = self.parseJsonToArticleList(_results)
                    callbackSuccess(results: _res)
                }
            }
        }
    }
    
    func GetNextArticles(nextId:Int, isLoggedIn: UserAuth?, callbackSuccess:(results: ResultModel) -> (), callbackFailure: (results: String) -> ()){
        let _url = _baseUrl + "/api/articles/" + String(nextId)
        if isLoggedIn != nil{
            let _headers = [
                "x-authtoken" : isLoggedIn!.AuthToken
            ]
            Alamofire.request(.GET, _url, parameters : ["count" : "20"], headers: _headers).responseJSON{res in
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
        else{
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
    }
    
    func LoginUser(user: User, callBackSuccess: (results: UserAuth) -> (), callbackFailure: (results: Bool) ->()){
        var _data = [String:String]()
        _data["Username"] = user.UserName
        _data["Password"] = user.Password
        
        let _url = _baseUrl + "/api/Users/Login"
        
        Alamofire.request(.POST, _url, parameters : _data).responseJSON{res in
            if res.result.error != nil{
                callbackFailure(results: false)
            }
            else{
                let _results = JSON(res.result.value!)
                let _res : UserAuth = self.parseJsonToUserAuth(_results)
                callBackSuccess(results: _res)
            }
        }
    }
    
    func LikeArticle(id: Int, userauth: UserAuth, callBackSuccess: (results: Bool) -> (), callbackFailure: (results: Bool) -> ()){
        let _url = _baseUrl + "/api/Articles/\(id)//like"
        let _headers = [
            "x-authtoken" : userauth.AuthToken
        ]
        Alamofire.request(.PUT, _url, headers: _headers).response { request, response, data, error in
            if error != nil{
                callbackFailure(results: false)
            }
            else{
                callBackSuccess(results: true)
            }
        }
    }
    
    func DisLikeArticle(id: Int, userauth: UserAuth, callBackSuccess: (results: Bool) -> (), callbackFailure: (results: Bool) -> ()){
        let _url = _baseUrl + "/api/Articles/\(id)//like"
        let _headers = [
            "x-authtoken" : userauth.AuthToken
        ]
        Alamofire.request(.DELETE, _url, headers: _headers).response { request, response, data, error in
            if error != nil{
                callbackFailure(results: false)
            }
            else{
                callBackSuccess(results: true)
            }
        }
    }
    
    func GetLikedArticles(userauth: UserAuth, callbackSuccess: (results: ResultModel) -> (), callbackFailure: (results: Bool) -> ()){
        let _url = _baseUrl + "/api/Articles/liked"
        let _headers = [
            "x-authtoken" : userauth.AuthToken
        ]
        Alamofire.request(.GET, _url, headers: _headers).responseJSON{res in
            if res.result.error != nil{
                callbackFailure(results: false)
            }
            else{
                let _results = JSON(res.result.value!)
                let _res : ResultModel = self.parseJsonToArticleList(_results)
                callbackSuccess(results: _res)
            }
        }

    }
    
    /*func RegisterUser(username: String, password: String, callBackSuccess:(results: Bool) -> (), callbackFailure(results: Bool) ->()){
        let _url = _baseUrl + "/api/Users/Register"
        AlamoFire.request(.POST, _url, parameters :
    }*/
    
    private func parseJsonToArticleList (_articles: JSON ) -> ResultModel {
        let _result = ResultModel(json: _articles)
        return _result
        
    }
    
    private func parseJsonToUserAuth(user: JSON) -> UserAuth {
        let _result = UserAuth(json: user)
        return _result
    }
    
}


