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
        describe("Add Filter To Selected List"){
            it("contains a filter after adding it to list"){
                let vc = CreateProfileViewController()
                let filter = "A Filter"
                let result = vc.addFilterToList(filter: filter)
                expect(result).to(beTruthy())
                
                let selectedList = vc.filterSelected
                expect(selectedList.contains(filter)).to(beTruthy())
            }
        }
        describe("Remove Filter From Selected List"){
            it("Filter is removed after function is called"){
                //First Add A Filter
                let vc = CreateProfileViewController()
                let filter = "A Filter"
                expect(vc.addFilterToList(filter: filter)).to(beTruthy())
                expect(vc.filterSelected.contains(filter)).to(beTruthy())
                let result = vc.removeFilterFromList(filter: filter)
                expect(result).to(beTruthy())
                expect(vc.filterSelected.contains(filter)).to(beFalse())
            }
        }
        describe("Create filter profile"){
            it("creates a filter profile with the list of filters selected"){
                let vc = CreateProfileViewController()
                let filterOne = "One filter"
                let filterTwo = "Second filter"
                expect(vc.addFilterToList(filter: filterOne)).to(beTruthy())
                expect(vc.addFilterToList(filter: filterTwo)).to(beTruthy())
                let result = vc.createFilterProfile()
                expect(result?.filters.count).to(equal(2))
            }
        }
    }
}
