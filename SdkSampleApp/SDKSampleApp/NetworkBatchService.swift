//
//  NetworkBatchService.swift
//  SDKSampleApp
//
//  Created by davix on 11/7/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import Foundation
import Alamofire

class NetworkBatchService{

    init(cookie: String){
        self.cookieString = cookie
    }
    
    var cookieString: String?
    
    let endpoint = "http://138.91.240.65:8090"
 
    func getBatchUploadEndPoint() -> String{
        
        return endpoint + "/cp-rest/session/batches"
        
    }
    
    func getBatchEndPoint(batchId: String) -> String{
        
        return endpoint + "/cp-rest/session/batches" + "/" + batchId
        
    }
    
    func parseID(dictionary : NSDictionary) -> String{
        
        return dictionary.value(forKeyPath: "content.id") as! String

    }
    
    func getHeaders() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            "Accept": "application/vnd.emc.captiva+json, application/json",
            "Accept-Language": "en-US",
            "Content-Type": "application/vnd.emc.captiva+json; charset=utf-8"
        ]
        return headers
        
    }
    
    func addCookieToHeader(cookie: String, header: HTTPHeaders) -> HTTPHeaders{

        var headerWithCookie = header
        headerWithCookie["Cookie"] = "CPTV-TICKET=" + cookie
        return header

    }
    
    func createBatch(completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        
        if self.cookieString != nil{
            Alamofire.request(getBatchUploadEndPoint(), method: .post, parameters: createJsonPayload(), encoding: JSONEncoding.default, headers: self.getHeaders())
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
            //Throw Error!
            do {
                try ErrorUtil.throwError(message: "No cookie loaded in memory")
            } catch MyError.RuntimeError(let errorMessage) {
                print(errorMessage)
            } catch {
                
            }
            completion(nil, nil)
        }
        
    }
    
    func getBatch(batchId :String, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            Alamofire.request(getBatchEndPoint(batchId: batchId), method: .get, encoding: JSONEncoding.default, headers: self.getHeaders())
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
            //Throw Error!
            do {
                try ErrorUtil.throwError(message: "No cookie loaded in memory")
            } catch MyError.RuntimeError(let errorMessage) {
                print(errorMessage)
            } catch {
                
            }
            completion(nil, nil)
        }
        
    }
    
    func updateBatch(batchId :String, value: [String:String], completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
    
        if self.cookieString != nil{
            Alamofire.request(getBatchEndPoint(batchId: batchId), method: .post, parameters: createUpdatePayload(value: value), encoding: JSONEncoding.default, headers: self.getHeaders())
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
            //Throw Error!
            do {
                try ErrorUtil.throwError(message: "No cookie loaded in memory")
            } catch MyError.RuntimeError(let errorMessage) {
                print(errorMessage)
            } catch {
                
            }
            completion(nil, nil)
        }
        
    }
    
    func createUpdatePayload(value : [String:String]) -> Dictionary<String,Any>{
        
        var result = [String: Any]()
        result["dispatch"] = "S"
        if value.count > 0{
            result["nodes"] = self.createNodesArray(value: value)
            result["values"] = self.createValuesArray(value: value)
        }
        return result
        
    }
    
    func createNodesArray(value : [String: String]) -> [[String:Any]]{
        
        var result : [[String:Any]] = []
        var nodeId = 1
        
        for item in value {
            var dict = ["nodeId":nodeId,"parentId":0] as [String : Any]
            result.append(dict)
            nodeId += 1
        }
        return result
        
    }

    func createValuesArray(value : [String: String]) -> [[String:Any]]{
        
        var result : [[String:Any]] = []
        var nodeId = 1
        
        for item in value {
            var dict = self.createValuesDictionary(nodeId: String(nodeId), valueName: item.key, value: item.value)
            result.append(dict)
            nodeId += 1
        }
        return result
        
    }
    
    func createNodesDictionary(nodeId : String) -> NSDictionary{
        
        return ["nodeId":nodeId,"parentId":0]
    
    }
    
    func createValuesDictionary(nodeId : String, valueName : String ,value : String) -> [String :String]{
        
        var result = [String : String]()
        result["nodeId"] = nodeId
        result["valueName"] = valueName
        result["value"] = value
        result["valueType"] = "file"
        result["offset"] = "0"
        result["fileExtension"] = self.getFileExention(valueName: valueName)
        return result
        
    }
    
    func createJsonPayload() -> [String : String]{
        
        var payload = [String : String]()
        payload["captureFlow"] = "RevaApp"
        payload["batchName"] = "Batch_{NextId}"
        payload["batchRootLevel"] = "1"
        return payload
        
    }
    
    func getFileExention(valueName : String) -> String{
        
        if valueName == "text/plain"{
            return "text/plain"
        }
        else{
            return "jpg"
        }
        
    }
    
}
