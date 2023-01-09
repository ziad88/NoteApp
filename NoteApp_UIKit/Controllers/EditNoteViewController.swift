//
//  EditNoteViewController.swift
//  NoteApp_UIKit
//
//  Created by Ziad Alfakharany on 29/12/2022.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController {
   
    var note = [Note]()
    var selectedNote: Note! {
        didSet {
            loadItems()
        }
    }
    @IBOutlet weak var txtView: UITextView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedNote.title
        if(selectedNote != nil) {
            txtView.text = selectedNote.text
        }
        loadItems()
    }
    
    @IBAction func saveButtonPresed(_ sender: UIBarButtonItem) {
        
        selectedNote.text = txtView.text
        
        saveItems()
        navigationController?.popViewController(animated: true)
 
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving data\(error)")
        }
    }
    
    func loadItems() {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            note = try context.fetch(request)
        } catch {
            print("error fetching data\(error)")
        }
    }
}

