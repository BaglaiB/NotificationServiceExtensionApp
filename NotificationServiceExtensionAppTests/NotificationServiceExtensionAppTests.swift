//
//  NotificationServiceExtensionAppTests.swift
//  NotificationServiceExtensionAppTests
//
//  Created by BaglaiB on 25.04.2020.
//  Copyright © 2020 bogdan. All rights reserved.
//

import XCTest
import NotificationServiceExtensionApp
import SimulatorRemoteNotifications.ACSimulatorRemoteNotificationsService

@testable import NotificationServiceExtensionApp

class NotificationServiceExtensionAppTests: XCTestCase {

    var tableViewController: TableViewController!

    override func setUp() {
        guard let tableViewController = UIApplication.shared.windows[1].rootViewController as? TableViewController else {
            XCTAssert(false, "TableViewController needed to be as rootViewController")
            return
        }
        self.tableViewController = tableViewController
    }

    override func tearDown() {

    }

    func testMessageNotification() {

        let testMessage = "test message \(arc4random())"
        let dictionary = ["message": testMessage]
        ACSimulatorRemoteNotificationsService.shared()?.send(dictionary)

        XCTestCase.sleep(0.1)

        let lastMessageInTable = tableViewController.tableViewModel.cellVMs.last ?? ""
        XCTAssert(lastMessageInTable.contains(testMessage), "Message notification not in the table")
    }

    func testBodyNotification() {

        let body = arc4random() % 123
        let dictionary = ["body": body]
        ACSimulatorRemoteNotificationsService.shared()?.send(dictionary)

        XCTestCase.sleep(0.1)

        let lastMessageInTable = tableViewController.tableViewModel.cellVMs.last ?? ""
        XCTAssert(lastMessageInTable.contains("body:\(body * 2)"), "Body notification not in the table")
    }

}

extension XCTestCase {
    static func sleep(_ seconds: Double) {
        let date = Date()
        while true {
            RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 1))
            if Date().timeIntervalSince(date) > seconds {
                break
            }
        }
    }
}
