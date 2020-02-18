//
//  NotesListViewController.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import UIKit
import CoreData

protocol NoteSelectionDelegate: class {
    func noteSelected(_ newNote: NoteLocal, at position: Int)
}

class NotesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notes : [NoteLocal] = []
//    var noteManager: ManageNoteProtocol? = nil
    weak var delegate: NoteSelectionDelegate?
    
    
    var store: ManageNoteProtocol? = nil

    
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        noteManager = CoreDataManager.shared
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        store = appDelegate.store

        
        
        setupTableView()
        setupBackground()
        updateImageForCurrentTraitCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notes = store?.fetchAll() ?? []
            
//        notes = noteManager?.notes ?? []
        tableView.reloadData()
        
        print("NotesListViewController  notes = \(notes)")
    }
    
    // MARK: Initial setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.noteCellNibName, bundle: nil), forCellReuseIdentifier: Constants.noteCellReuseIdentifier)
    }
    
    private func setupBackground() {
        let backgroundImage: UIImage = #imageLiteral(resourceName: "paperBackground")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    // MARK: Private
    
    // MARK: - Dark Mode Support
    
    private func updateImageForCurrentTraitCollection() {
        if traitCollection.userInterfaceStyle == .dark {
            self.tableView.backgroundView = nil
        } else {
            self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "paperBackground"))
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateImageForCurrentTraitCollection()
    }
}

// MARK: - UITableViewDelegate

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]

        delegate?.noteSelected(selectedNote, at: indexPath.row)
        
        if let detailViewController = delegate as? NoteDetailsViewController,
            let detailNavigationController = detailViewController.navigationController {
            detailViewController.delegate = CoreDataManager.shared
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCellReuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        print("notes[indexPath.row] = \(notes[indexPath.row])")
        
        cell.setNoteData(for: notes[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
//            noteManager?.deleteNote(at: indexPath.row)
//            notes = noteManager?.notes ?? []
            tableView.reloadData()
        }
    }
}


//extension NotesListViewController: AddNewNoteDelegate {
//    func didAddNote(with title: String, and text: String) {
//
//
//        // Create Note
////        let note = Note()
//
//        let date = Date.timeIntervalSinceReferenceDate
//        let updateDate = Date(timeIntervalSinceReferenceDate: date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.long
//        dateFormatter.timeZone = .current
//        let timestamp = dateFormatter.string(from: updateDate)
//
//
//        let note = NoteLocal(title: title, text: text, timestamp: timestamp)
//
//
//
//        // Populate Note
////        note.title = title
////        note.text = text
////        note.timestamp = timestamp
//
//
//        noteManager?.addNewNote(note)
//
//
//
////        CoreDataManager.shared.addNewNote(note)
//
//
////        do {
////            try note.managedObjectContext?.save()
////        } catch {
////            let saveError = error as NSError
////            print("Unable to Save Note")
////            print("\(saveError), \(saveError.localizedDescription)")
////        }
//
//    }
//}
