//
//  ViewController.swift
//  NoteApp_UIKit
//
//  Created by Ziad Alfakharany on 28/12/2022.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {

    
    var notes = [Note]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg4"))
        loadItems()
    }

    
    //MARK: - tableView delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseableCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToText", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditNoteViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notes[indexPath.row]
        }
    }


    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "add new note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default) { action in
            
            let newNote = Note(context: self.context)
            newNote.title = alertTextField.text!
            self.notes.append(newNote)
            
            self.saveItems()
        }
        alert.addTextField() { (alertTxtField) in
            alertTxtField.placeholder = "Create New Note"
            alertTextField = alertTxtField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = notes[indexPath.row]
            context.delete(commit)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            saveItems()
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving data\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("error fetching data\(error)")
        }
        tableView.reloadData()
    }
}

