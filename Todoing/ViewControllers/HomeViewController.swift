//
//  HomeViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/2/22.
//

import UIKit
import CoreData

class HomeViewController: UITableViewController {
    // MARK: - Properties
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    // MARK: - Item Management Methods
    func saveItems() {
        
        do {
            try context.save()

        } catch  {
            print("Error saving context: \(error.localizedDescription)")
        }
        
        // Reload Data
        self.tableView.reloadData()
    }
    
    // MARK: - Load Items
    func loadItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from core data: \(error)")
        }
        
    }

    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoing Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // Check new item is valid
            guard textField.text != "" else {return}
            guard let newTask = textField.text?.trimmingCharacters(in: .newlines) else { return }
            
            // Add new item
            let newItem = Item(context: self.context)
            newItem.title = newTask
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Setup alert with a textField
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true)
    }
    
}

// MARK: - TableView DataSource

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a Cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ListNameCell", for: indexPath)
        let task = itemArray[indexPath.row]
        
        // Setup Cell
        newCell.textLabel?.text = task.title
        newCell.accessoryType = task.done ? .checkmark : .none
        
        // Return cell
        return newCell
        
    }
    
}

// MARK: - TableView Delegate

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = itemArray[indexPath.row]
        
        // Toggle task's done property when clicked
        task.done.toggle()
        self.saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


