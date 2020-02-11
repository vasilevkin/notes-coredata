//
//  MainScreenViewController.swift
//  Notes
//
//  Created by Sergey Vasilevkin on 11/02/2020.
//  Copyright © 2020 Sergei Vasilevkin. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var notes : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: Constants.noteCellReuseIdentifier)
        
        setupBackground()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNotes()
        tableView.reloadData()
    }
    
    func fetchNotes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Note.name)
        
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setupBackground() {
        let backgroundImage: UIImage = #imageLiteral(resourceName: "paperBackground")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
}

// MARK: - UITableViewDelegate

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil),
            let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? UIViewController,
            let detailsViewController = viewController as? AddNewNoteViewController else {
                return
        }
        
        let note = notes[indexPath.row]
        let objectId = note.objectID.uriRepresentation().absoluteString
        
        print("objectId = \(objectId)")
        
        detailsViewController.note = note
        
        self.present(detailsViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCellReuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.value(forKeyPath: Constants.Note.title) as? String
        cell.backgroundColor = .clear
//        cell.textLabel?.text = notes[indexPath.row]
        
        return cell
    }
}