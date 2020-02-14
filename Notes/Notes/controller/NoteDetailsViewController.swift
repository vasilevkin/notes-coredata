//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextView: UITextView!
    
    var note: Note? {
        didSet {
            updateUI()
        }
    }
    
    private struct EditingNoteData {
        static var newTitle = String()
        static var newText = String()
    }
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("noteId = \(String(describing: note))")
        
        guard let note = note else {
            return
        }
        
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
    
    private func setupView(for note: Note) {
        title = Constants.noteDetailsViewControllerTitle
        titleTextField.text = note.title
        textTextView.text = note.text
    }
    
    private func setDelegates() {
        titleTextField.delegate = self
        textTextView.delegate = self
    }
    
    private func setEditingNoteData(for note: Note) {
        EditingNoteData.newTitle = note.title ?? ""
        EditingNoteData.newText = note.text ?? ""
    }
    
    // MARK: Private
    
    private func updateUI() {
        loadViewIfNeeded()
        titleTextField.text = note?.title
        textTextView.text = note?.text
    }
    
    private func saveNoteIfNeeded() {
        if EditingNoteData.newTitle != titleTextField.text || EditingNoteData.newText != textTextView.text {
            saveNote()
        }
    }
    
    private func saveNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let title = titleTextField.text,
            let text = textTextView.text,
            titleTextField.text != "" else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        if let note = note {
            context.delete(note)
        }
        let entity = NSEntityDescription.entity(forEntityName: Constants.Note.name, in: context)
        
        CoreDataManager.shared.enqueue { [weak self] context in
            self?.setNoteDataValues(for: entity, context: context, title: title, text: text)
        }
    }
    
    private func setNoteDataValues(for entity: NSEntityDescription?, context: NSManagedObjectContext?, title: String?, text: String?) {
        guard let entity = entity,
            let context = context,
            let title = title else {
                return
        }
        
        let date = Date.timeIntervalSinceReferenceDate
        let note = NSManagedObject(entity: entity, insertInto: context)
        
        note.setValue(title, forKeyPath: Constants.Note.title)
        note.setValue(text, forKeyPath: Constants.Note.text)
        
        let updateDate = Date(timeIntervalSinceReferenceDate: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let timestamp = dateFormatter.string(from: updateDate)
        
        note.setValue(timestamp, forKey: Constants.Note.timestamp)
    }
}

// MARK: - UITextViewDelegate

extension NoteDetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textTextView.text else {
            return
        }
        EditingNoteData.newText = text
    }
}

// MARK: - UITableViewDataSource

extension NoteDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let title = titleTextField.text else {
            return false
        }
        EditingNoteData.newTitle = title
        return true
    }
}

// MARK: - UITableViewDataSource

extension NoteDetailsViewController: NoteSelectionDelegate {
    
    func noteSelected(_ newNote: Note) {
        note = newNote
    }
}
