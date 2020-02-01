//
//  SceneDelegate.swift
//  PlanningPoker
//
//  Created by Christian Stangier on 16.01.20.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let isInUITesting = CommandLine.arguments.contains("--uitesting")

    var window: UIWindow?

    @iCloudUserDefault("roomName", defaultValue: "") var lastRoomName: String
    @iCloudUserDefault("participantName", defaultValue: "") var lastParticipantName: String

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if isInUITesting {
            print("ToDo: initialize mock store")
        }

        let contentView = JoinRoomView(
            roomName: lastRoomName,
            participantName: lastParticipantName
        )
        .environmentObject(Store())

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
