//
//  ManageNoteProtocol.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 17/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import Foundation

//protocol ManageNoteProtocol {
//    var notes: [NoteLocal] { get set }
//    func addNewNote(_ note: NoteLocal)
//    func addNewNote(with title: String, and text: String)
//    func editNote(with title: String, and text: String, at position: Int)
//    func deleteNote(at position: Int)
//}


protocol ManageNoteProtocol {
//    var notes: [NoteLocal] { get set }
    
    func insert(_ note: NoteLocal)
    func update(_ note: NoteLocal)
    func delete(_ note: NoteLocal)
    func fetchAll() -> [NoteLocal]
//
//    func addNewNote(_ note: NoteLocal)
//    func addNewNote(with title: String, and text: String)
//    func editNote(with title: String, and text: String, at position: Int)
//    func deleteNote(at position: Int)
}
