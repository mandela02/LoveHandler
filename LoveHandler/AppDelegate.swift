//
//  AppDelegate.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    var navigator: AppNavigator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppNavigator()
        // testDB()
        return true
    }
    
    func testDB() {
        let note = Note(id: UUID(),
                        time: 10,
                        content: "ád",
                        title: "ád",
                        images: [])
        
        let repo = Repository<Note>(container: PersistenceManager.shared.persistentContainer)
        do {
            try repo.save(model: note)
            try print(repo.countAll())
            print(repo.fetchAllData().map { $0.content })
            print(repo.entityName)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}

extension AppDelegate {
    private func setupAppNavigator() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        navigator = AppNavigator(window: window)
    }
}

