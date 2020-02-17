//
//  ManageNoteProtocol.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 17/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation

protocol ManageNoteProtocol {
    var notes: [NoteLocal] { get set }
    func addNewNote(_ note: NoteLocal)
    func addNewNote(with title: String, and text: String)
    func editNote(_ note: NoteLocal)
    func deleteNote(_ note: NoteLocal)    
}
