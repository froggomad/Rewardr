//
//  RewardrUITests.swift
//  RewardrUITests
//
//  Created by Kenny on 5/14/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import XCTest


class RewardrUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }

    func testLoginParent() {
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("amclv@gmail.com")
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("123456")
        app.buttons["  Login/Register  "].tap()
    }
}
