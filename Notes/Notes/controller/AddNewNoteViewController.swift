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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard !(titleTextField.text?.isEmpty ?? false) else {
            return
        }
        saveNote()
    }
    
    private func saveNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let entity = NSEntityDescription.entity(forEntityName: Constants.Note.name, in: appDelegate.persistentContainer.viewContext),
            let title = titleTextField.text,
            let text = textTextView.text else {
                return
        }
        
        let note = NSManagedObject(entity: entity, insertInto: appDelegate.persistentContainer.viewContext)
        
        note.setValue(title, forKeyPath: Constants.Note.title)
        note.setValue(text, forKeyPath: Constants.Note.text)
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
