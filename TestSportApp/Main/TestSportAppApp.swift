//
//  TestSportAppApp.swift
//  TestSportApp
//
//  Created by Martin Mikula on 29/07/2025.
//

import SwiftData
import SwiftUI
import FirebaseCore

private class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TestSportAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @StateObject private var dataStorageManager = DataStorageManager()
    
    var body: some Scene {
        WindowGroup {
            SportActivitiesView(dataStorageManager: dataStorageManager)
        }
    }
}
