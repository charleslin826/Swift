//
//  NotesListViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDataSource {
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!

    /// The notebook whose notes are being displayed
    var notebook: Notebook!

    //var notes:[Note] = []
    
    var dataController:DataController!
    
    var fetchedResultsController:NSFetchedResultsController<Note>!
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    fileprivate func setupFetchedResultsController() {      //use predicate to fetch the restrict response
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "notebook == %@", notebook)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(notebook)-notes")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }catch {
            fatalError("The fetch could note be performed: \(error.localizedDescription)")
        }
        
        //if let result = try? dataController.viewContext.fetch(fetchRequest) {
        //    notes = result
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem
        
        setupFetchedResultsController()
        
        updateEditButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()  // setup
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil // delete
    }
    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        addNote()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {
        let note = Note(context: dataController.viewContext)
        //note.attributedText = NSAttributedString(string: "New note")
        note.creationDate = Date()
        note.notebook = notebook
        try? dataController.viewContext.save()
//        notes.insert(note , at: 0)
//        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
//        updateEditButtonState()
    }

    // Deletes the `Note` at the specified index path
    func deleteNote(at indexPath: IndexPath) {
       // notebook.removeNote(at: indexPath.row)
        let noteToDelete = /*note*/ fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(noteToDelete)
        try? dataController.viewContext.save()
//        notes.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        if numberOfNotes == 0 {
//            setEditing(false, animated: true)
//        }
//        updateEditButtonState()
    }

    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = /*numberOfNotes > 0 */ fetchedResultsController.sections![0].numberOfObjects > 0
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return numberOfNotes
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let aNote = note(at: indexPath)
        let aNote = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell

        // Configure cell
        cell.textPreviewLabel.attributedText = aNote.attributedText
        //cell.textPreviewLabel.attributedText = aNote.attributedText
        
        if let creationDate = aNote.creationDate {
            cell.dateLabel.text = dateFormatter.string(from: creationDate)
        }
        

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () // Unsupported
        }
    }

//    // Helpers
//
//    var numberOfNotes: Int { return notes.count }
//
//    func note(at indexPath: IndexPath) -> Note {
//        return notes[indexPath.row]
//    }

    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? NoteDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                //vc.note = note(at: indexPath)
                vc.note = fetchedResultsController.object(at: indexPath)
                vc.dataController = dataController
                
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

extension NotesListViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
