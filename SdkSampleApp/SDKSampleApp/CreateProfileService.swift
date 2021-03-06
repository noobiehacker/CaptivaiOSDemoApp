//
//  CreateProfileService.swift
//  SDKSampleApp
//
//  Created by davix on 10/5/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CreateProfileService{
    
    func saveProfile(profile :FilterProfile) -> Bool{
        
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(profile)
            }
        } catch _ as NSError {
            return false
        }
        return true
        
    }
    
    func loadProfiles() -> [FilterProfile]?{

        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self)
        }()
        var result : [FilterProfile] = []
        for profile in objs{
            result.append(profile)
        }
        return result
        
    }
    
    func getAllProfileNames() -> [String]{
        
        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self)
        }()
        var result : [String] = []
        for profile in objs{
            result.append(profile.profileName)
        }
        return result
        
    }
    
    func deleteAllProfiles() -> Bool {
        
        var objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self)
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for profile in objs{
                    try! realm.write {
                        realm.delete(profile)
                    }
                }
            } catch _ as NSError {
                return false
            }
        }
        objs = {
            try! Realm().objects(FilterProfile.self)
        }()
        return objs.count == 0
        
    }
    
    func containsProfileName(name: String) -> Bool {
        
        let profiles = self.loadProfiles()
        var result = false
        if profiles != nil {
            for profile in profiles! {
                if profile.profileName == name{
                    result = true
                    break
                }
            }
        }
        return result
    }
    
    func getAllSelectedEntry() -> [FilterProfile]{
        
        //1)Refactor Later With Functional Programming
        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self).filter("selected == YES")
        }()
        var result : [FilterProfile] = []
        for profile in objs{
            result.append(profile)
        }
        return result
    }
    
    func updateAllSelectedToFalse() -> Bool{
        
        //It updates all the selected column to false
        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self).filter("selected == YES")
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for profile in objs{
                    try! realm.write {
                        profile.selected = false
                    }
                }
            } catch _ as NSError {
                return false
            }
        }
        return self.getAllSelectedEntry().count == 0
    
    }
    
    func getProfileWithProfileName(name : String) -> FilterProfile?{
        
        let predicate = NSPredicate(format: "profileName == %@", NSString(string: name))
        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self).filter(predicate)
        }()
        if objs.count > 0 {
            return objs.first
        }else{
            return nil
        }
        
    }
    
    func updateProfileSelectedToTrue(name : String) -> Bool{
        
        let predicate = NSPredicate(format: "profileName == %@", NSString(string: name))
        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile.self).filter(predicate)
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for profile in objs{
                    try! realm.write {
                        profile.selected = true
                    }
                }
            } catch _ as NSError {
                return false
            }
            return true
        }else{
            return false
        }
    }
    
}
