//
//  ListsTableViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/6/22.
//

import UIKit
import CoreData

class ListsTableViewController: UITableViewController {
    
    var listsArray = [List]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLists()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New List", message: nil, preferredStyle: .alert)
        
        // Create actions
        let addAction = UIAlertAction(title: "Add List", style: .default) { action in
            
            // Validate list name
            guard let listName = textField.text?.trimmingCharacters(in: .newlines) else { return }
            
            // Create list
            let newList = List(context: self.context)
            newList.name = listName
            
            // Add list to array
            self.listsArray.append(newList)
            
            self.saveLists()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add textField to alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new list"
            textField = alertTextField
        }
        
        // Add actions
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        // Show alert
        present(alert, animated: true)
    }

}

// MARK: - TableView DataSource

extension ListsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let list = listsArray[indexPath.row]
        
        // Setup Cell
        newCell.textLabel?.text = list.name
        
        // Return Cell
        return newCell
    }
}

// MARK: - TableView Delegate

extension ListsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

// MARK: - Data Manipulation Methods
extension ListsTableViewController {
    
    func saveLists() {
       
        do {
            try context.save()
        } catch {
            print("Error saving list: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadLists(with request: NSFetchRequest<List> = List.fetchRequest()) {
        do {
            listsArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
}
