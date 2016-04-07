//
//  SafeRideUITests.swift
//  SafeRideUITests
//
//  Created by Caleb Friden on 3/30/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import XCTest

class SafeRideUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    func testStandardTapUse() {
        // Goes through a standard procedure of what a user would normally do using tapping for selecting locations
        
        
        let app = XCUIApplication()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        app.otherElements["PopoverDismissRegion"].tap()
        app.navigationBars["Press Next to Continue"].buttons["Next"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containingType(.StaticText, identifier:"Number of Riders").childrenMatchingType(.TextField).element.tap()
        app.pickerWheels["1"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Ride Time").childrenMatchingType(.TextField).element.tap()
        
        let datePickersQuery = app.datePickers
        datePickersQuery.pickerWheels["4 o'clock"].tap()
        datePickersQuery.pickerWheels["37 minutes"].tap()
        
        let doneButton = app.toolbars.buttons["Done"]
        doneButton.tap()
        
        let phoneNumberCellsQuery = tablesQuery.cells.containingType(.StaticText, identifier:"Phone Number")
        phoneNumberCellsQuery.childrenMatchingType(.TextField).element.tap()
        phoneNumberCellsQuery.childrenMatchingType(.TextField).element
        doneButton.tap()
        
        let uoIdNumberCellsQuery = tablesQuery.cells.containingType(.StaticText, identifier:"UO ID Number")
        uoIdNumberCellsQuery.childrenMatchingType(.TextField).element.tap()
        uoIdNumberCellsQuery.childrenMatchingType(.TextField).element
        doneButton.tap()
        app.navigationBars["Confirm Ride Details"].buttons["Send Request"].tap()        
        
        
    }
    
    func testStandardInputUse(){
        // Goes through a standard procedure of what a user would normally do using the text fields for selecting locations
        
        
    }
    
    func testSendingRequest(){
        // Takes inputs from the confirmation page and submits them
        
        
    }
    
}
