//
//  HomeViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/2/22.
//

import UIKit

class HomeViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MOCK DATA
        let newItem = Item()
        newItem.title = "Coding"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Shopping"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Interview Practice"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ItemArray") as? [Item] {
            itemArray = items
        }
    }

    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoing Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // Check new item is valid
            guard textField.text != "" else {return}
            guard let newTask = textField.text?.trimmingCharacters(in: .newlines) else { return }
            
            // Add new item
            let newItem = Item()
            newItem.title = newTask
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ItemArray")
            
            // Reload Data
            self.tableView.reloadData()
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
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


