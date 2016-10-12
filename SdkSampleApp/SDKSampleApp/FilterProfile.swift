//
//  Profile.swift
//  SDKSampleApp
//
//  Created by davix on 10/5/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import RealmSwift

class FilterProfile: Object{
    
    dynamic var profileName = ""
    var filters = List<FilterObject>()
    var selected : Bool = false
    
    override static func primaryKey() -> String? {
        return "profileName"
    }
    
}
