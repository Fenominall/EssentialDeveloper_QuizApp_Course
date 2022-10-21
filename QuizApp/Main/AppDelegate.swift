//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Fenominall on 7/17/22.
//

import SwiftUI
import UIKit
import QuizEngine

class QuizAppStore {
    var quiz: Quiz?
}

@main
struct QuizApp: App {
    let appStore = QuizAppStore()
    @StateObject var navigationStore = QuizNavigationStore()

    var body: some Scene {
        WindowGroup {
            QuizNavigationView(store: navigationStore)
                .onAppear {
                    startNewQuiz()
                }
        }
    }

    private func startNewQuiz() {
        let adapter = iOSSwiftUINavigationAdapter(
            // using polymorfic behavior to aviod using boleans and if statments
            navigation: navigationStore,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: startNewQuiz)

        appStore.quiz = Quiz.start(questions: questions, delegate: adapter)
    }
}


//@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
