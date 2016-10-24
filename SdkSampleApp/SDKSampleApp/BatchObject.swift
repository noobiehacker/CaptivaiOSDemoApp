//
//  BatchObject.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import RealmSwift

class BatchObject: Object{
    
    dynamic var batchNumber = ""
    var podNumber = ""
    var createdAt = NSDate()
    var uploaded = false
    
}