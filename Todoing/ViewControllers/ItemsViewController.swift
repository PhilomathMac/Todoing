//
//  ItemsViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/2/22.
//

import UIKit
import RealmSwift

class ItemsViewController: SwipeableTableViewController {
    // MARK: - Properties
    var items: Results<Item>?
    
    var selectedList : UserList? {
        // Initialize items
        didSet {
            loadItems()
        }
    }
    let realm = try! Realm()

    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = selectedList!.name
        if let navBar = navigationController?.navigationBar {
            if let listColor = UIColor(hex: selectedList!.color ?? "00000000") {
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : listColor]
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : listColor]
                searchBar.tintColor = listColor
                navBar.tintColor = listColor
            }
        }
        
    }

    // MARK: - Data Model Management Methods
    
    func loadItems() {

        items = selectedList?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    // Delete list from swipe
    override func updateModel(at indexPath: IndexPath) {
        guard let itemToDelete = self.items?[indexPath.row] else { return }
        
        do {
            try self.realm.write {
                self.realm.delete(itemToDelete)
            }
        } catch {
            print("Error saving deletion: \(error.localizedDescription)")
        }
        
    }

    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoing Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // Check validity of newTask and currentList
            guard textField.text != "" else {return}
            guard let newTask = textField.text?.trimmingCharacters(in: .newlines) else { return }
            guard let currentList = self.selectedList else { return }
            
            // Add new item to database
            do {
                try self.realm.write({
                    let newItem = Item()
                    newItem.title = newTask
                    newItem.dateCreated = Date()
                    currentList.items.append(newItem)
                })
            } catch {
                print("Error saving to realm database: \(error.localizedDescription)")
            }
            
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

extension ItemsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get cell from superclass
        let newCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let task = items?[indexPath.row] ?? Item()
        
        // Setup Cell
        newCell.textLabel?.text = task.title
        newCell.accessoryType = task.done ? .checkmark : .none
        
        if let listColor = UIColor(hex: selectedList?.color ?? "00000000") {
            let alphaAmount = 0.1 * Double(indexPath.row)
            let cellColor = listColor.withAlphaComponent(alphaAmount)
            newCell.backgroundColor = cellColor
            
            /*
             PROBLEM CHANGING CELL COLORS - contrast calculated using brightness and brightness does not change when alpha changes
            //DEBUG:
            print("CELL \(indexPath.row)")
            print("CellColor: \(cellColor.accessibilityName)")
            if cellColor.contrastRatio(withColor: .black) ?? 0 < 10 {
                //DEBUG:
                print("Contrast With Black: \(cellColor.contrastRatio(withColor: .black))")
                newCell.textLabel?.textColor = .white
            } else if cellColor.contrastRatio(withColor: .white) ?? 0 < 10 {
                //DEBUG:
                print("Contrast With White: \(cellColor.contrastRatio(withColor: .white))")
                newCell.textLabel?.textColor = .black
            }
            //DEBUG:
            print("TextColor: \(newCell.textLabel?.textColor.accessibilityName)")
             */
            
        }
        
        // Return cell
        return newCell
        
    }
    
}

// MARK: - TableView Delegate

extension ItemsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Error toggling done: \(error.localizedDescription)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

// MARK: - SearchBar Delegate

extension ItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchString = searchBar.text else { return }
        
        items = items?.filter("title CONTAINS[cd] %@", searchString).sorted(byKeyPath: "title", ascending: true)
        
        // Reload tableview using search text
        tableView.reloadData()
        
        // Dismiss keyboard
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


