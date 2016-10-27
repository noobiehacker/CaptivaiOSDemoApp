//
//  UploadService.swift
//  SDKSampleApp
//
//  Created by davix on 10/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Alamofire

class UploadService{
    
    init(){
        
    }
    
    init(cookie: String){
        self.cookieString = cookie
    }
    
    var endPoint: String {
        
        get {
            return "http://138.91.240.65:8090"
        }
        set {
        }
    }
    
    var cookieString: String?
    
    func createUploadParam(image : UIImage) -> Dictionary<String,String>{
        
        let util = ImageUtil.init()
        return util.createImageUploadParam(image: image)
        
    }
    
    func createUploadParam(data : NSData) -> Dictionary<String,String>{
        
        let util = ImageUtil.init()
        return util.createImageUploadParam(data: data)
        
    }
    
    func getUploadImageEndpoint() -> String{
        
        return endPoint + "/cp-rest/session/files"
    }

    func uploadImage(image: UIImage, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            Alamofire.request(getUploadImageEndpoint(), method: .post, parameters: createUploadParam(image: image), encoding: JSONEncoding.default, headers: self.getHeaders())
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success(let result):
                        if let result = response.result.value {
                            let jsonResult = result as! NSDictionary
                            completion(jsonResult, nil)
                        }
                    case .failure(let error):
                        completion(nil, error as NSError?)
                    }
            }
        }else{
            print("No cookie loaded in memory")
            completion(nil, nil)
        }
        
    }
    
    func uploadImage(data: NSData, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            Alamofire.request(getUploadImageEndpoint(), method: .post, parameters: createUploadParam(data: data), encoding: JSONEncoding.default, headers: self.getHeaders())
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success(let result):
                        if let result = response.result.value {
                            let jsonResult = result as! NSDictionary
                            completion(jsonResult, nil)
                        }
                    case .failure(let error):
                        completion(nil, error as NSError?)
                    }
            }
        }else{
            print("No cookie loaded in memory")
            completion(nil, nil)
        }
        
    }

    
    func getHeaders() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            "Authorization": self.cookieString!,
            "Accept": "application/vnd.emc.captiva+json, application/json",
            "Accept-Language": "en-US",
            "Content-Type": "application/vnd.emc.captiva+json; charset=utf-8"
        ]
        return headers
        
    }
    
}
