//
//  UploadImageViewControllerTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
import Foundation
import RealmSwift
@testable import SDKSampleApp

class UploadImageViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPod(){
        
        let vc = UploadImageViewController()
        let expected = "helloWorld"
        vc.podNumber = UITextField.init()
        vc.podNumber.text = expected
        let actural = vc.getPod()
        XCTAssertEqual(expected,actural)
        
    }
    
    func testGetAllImageObjs() {
        //Set up
        let batchService = BatchService()
        XCTAssertTrue(batchService.deleteAllBatches())
        
        let service = CaptivaLocalImageService()
        XCTAssertTrue(service.deleteAllImages())
        
        let obj1 = CaptivaLocalImageObj()
        obj1.imageBase64Data = "ABC"
        
        let obj2 = CaptivaLocalImageObj()
        obj2.imageBase64Data = "DEC"
        
        let obj3 = CaptivaLocalImageObj()
        obj3.imageBase64Data = "FASD"
        
        XCTAssertTrue(service.saveImage(image: obj1))
        XCTAssertTrue(service.saveImage(image: obj2))
        XCTAssertTrue(service.saveImage(image: obj3))
        
        //Test Controller
        let vc = UploadImageViewController()
        let result = vc.getAllImageObjs(num: 0)
        XCTAssertEqual(result?.count, 3)
        
    }
    
    func testLoadImage() {
        
        //Set up
        let batchService = BatchService()
        XCTAssertTrue(batchService.deleteAllBatches())
        let service = CaptivaLocalImageService()
        XCTAssertTrue(service.deleteAllImages())
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.bundlePath + "/testImg.jpg"

        let obj1 = CaptivaLocalImageObj()
        obj1.imageBase64Data = path
        
        let obj2 = CaptivaLocalImageObj()
        obj2.imageBase64Data = path + "someting"
        
        XCTAssertTrue(service.saveImage(image: obj1))
        XCTAssertTrue(service.saveImage(image: obj2))
        
        //Test Controller
        let vc = UploadImageViewController()
        vc.numberOfImages = UILabel()
        vc.loadImageData()
        XCTAssertEqual(vc.imageData.count, 2)
    
    }
    
    func testIncrementNumber(){
        
        let vc = UploadImageViewController()
        vc.numberOfImages = UILabel()
        XCTAssertEqual(vc.count, 0)
        
        vc.incrementLabel()
        XCTAssertEqual(vc.count, 1)
        
    }
    
    func testPodNumberIsValid(){
        
        let vc = UploadImageViewController()
        vc.podNumber = UITextField.init()
        vc.podNumber.text = "ABCDE"
        let result = vc.podNumberIsValid()
        XCTAssertTrue(result)
        
    }
    
    func testCheckPodNumberIsValid(){
        
        let vc = UploadImageViewController()
        vc.podNumber = UITextField.init()
        vc.podNumber.text = "ABCDE"
        let result = vc.checkPodNumberIsValid()
        XCTAssertTrue(result)
        
    }
    
    func testChainedNetworkCall(){
        
        //1)Set Up Code
        let vc = UploadImageViewController()
        vc.podNumber = UITextField()
        vc.podNumber.text = "ABC"
        let batchService = BatchService()
        vc.batchNum = batchService.createBatchWithHightestPrimaryKey()
        
        let testBundle = Bundle(for: type(of: self))
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        let data = ImageUtil().createBase64String(image: img!)
        
        let img2 = UIImage(named: "testImg2.jpg", in: testBundle, compatibleWith: nil)
        let data2 = ImageUtil().createBase64String(image: img2!)
        
        let obj1 = CaptivaLocalImageObj()
        obj1.imageBase64Data = data
        obj1.batchNumber = vc.batchNum
        
        let obj2 = CaptivaLocalImageObj()
        obj2.imageBase64Data = data2
        obj2.batchNumber = vc.batchNum

        let imageService = CaptivaLocalImageService()
        XCTAssertTrue(imageService.deleteAllImages())
        XCTAssertTrue(imageService.saveImage(image: obj1))
        XCTAssertTrue(imageService.saveImage(image: obj2))
        let exp = expectation(description: "read")
        
        let batchObj = batchService.getBatchWithBatchNum(num: vc.batchNum)
        vc.chainedUploadNetworkCall(batchObj: batchObj!){
            dict, error in
            //3)validate
            XCTAssertNil(dict)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    
    }
}
