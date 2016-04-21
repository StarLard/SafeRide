//
//  CoreDataServiceTests.swift
//  CoreDataServiceTests
//
//  Created by Zachary Jones on 4/20/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import XCTest
@testable import SafeRide

class CoreDataServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    // Tests to see if the core data construct is being initialized properly
    func testCoreDataServiceMainQueueContextExists() {
        let settingsService = SettingsService.sharedSettingsService
        XCTAssertNotNil(settingsService, "SettingsService singleton should not be nil")
    }
    
}
