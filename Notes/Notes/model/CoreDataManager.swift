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

final class CoreDataManager
//: ManageNoteProtocol
{
    
    func editNote(with title: String, and text: String, at position: Int) {
        notes.remove(at: position)
        addNewNote(with: title, and: text)
    }
        
    func deleteNote(at position: Int) {
       
        
        //CoreData
        let noteLocal = notes[position]
        
                let fetchRequest = NSFetchRequest<NoteManagedObject>(entityName: Constants.Note.name)
        
        
        fetchRequest.predicate = NSPredicate.init(format: "title==\(noteLocal.title)")
        
        do {
            
//        let objects = try! context.fetch(fetchRequest)
//        for obj in objects {
//            context.delete(obj)
//        }
                    
                    let objects = try (managedObjectContext.fetch(fetchRequest) as? [NoteManagedObject] ?? [])
            for obj in objects {
                managedObjectContext.delete(obj)
            }
            try managedObjectContext.save()
            
            
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }

        
//        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
//        fetchRequest.predicate = Predicate.init(format: "profileID==\(withID)")
//        let objects = try! context.fetch(fetchRequest)
//        for obj in objects {
//            context.delete(obj)
//        }
//
//        do {
//            try context.save() // <- remember to put this :)
//        } catch {
//            // Do something... fatalerror
//        }
        
        
        
        
        
        
         notes.remove(at: position)
    }
    
    func addNewNote(with title: String, and text: String) {
        
        let date = Date.timeIntervalSinceReferenceDate
        let updateDate = Date(timeIntervalSinceReferenceDate: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let timestamp = dateFormatter.string(from: updateDate)


        let noteLocal = NoteLocal(title: title, text: text, timestamp: timestamp)

        addNewNote(noteLocal)
        
        
        // CD
        let note = NoteManagedObject(context: managedObjectContext)
        note.title = title
        note.text = text
        note.timestamp = timestamp
        
        do {
                    try note.managedObjectContext?.save()
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Note")
                    print("\(saveError), \(saveError.localizedDescription)")
                }
        
        

    }
    
    func addNewNote(_ note: NoteLocal) {
        notes.append(note)
        
        print("CoreDataManager  addNewNote  notes = \(notes)")

    }
    
//    func editNote(_ note: NoteLocal) {
//
//    }
//
//    func deleteNote(_ note: NoteLocal) {
//
//    }
    
    
    static let shared = CoreDataManager(modelName: "Notes")
    
    lazy var notes : [NoteLocal] = {

        var notesLocal: [NoteLocal] = []
                var notesCoreData: [NoteManagedObject] = []
        
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //            return []
        //        }
        //        let managedContext = appDelegate.persistentContainer.viewContext
        
                let fetchRequest = NSFetchRequest<NoteManagedObject>(entityName: Constants.Note.name)
                fetchRequest.returnsObjectsAsFaults = false
        
                do {
                    notesCoreData = try (managedObjectContext.fetch(fetchRequest) as? [NoteManagedObject] ?? [])
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
        
        for noteCoreData in notesCoreData {
            let noteLocal = NoteLocal(title: noteCoreData.title ?? "", text: noteCoreData.text ?? "", timestamp: noteCoreData.timestamp ?? "")
            notesLocal.append(noteLocal)
        }
        
        print("CoreDataManager  notes = \(notesLocal)")

                return notesLocal
            

        
    }()
    
//        lazy var notes : [Note] = {
//        var notes: [Note] = []
//
////        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
////            return []
////        }
////        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Note.name)
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do {
//            notes = try (managedObjectContext.fetch(fetchRequest) as? [Note] ?? [])
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        return notes
//    }()
    
    private let modelName: String
//    private var context: NSManagedObjectContext?
//    private var container: NSPersistentCloudKitContainer
    
//    private var fetchedResultsController: NSFetchedResultsController<Note>?

//    let appDelegate = UIApplication.shared.delegate as? AppDelegate
//    let persistentContainerQueue = OperationQueue()
    
    
    
    // MARK: - Core Data Stack

    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext()
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        return managedContext
        
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

//        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]

            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()

    
    
    
    
    
    

    // MARK: - Initialization

    init(modelName: String) {
        self.modelName = modelName
    }

    
    
    
        fileprivate lazy var fetchedResultsController: NSFetchedResultsController<NoteManagedObject> = {
            // Initialize Fetch Request
            let fetchRequest: NSFetchRequest<NoteManagedObject> = NoteManagedObject.fetchRequest()
    
            // Add Sort Descriptors
                    let sortDescriptor = NSSortDescriptor(key: Constants.Note.text, ascending: false)
                    fetchRequest.sortDescriptors = [sortDescriptor]
    
    //        let sortDescriptor = NSSortDescriptor(key: Constants.Note.title, ascending: true)
    //        fetchRequest.sortDescriptors = [sortDescriptor]
    
            let note = NoteManagedObject()
    //        guard let co = note.managedObjectContext else {
    //            print("no context")
    //            fatalError()
    //        }
    
    
            // Initialize Fetched Results Controller
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    
            return fetchedResultsController
        }()

    
    
    
    
    
    
    
    
    
//    private init() {
//        self.container = appDelegate?.persistentContainer ?? NSPersistentCloudKitContainer()
//        self.context = appDelegate?.persistentContainer.viewContext
//        persistentContainerQueue.maxConcurrentOperationCount = 1
//        context?.automaticallyMergesChangesFromParent = true
//    }
    
    
    
    
    
    
    func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void) {
//        persistentContainerQueue.addOperation {
//
//            let context: NSManagedObjectContext = self.container.newBackgroundContext()
//            context.performAndWait {
//                do {
//                    block(context)
//                    try context.save()
//                } catch let error as NSError {
//                    print("Could not save. \(error), \(error.userInfo)")
//                }
//            }
//        }
    }
    
    func addNewNote(_ note: NoteManagedObject) {
        

        
        
        do {
//            managedObjectContext.(note)
            
            try note.managedObjectContext?.save()
//            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func editNote(_ note: NoteManagedObject) {
        
    }

    func deleteNote(_ note: NoteManagedObject) {
//        let managedContext = appDelegate?.persistentContainer.viewContext
        
        do {
            managedObjectContext.delete(note)
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

//    func fetchAllNotesFromCoreData() -> [Note] {
//        
//        
//        
//        
//        var notes: [Note] = []
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return []
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Note.name)
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do {
//            notes = try (managedContext.fetch(fetchRequest) as? [Note] ?? [])
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }        
//        return notes
//    }
}


extension CoreDataManager: AddNewNoteDelegate {
    func didAddNote(with title: String, and text: String) {
        
        
        // Create Note
//        let note = Note()

//        let date = Date.timeIntervalSinceReferenceDate
//        let updateDate = Date(timeIntervalSinceReferenceDate: date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.long
//        dateFormatter.timeZone = .current
//        let timestamp = dateFormatter.string(from: updateDate)
//
//
//        let note = NoteLocal(title: title, text: text, timestamp: timestamp)

        
        
        // Populate Note
//        note.title = title
//        note.text = text
//        note.timestamp = timestamp
        

//        self.addNewNote(note)

        
        
//        CoreDataManager.shared.addNewNote(note)
        
        
//        do {
//            try note.managedObjectContext?.save()
//        } catch {
//            let saveError = error as NSError
//            print("Unable to Save Note")
//            print("\(saveError), \(saveError.localizedDescription)")
//        }

    }
}
