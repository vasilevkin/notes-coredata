//
//  CoreDataManager+Tests.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 12/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    class func contextForTests() -> NSManagedObjectContext {
        // Get the model
        let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
        
        // Create and configure the coordinator
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Setup the context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
}
