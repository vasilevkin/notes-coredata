//
//  NoteManagedObject+CoreDataProperties.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 18/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteManagedObject> {
        return NSFetchRequest<NoteManagedObject>(entityName: "NoteManagedObject")
    }
    
    @NSManaged public var text: String?
    @NSManaged public var timestamp: String?
    @NSManaged public var title: String?
}
