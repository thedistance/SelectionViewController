//
//  SelectionViewControllerDemoUITests.swift
//  SelectionViewControllerDemoUITests
//
//  Created by Josh Campion on 13/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

class SelectionViewControllerDemoUITests: XCTestCase {
        
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
    
    func testSingleSelection() {
        let app = XCUIApplication()
        let table = app.tables
        
        let selectionTypeCell = table.childrenMatchingType(.Cell).elementBoundByIndex(0)
        selectionTypeCell.tap()
        
        let newTable = app.tables.elementBoundByIndex(1)
        
        // test can select only one value
        
        // test can deselect value
        
        // test done registers selection
        
        // test cancel doesn't alter selection
        
        // test re-presenting pre-selects the correct cell
    }
    
    func testSingleSelectionRequired() {
        
    }
    
    func testSingleSectionedSelection() {
        
    }
    
    func testSingleSectionedSelectionRequired() {
        
    }
    
    func testMultipleSelection() {
        
    }
    
    func testMultipleSelectionRequired() {
        
    }
    
    func testMultipleSectionedSelection() {
        
    }
    
    func testMultipleSectionedSelectionRequired() {
        
    }
}
