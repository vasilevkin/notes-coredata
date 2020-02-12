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
    
    var note: NSManagedObject?
    
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
        
        titleTextField.text = note.value(forKeyPath: Constants.Note.title) as? String
        textTextView.text = note.value(forKeyPath: Constants.Note.text) as? String
        
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
    
    private func setDelegates() {
        titleTextField.delegate = self
        textTextView.delegate = self
    }
    
    private func setEditingNoteData(for note: NSManagedObject) {
        EditingNoteData.newTitle = note.value(forKeyPath: Constants.Note.title) as? String ?? ""
        EditingNoteData.newText = note.value(forKeyPath: Constants.Note.text) as? String ?? ""
    }
    
    // MARK: Private
    
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
        
        var entity: NSEntityDescription?
        if let note = note {
            entity = note.entity
        } else {
            entity = NSEntityDescription.entity(forEntityName: Constants.Note.name, in: context)
        }
        
        CoreDataManager.shared.enqueue { [weak self] context in
            do {
                self?.setNoteDataValues(for: entity, context: context, title: title, text: text)
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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
