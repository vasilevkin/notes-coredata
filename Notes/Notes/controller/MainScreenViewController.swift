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
        
        updateImageForCurrentTraitCollection()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNotesFromCoreData()
    }

    private func fetchNotesFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Note.name)
        
        fetchRequest.returnsObjectsAsFaults = false

        CoreDataManager.shared.enqueue { _ in
            do {
                self.notes = try (managedContext.fetch(fetchRequest) as? [Note] ?? [])
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    private func setupBackground() {
        let backgroundImage: UIImage = #imageLiteral(resourceName: "paperBackground")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
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

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil),
            let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? UIViewController,
            let detailsViewController = viewController as? NoteDetailsViewController else {
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
