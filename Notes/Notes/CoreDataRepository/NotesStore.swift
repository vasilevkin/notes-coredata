//
//  NotesStore.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 18/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation
import CoreData

class NotesStore : ManageNoteProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func insert(_ note: NoteLocal) {
        NoteManagedObject.insert(note, with: context)
        
        print("NotesStore  notes = \(fetchAll())")

    }
    
    func update(_ note: NoteLocal) {
        NoteManagedObject.update(note, with: context)
    }
    
    func delete(_ note: NoteLocal) {
        NoteManagedObject.delete(note, with: context)
    }
    
    func fetchAll() -> [NoteLocal] {
        return NoteManagedObject.fetchAll(from: context)
    }
}
