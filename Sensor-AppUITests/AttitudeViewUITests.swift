//
//  AttitudeViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class AttitudeViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - Tests
    func testAttitudeViewToolbarButtons() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Attitude View
        moveToView(app: app, view: "Attitude")
        
        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    func testAttitudeViewGraphs() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Attitude View
        moveToView(app: app, view: "Attitude")
        
        // Show all Graphs
        app.buttons["Toggle Heading Graph"].tap()
        app.buttons["Toggle Yaw Graph"].tap()
        app.buttons["Toggle Pitch Graph"].tap()
        app.buttons["Toggle Roll Graph"].tap()
        
        // Hide all Graphs
        app.buttons["Toggle Roll Graph"].tap()
        app.buttons["Toggle Pitch Graph"].tap()
        app.buttons["Toggle Yaw Graph"].tap()
        app.buttons["Toggle Heading Graph"].tap()
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    func testAttitudeViewSlider() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Attitude View
        moveToView(app: app, view: "Attitude")
        
        // Swipe Up
        app.buttons["Toggle Roll Graph"].swipeUp()
        
        // Adjust Slider to 0% and then 100%
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 1.0)
        
        let updateFrequency = app.sliders["Frequency Slider"].value as! String
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "10.0", "Update frequency should be 50 but is \(splitUpdateFrequency)")
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    func testAttitudeViewShareSheet() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Attitude View
        moveToView(app: app, view: "Attitude")
    
        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    
    // MARK:  - Methods
    func moveToView(app: XCUIApplication, view: String) {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tables.cells[view].buttons[view].tap()
    }
    
    func backToHomeMenu(app: XCUIApplication) {
        sleep(1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        app.tables.cells["Home"].buttons["Home"].tap()
    }
}
