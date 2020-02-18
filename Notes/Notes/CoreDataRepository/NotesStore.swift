//
//  NotesStore.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 18/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation
import CoreData

class NotesStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func insert(_ event: NoteLocal) {
        NoteManagedObject.insert(event, with: context)
    }
    
    func update(_ event: NoteLocal) {
        NoteManagedObject.update(event, with: context)
    }
    
    func delete(_ event: NoteLocal) {
        NoteManagedObject.delete(event, with: context)
    }
    
    func fetchAll() -> [NoteLocal] {
        return NoteManagedObject.fetchAll(from: context)
    }
}
