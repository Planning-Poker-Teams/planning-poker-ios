//
//  Planning_PokerUITests.swift
//  Planning PokerUITests
//
//  Created by Christian Stangier on 31.01.20.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import XCTest

class PlanningPokerUITests: XCTestCase {
    private var app: XCUIApplication?

    override func setUp() {
        app = XCUIApplication()
        app!.launchArguments.append("--uitesting")
        continueAfterFailure = false
        setupSnapshot(app!)
        app!.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJoinARoom() {
        let roomTextField = app!.textFields["roomTextField"]
        roomTextField.clearAndEnterText(text: "Test")

        let nameTextField = app!.textFields["nameTextField"]
        nameTextField.clearAndEnterText(text: "Franz")
        // ^ UI test fails here
        
        snapshot("01JoinRoomScreen")

        app!.buttons["joinRoomLink"].tap()
        snapshot("02NotStartedScreen")
    }
}
