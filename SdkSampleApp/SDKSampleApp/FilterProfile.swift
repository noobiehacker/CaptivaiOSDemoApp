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
    
    override static func primaryKey() -> String? {
        return "profileName"
    }
    
}
