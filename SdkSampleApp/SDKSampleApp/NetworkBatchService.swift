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

    var nodeId = 1
    var parentNodeId = 0
    var offset = 0
    var manager : SessionManager?
    
    init(cookie: String){
        self.cookieString = cookie
    }
    
    var cookieString: String?
    
    let endpoint = Constants.url
 
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
    
    func createBatchWithTimeOut(timeout: Int, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = TimeInterval(timeout)
            configuration.timeoutIntervalForRequest = TimeInterval(timeout)
            
            self.manager = Alamofire.SessionManager(configuration: configuration)
            self.manager?.request(getBatchUploadEndPoint(), method: .post, parameters: createJsonPayload(), encoding: JSONEncoding.default, headers: self.getHeaders())
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success( _):
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
            } catch MyError.RuntimeError( _) {
            } catch {
                
            }
            completion(nil, nil)
        }
        
    }
    
    func createBatch(completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            Alamofire.request(getBatchUploadEndPoint(), method: .post, parameters: createJsonPayload(), encoding: JSONEncoding.default, headers: self.getHeaders())
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success( _):
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
            } catch MyError.RuntimeError(_) {
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
                    case .success(_):
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
            } catch MyError.RuntimeError(_) {
            } catch {
                
            }
            completion(nil, nil)
        }
        
    }
    
    func updateBatchWithTimeOut(timeout: Int, batchId :String, value: [String:String], completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval.init(timeout)
            
            self.manager = Alamofire.SessionManager(configuration: configuration)
            self.manager?.request(getBatchEndPoint(batchId: batchId), method: .post, parameters: createUpdatePayload(value: value), encoding: JSONEncoding.default, headers: self.getHeaders())
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success(_):
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
            } catch MyError.RuntimeError(_) {
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
                    case .success(_):
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
            } catch MyError.RuntimeError(_) {
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
        var nodeId = self.nodeId
        
        for _ in value {
            let dict = ["nodeId":nodeId,"parentId":self.parentNodeId] as [String : Any]
            result.append(dict)
            nodeId += 1
        }
        return result
        
    }

    func createValuesArray(value : [String: String]) -> [[String:Any]]{
        
        var result : [[String:Any]] = []
        var nodeId = self.nodeId
        
        for item in value {
            let dict = self.createValuesDictionary(nodeId: String(nodeId), fileExtension: item.value, value: item.key)
            result.append(dict)
            nodeId += 1
        }
        return result
        
    }
    
    func createNodesDictionary(nodeId : String) -> NSDictionary{
        
        return ["nodeId":nodeId,"parentId":self.parentNodeId]
    
    }
    
    func createValuesDictionary(nodeId : String, fileExtension : String , value : String) -> [String :String]{
        
        var result = [String : String]()
        result["nodeId"] = nodeId
        result["valueName"] = "OutputImage"
        result["value"] = value
        result["valueType"] = "file"
        result["offset"] = String(self.offset)
        result["fileExtension"] = fileExtension
        return result
        
    }
    
    func createJsonPayload() -> [String : String]{
        
        var payload = [String : String]()
        payload["captureFlow"] = "RevaApp"
        payload["batchName"] = "Batch_{NextId}"
        payload["batchRootLevel"] = "1"
        return payload
        
    }
    
}
