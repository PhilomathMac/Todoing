//
//  ItemsViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/2/22.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController {
    // MARK: - Properties
    var itemArray = [Item]()
//    var selectedList : List? {
//        // Initialize itemArray
//        didSet {
//            loadItems()
//        }
//    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Data Model Management Methods
    func saveItems() {
        
        do {
            try context.save()

        } catch  {
            print("Error saving context: \(error.localizedDescription)")
        }
        
        // Reload Data
        self.tableView.reloadData()
    }
    
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {
//
//        let listPredicate = NSPredicate(format: "parentList.name MATCHES %@", selectedList!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, additionalPredicate])
//        } else {
//            request.predicate = listPredicate
//        }
//
//        do {
//           itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from core data: \(error)")
//        }
//
//        tableView.reloadData()
//
//    }

    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoing Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // Check new item is valid
            guard textField.text != "" else {return}
            guard let newTask = textField.text?.trimmingCharacters(in: .newlines) else { return }
            
            // Add new item
//            let newItem = Item(context: self.context)
//            newItem.title = newTask
//            newItem.done = false
//            newItem.parentList = self.selectedList
            
//            self.itemArray.append(newItem)
            
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

extension ItemsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a Cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let task = itemArray[indexPath.row]
        
        // Setup Cell
        newCell.textLabel?.text = task.title
        newCell.accessoryType = task.done ? .checkmark : .none
        
        // Return cell
        return newCell
        
    }
    
}

// MARK: - TableView Delegate

extension ItemsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        // Toggle task's done property when clicked
        item.done.toggle()
        
        // Update a value
//        item.setValue("Completed", forKey: "title")
        
        // Deleting a value
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
    
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

// MARK: - SearchBar Delegate

extension ItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Query Core Data
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        guard let searchString = searchBar.text else { return }
        
        // Predicate specifies how data should be fetched or filtered -> Query Language
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchString)
                
        // Sort data retrieved
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Run request and fetch results
//        loadItems(with: request, and: predicate)
        
        // Reload tableview using search text
        tableView.reloadData()
        
        // Dismiss keyboard
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


