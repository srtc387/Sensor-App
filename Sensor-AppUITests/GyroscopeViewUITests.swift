//
//  GyroscopeViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import XCTest
@testable import Sensor_App

// MARK: - Class Definition
class GyroscopeViewUITests: BaseTestCase {
    func testGyroscopeViewToolbarButtons() throws {
        // Go to Gyroscope View
        moveToView(view: "Gyroscope")

        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testGyroscopeViewGraphs() throws {
        // Go to Gyroscope View
        moveToView(view: "Gyroscope")

        // Show all Graphs
        app.buttons["Toggle Z-Axis Graph"].tap()
        app.buttons["Toggle Y-Axis Graph"].tap()
        app.buttons["Toggle X-Axis Graph"].tap()

        // Hide all Graphs
        app.buttons["Toggle X-Axis Graph"].tap()
        app.buttons["Toggle Y-Axis Graph"].tap()
        app.buttons["Toggle Z-Axis Graph"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testGyroscopeViewSlider() throws {
        // Go to Gyroscope View
        moveToView(view: "Gyroscope")

        // Swipe Up
        app.buttons["Toggle X-Axis Graph"].swipeUp()

        // Adjust Slider to 0% and then 100%
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 1.0)

        let updateFrequency = app.sliders["Frequency Slider"].value as! String // swiftlint:disable:this force_cast
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "10.0", "Update frequency should be 50 but is \(splitUpdateFrequency)")

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testGyroscopeViewShareSheet() throws {
        // Go to Gyroscope View
        moveToView(view: "Gyroscope")

        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
