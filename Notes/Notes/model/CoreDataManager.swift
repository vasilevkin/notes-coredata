//
//  CoreDataManager.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var context: NSManagedObjectContext?
    private var container: NSPersistentCloudKitContainer
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let persistentContainerQueue = OperationQueue()
    
    private init() {
        self.container = appDelegate?.persistentContainer ?? NSPersistentCloudKitContainer()
        self.context = appDelegate?.persistentContainer.viewContext
        persistentContainerQueue.maxConcurrentOperationCount = 1
        context?.automaticallyMergesChangesFromParent = true
    }
    
    func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void) {
        persistentContainerQueue.addOperation {
            let context: NSManagedObjectContext = self.container.newBackgroundContext()
            context.performAndWait {
                block(context)
                try? context.save()
            }
        }
    }
}
