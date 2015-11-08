//
//  Extensions.swift
//  Opdracht5
//
//  Created by Informatica Haarlem on 15-10-15.
//  Copyright © 2015 Informatica Haarlem. All rights reserved.
//

import Foundation
import UIKit;
import SystemConfiguration
class Extensions {
    //    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    static func getAppDelegate() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
    static func saveUserName(user: User){
        NSUserDefaults.standardUserDefaults().setValue(user.UserName, forKey: "Username")
        NSUserDefaults.standardUserDefaults().setValue(user.Password, forKey: "Password")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func deleteUser(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Username")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Password")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    static func parseToNSdate(string: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let _date : NSDate = dateFormatter.dateFromString(string)!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(_date)
    }
    
    static func getUser() -> User?{
        let _userName : AnyObject?  = NSUserDefaults.standardUserDefaults().objectForKey("Username")
        let _passWord : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Password")
        if _userName != nil && _passWord != nil{
            return User(username: _userName! as! String, password: _passWord! as! String)
        }
        else{
            return nil
        }
    }
}
