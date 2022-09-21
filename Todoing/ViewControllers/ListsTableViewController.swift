//
//  ListsTableViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/6/22.
//

import UIKit
import RealmSwift

class ListsTableViewController: SwipeableTableViewController {
    
    let realm = try! Realm()
    
    var lists: Results<UserList>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
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
            let newList = UserList()
            newList.name = listName
            
            self.saveList(newList)
            
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
    
    // MARK: - Data Manipulation Methods
    func saveList(_ userList: UserList) {
       
        do {
            try realm.write {
                realm.add(userList)
            }
        } catch {
            print("Error saving list: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadLists() {

        lists = realm.objects(UserList.self)

        tableView.reloadData()
    }
    
    // Delete list from swipe
    override func updateModel(at indexPath: IndexPath) {
        guard let listToDelete = self.lists?[indexPath.row] else { return }
        
        do {
            try self.realm.write {
                self.realm.delete(listToDelete)
            }
        } catch {
            print("Error saving deletion: \(error.localizedDescription)")
        }
        
    }

}

// MARK: - TableView DataSource

extension ListsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get cell from superclass
        let newCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Setup Cell
        newCell.textLabel?.text = lists?[indexPath.row].name ?? "No lists added yet"
        newCell.accessoryType = .detailButton
        
        // Return Cell
        return newCell
    }
}

// MARK: - TableView Delegate

extension ListsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedList = lists?[indexPath.row]
            
        }
    }
    
    // Show color picker
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // Present ColorPicker
        presentColorPicker()
        
        // Get ColorPicker's Color
        // Set list's color
        
    }
    
}

// MARK: - ColorPicker

extension ListsTableViewController: UIColorPickerViewControllerDelegate {
    
    @objc func presentColorPicker() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        
        let color = viewController.selectedColor
        
    }
    
}
