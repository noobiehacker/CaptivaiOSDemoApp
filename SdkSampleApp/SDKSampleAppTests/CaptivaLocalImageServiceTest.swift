//
//  CaptivaLocalImageServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/25/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import XCTest
import Foundation
import RealmSwift
@testable import SDKSampleApp

class CaptivaLocalImageServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveImage(){
        
        //it should persist the image from the database
        let service = CaptivaLocalImageService()
        XCTAssertTrue(service.deleteAllImages())
        let obj = CaptivaLocalImageObj()
        let result = service.saveImage(image: obj)
        XCTAssertTrue(result)
    }
    
    func testLoadImagesFromBatchNumber(){
        
        //it loads images with the associated batch number
        let service = CaptivaLocalImageService()
        let rightBatchNum = 1
        let wrongBatchNum = 5
        
        let obj1 = CaptivaLocalImageObj()
        obj1.imageBase64Data = "A"
        let obj2 = CaptivaLocalImageObj()
        obj2.imageBase64Data = "B"
        let obj3 = CaptivaLocalImageObj()
        obj3.imageBase64Data = "C"
        
        obj1.batchNumber = rightBatchNum
        obj2.batchNumber = rightBatchNum
        obj3.batchNumber = wrongBatchNum
        
        XCTAssertTrue(service.saveImage(image: obj1))
        XCTAssertTrue(service.saveImage(image: obj2))
        XCTAssertTrue(service.saveImage(image: obj2))
        
        let result = service.loadImagesFromBatchNumber(batchNumber: rightBatchNum)
        XCTAssertEqual(result?.count, 2)
        let checkResult = result?.first?.batchNumber
        let actural = rightBatchNum
        XCTAssertEqual(checkResult, actural)
        
    }
    
}

