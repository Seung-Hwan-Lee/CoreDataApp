//
//  AppDelegate.swift
//  CoreDataApp
//
//  Created by Thomas on 2020/08/28.
//  Copyright © 2020 Thomas. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
      guard
        let url = Bundle.main.url(forResource: "People", withExtension: "momd"),
        let modelURL = NSManagedObjectModel(contentsOf: url),
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
      else {
        fatalError()
      }
      var storeURL = URL(fileURLWithPath: cachePath, isDirectory: true)
      storeURL.appendPathComponent("People.sqlite")

      let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: modelURL)

      do {
        try persistentStoreCoordinator.addPersistentStore(
          ofType: NSSQLiteStoreType,
          configurationName: nil,
          at: storeURL,
          options: nil
        )
      }
      catch {
        fatalError()
      }
      return persistentStoreCoordinator
    }()

    lazy var rootContext: NSManagedObjectContext = {
      let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      context.persistentStoreCoordinator = persistentStoreCoordinator
      return context
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        if isUseRootContext {
            context.parent = rootContext
        }
        else {
            context.persistentStoreCoordinator = persistentStoreCoordinator
        }
        return context
    }()

    lazy var viewContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        if isUseRootContext {
            context.parent = rootContext
        }
        else {
            context.persistentStoreCoordinator = persistentStoreCoordinator
        }
        return context
    }()

    var isUseRootContext: Bool {
        get {
            UserDefaults.standard.bool(forKey: Key.isUseRootContext.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isUseRootContext.rawValue)
        }
    }
}

enum Key: String {
    case isUseRootContext
    case isDataInserted
}

