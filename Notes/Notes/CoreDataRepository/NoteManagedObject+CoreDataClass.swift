//
//  NoteManagedObject+CoreDataClass.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 18/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NoteManagedObject)
final public class NoteManagedObject: NSManagedObject, ManagedObjectConvertible {
    
    typealias T = NoteLocal
    
    func from(object: NoteLocal) {
        title = object.title
        text = object.text
        timestamp = object.timestamp
    }
    
    func toObject() -> NoteLocal {
        return NoteLocal(
            title: title ?? "",
            text: text,
            timestamp: timestamp,
            identifier: identifier
        )
    }
}
