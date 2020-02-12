//
//  GreatNotesTests.swift
//  GreatNotesTests
//
//  Created by Sergey Vasilevkin on 12/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import XCTest
import CoreData

class GreatNotesTests: XCTestCase {
    private var context: NSManagedObjectContext?
    
    override func setUp() {
        self.context = NSManagedObjectContext.contextForTests()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNoteCreateSaveAndFetchCoreData() {
        var notes : [NSManagedObject] = []
        
        do {
            let entity = NSEntityDescription.entity(forEntityName: Constants.Note.name, in: context!)
            let note = NSManagedObject(entity: entity!, insertInto: context)
            
            note.setValue("test title", forKeyPath: Constants.Note.title)
            note.setValue("test text", forKeyPath: Constants.Note.text)
            note.setValue("February 12, 2020", forKeyPath: Constants.Note.timestamp)
            
            try context!.save()
        } catch let error as NSError {
            print("Test error. Could not save. \(error), \(error.userInfo)")
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Note.name)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            notes = try (self.context!.fetch(fetchRequest))
            
        } catch let error as NSError {
            print("Test error. Could not fetch. \(error), \(error.userInfo)")
        }
        
        let noteTitle = notes.first!.value(forKeyPath: Constants.Note.title) as? String
        let noteText = notes.first!.value(forKeyPath: Constants.Note.text) as? String
        let noteTimestamp = notes.first!.value(forKeyPath: Constants.Note.timestamp) as? String
        
        XCTAssertEqual(noteTitle!, "test title", "Wrong note title")
        XCTAssertEqual(noteText!, "test text", "Wrong note text")
        XCTAssertEqual(noteTimestamp!, "February 12, 2020", "Wrong note timestamp")
    }
}
