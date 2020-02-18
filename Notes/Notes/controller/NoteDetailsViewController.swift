//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import UIKit
import CoreData

protocol AddNewNoteDelegate {
    func didAddNote(with title: String, and text: String)
}

class NoteDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextView: UITextView!
    
    var delegate: AddNewNoteDelegate?
    
    var store: ManageNoteProtocol? = nil
//    var noteManager: ManageNoteProtocol? = CoreDataManager.shared
    var position: Int?
    
    var note: NoteLocal? {
        didSet {
            updateUI()
        }
    }
    
    private var editingNoteData = EditingNoteData(newTitle: "", newText: "")
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("noteId = \(String(describing: note))")
        
        guard let note = note else {
            return
        }
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        store = appDelegate.store
        
        
        setupView(for: note)
        setEditingNoteData(for: note)
        setDelegates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard !(titleTextField.text?.isEmpty ?? false) else {
            return
        }
        
        saveNoteIfNeeded()
    }
    
    // MARK: Initial setup
    
    private func setupView(for note: NoteLocal) {
        title = Constants.noteDetailsViewControllerTitle
        titleTextField.text = note.title
        textTextView.text = note.text
    }
    
    private func setDelegates() {
        titleTextField.delegate = self
        textTextView.delegate = self
    }
    
    private func setEditingNoteData(for note: NoteLocal) {
        editingNoteData.newTitle = note.title
        editingNoteData.newText = note.text ?? ""
    }
    
    // MARK: Private
    
    private func updateUI() {
        loadViewIfNeeded()
        titleTextField.text = note?.title
        textTextView.text = note?.text
    }
    
    private func saveNoteIfNeeded() {
        if editingNoteData.newTitle != titleTextField.text || editingNoteData.newText != textTextView.text {
            saveNote()
        }
    }
    
    private func saveNote() {
        guard let title = titleTextField.text,
            let text = textTextView.text,
            titleTextField.text != "" else {
                return
        }
        
        if let position = position {
//            noteManager?.editNote(with: title, and: text, at: position)
        } else {
//            noteManager?.addNewNote(with: title, and: text)
        }
        
        guard let delegate = delegate else {
            return
        }
        
        let noteLocal = NoteLocal(title: title, text: text, timestamp: "")

        let man = CoreDataManager.shared
        
        let locStore  = NotesStore(context: man.managedObjectContext)

        locStore.insert(noteLocal)

//        store?.insert(noteLocal)
    
        print("store?.insert(noteLocal) = \(noteLocal)")
        print("NoteDetailsViewController  notes = \(locStore.fetchAll())")

        // Notify Delegate
        delegate.didAddNote(with: title, and: text)
        
        // Dismiss NoteDetailsViewController
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextViewDelegate

extension NoteDetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textTextView.text else {
            return
        }
        editingNoteData.newText = text
    }
}

// MARK: - UITableViewDataSource

extension NoteDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let title = titleTextField.text else {
            return false
        }
        editingNoteData.newTitle = title
        return true
    }
}

// MARK: - UITableViewDataSource

extension NoteDetailsViewController: NoteSelectionDelegate {
    
    func noteSelected(_ newNote: NoteLocal, at position: Int) {
        note = newNote
        self.position = position
    }
    
}
