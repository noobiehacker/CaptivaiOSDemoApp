//
//  CookieManager.swift
//  SDKSampleApp
//
//  Created by davix on 9/27/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objc class CookieManager: NSObject{
    
    var cookieCache: Cookie?
    
    class func newInstance() -> CookieManager{
        return CookieManager()
    }
    
    func saveCookie(cookie: Cookie) -> Bool {
        
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(cookie)
            }
        } catch _ as NSError {
            return false
        }
        return true
    
    }
    
    func loadCookie() -> Bool {

        let objs: Results<Cookie> = try! Realm().objects(Cookie.self)
        self.cookieCache = objs.first
        return self.cookieCache != nil
        
    }
    
    func clearAllCookies() -> Bool {
        
        var objs: Results<Cookie> = {
            try! Realm().objects(Cookie.self)
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for cookie in objs{
                    try! realm.write {
                        realm.delete(cookie)
                    }
                }
            } catch _ as NSError {
                return false
            }
        }
        objs = {
            try! Realm().objects(Cookie.self)
        }()
        return objs.count == 0
        
    }
    
}
