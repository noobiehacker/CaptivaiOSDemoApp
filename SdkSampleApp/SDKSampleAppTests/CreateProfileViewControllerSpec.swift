//
//  CreateProfileViewControllerSpec.swift
//  SDKSampleApp
//
//  Created by davix on 10/7/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import Quick
import Nimble
import RealmSwift
@testable import SDKSampleApp

class CreateProfileViewControllerSpec: QuickSpec {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override func spec() {
        describe("Get Filter Names") {
            it("it has a Black - White Filter") {
                let vc = CreateProfileViewController()
                let filterList = vc.getFilterList()
                let result = filterList.contains("Black-White")
                expect(result).to(beTruthy())
            }
            it("it has a Gray Filter"){
                let vc = CreateProfileViewController()
                let filterList = vc.getFilterList()
                let result = filterList.contains("Gray")
                expect(result).to(beTruthy())
            }
            it("it has a darker filter"){
                let vc = CreateProfileViewController()
                let filterList = vc.getFilterList()
                let result = filterList.contains("Deskew")
                expect(result).to(beTruthy())
            }
        }
    }
}
