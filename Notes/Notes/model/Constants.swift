//
//  Constants.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation

struct Constants {
    static let noteCellReuseIdentifier = "NoteCell"
    static let noteCellNibName = "NoteTableViewCell"

    static let noteDetailsViewControllerTitle = "Edit note"
    
    // CoreData entity Note
    struct Note {
        static let name = "Note"
        static let noteId = "noteId"
        static let title = "title"
        static let text = "text"
        static let timestamp = "timestamp"
    }
}
