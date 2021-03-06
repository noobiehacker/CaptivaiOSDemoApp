//
//  UploadHelperTest.swift
//  SDKSampleApp
//
//  Created by davix on 11/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
import Foundation
import RealmSwift
@testable import SDKSampleApp

class UploadHelperTest: XCTestCase {
    
    var helper : UploadHelper?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUploadImageAndCreateSession(){
//        
//        let helper = UploadHelper.init()
//        let exp = expectation(description: "read")
//        
//        helper.createSession(){
//            (dictionary,error) -> ()in
//            
//            let testBundle = Bundle(for: type(of: self))
//            let util = ImageUtil.init()
//            let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
//            let imageObj = CaptivaLocalImageObj()
//            imageObj.imageBase64Data = util.createBase64String(image : img!)
//            helper.uploadImage(image: imageObj){
//                (dictionary2,error2) -> () in
//                XCTAssertNotNil(dictionary2)
//                exp.fulfill()
//            }
//        }
//        waitForExpectations(timeout: 60, handler: { error in
//            XCTAssertNil(error, "Error")
//        })
        
    }
    func testUploadPODNumberAndCreateSession(){
//        
//        let helper = UploadHelper.init()
//        let exp = expectation(description: "read")
//        
//        helper.createSession(){
//            (dictionary,error) -> ()in
//            
//            let text = "ABC123"
//            helper.uploadPODNumber(podNumber: text){
//                (dictionary2,error2) -> () in
//                XCTAssertNotNil(dictionary2)
//                exp.fulfill()
//            }
//        }
//        waitForExpectations(timeout: 60, handler: { error in
//            XCTAssertNil(error, "Error")
//        })
        
    }
    
    func testUploadBatch(){
        
        //Set up helper
        self.helper = UploadHelper.init()
        let exp = expectation(description: "read")
        
        //Set up batch
        let bs = BatchService()
        XCTAssertTrue(bs.deleteAllBatches())
        
        let obj1 = BatchObj()
        obj1.uploaded = false
        obj1.podNumber = "ABCD"
        XCTAssertTrue(bs.saveBatch(batch: obj1))
        
        //Set up img and service
        let imageService = CaptivaLocalImageService()
        XCTAssertTrue(imageService.deleteAllImages())
        let testBundle = Bundle(for: type(of: self))
        let util = ImageUtil.init()
        
        //1)Save One Image
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        let imageObj = CaptivaLocalImageObj()
        imageObj.imageBase64Data = util.createBase64String(image : img!)
        XCTAssertTrue(imageService.saveImage(image: imageObj))
        
        //2)Save another Image
        let img2 = UIImage(named: "testImg2.jpg", in: testBundle, compatibleWith: nil)
        let imageObj2 = CaptivaLocalImageObj()
        imageObj2.imageBase64Data = util.createBase64String(image : img2!)
        XCTAssertTrue(imageService.saveImage(image: imageObj2))
        
        //3)Call function
        self.helper?.uploadPODBatch(batchObj: obj1){
            //3)validate
            dict, error in
            XCTAssertNil(dict)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: { error in
            XCTAssertNil(error, "Error")
        })

    }
    
    func testParseFileId(){
        
        let expected = "f_128b1931b51643979a2580f5820dec4ftif"
        let input = ["id": expected] as NSDictionary
        let helper = UploadHelper.init()
        let result = helper.parseID(dictionary: input)
        XCTAssertEqual(expected, result)
        
    }
    
}
