//
//  SwipeableTableViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/20/22.
//

import UIKit
import SwipeCellKit

class SwipeableTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        // Check orientation of the swipe
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            
        }
        
            deleteAction.image = UIImage(systemName: "trash")
            
            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
        
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Functionality implemented in subclasses by overriding
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // Setup Cell
        newCell.delegate = self
        
        // Return Cell
        return newCell
    }

}
