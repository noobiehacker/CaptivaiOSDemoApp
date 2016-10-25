//
//  BatchService.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objc class BatchService: NSObject{
    
    class func newInstance() -> BatchService{
            return BatchService()
    }
    
    func saveBatch(batch : BatchObj) -> Bool{
        
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(batch)
            }
        } catch let error as NSError {
            return false
            print(error)
        }
        return true
        
    }
    
    func loadNewestBatch() -> BatchObj?{
        
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj).sorted(byProperty: "createdAt")
        }()
        if objs.count > 0 {
            return objs.first
        }else{
            return nil
        }
        
    }
    
    func deleteAllBatches() -> Bool {
        
        var objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj)
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for batch in objs{
                    try! realm.write {
                        realm.delete(batch)
                    }
                }
            } catch let error as NSError {
                return false
                print(error)
            }
        }
        objs = {
            try! Realm().objects(BatchObj)
        }()
        return objs.count == 0
        
    }
    
    func getBatchWithBatchNum(num : Int) -> BatchObj?{
        
        let predicate = NSPredicate(format: "batchNumber == %d", num)
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj.self).filter(predicate)
        }()
        if objs.count > 0 {
            return objs.first!
        }else{
            return nil
        }
        
    }
    
    func updateBatchUpdatedToTrue(num :Int) -> Bool{
        
        //Updates the uploaded field
        let predicate = NSPredicate(format: "batchNumber == %d", num)
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj.self).filter(predicate)
        }()
        if objs.count > 0 {
            let updateObj = objs.first!
            do{
                let realm = try Realm()
                try! realm.write {
                    updateObj.uploaded = true
                }
                return true
            }catch let error as NSError {
                print(error)
                return false
            }
        }else{
            return false
        }
    }
    
    func getCurrentBatchNum() -> Int{
        
        //Default the first batch number to be zero
        
        let predicate = NSPredicate(format: "uploaded == NO")
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj.self)
                .filter(predicate)
                .sorted(byProperty: "batchNumber", ascending: false)
        }()
        if objs.count > 0{
            return (objs.first?.batchNumber)!
        }else{
            let batch = BatchObj()
            let result = self.saveBatch(batch : batch)
            if result == true{
                return batch.batchNumber
            }else{
                return -1
            }
        }
    }
    
}