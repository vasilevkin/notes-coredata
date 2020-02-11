//
//  AddNewNoteViewController.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import UIKit
import CoreData

class AddNewNoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextView: UITextView!
    
    var note: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("noteId = \(note)")
        
        guard let note = note else {
            return
        }
        
        titleTextField.text = note.value(forKeyPath: Constants.Note.title) as? String
        textTextView.text = note.value(forKeyPath: Constants.Note.text) as? String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard !(titleTextField.text?.isEmpty ?? false) else {
            return
        }
        saveNote()
    }
    
    private func saveNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let title = titleTextField.text,
            let text = textTextView.text,
            titleTextField.text != "" else {
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.Note.name, in: context)

        CoreDataManager.shared.enqueue { [weak self] context in
            do {
                self?.setNoteDataValues(for: entity, context: context, title: title, text: text)
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func setNoteDataValues(for entity: NSEntityDescription?, context: NSManagedObjectContext?, title: String?, text: String?) {
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
