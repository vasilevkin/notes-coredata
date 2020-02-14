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
    
    private var fetchedResultsController: NSFetchedResultsController<Note>?

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
                do {
                    block(context)
                    try context.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func addNewNote(_ note: Note) {
        
    }
    
    func deleteNote(_ note: Note) {
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        do {
            managedContext?.delete(note)
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateNote(_ note: Note) {
        
    }

    func fetchAllNotesFromCoreData() -> [Note] {
        
        
        
        
        var notes: [Note] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Note.name)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            notes = try (managedContext.fetch(fetchRequest) as? [Note] ?? [])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }        
        return notes
    }
}
