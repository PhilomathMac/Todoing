//
//  HomeViewController.swift
//  Todoing
//
//  Created by McKenzie Macdonald on 9/2/22.
//

import UIKit

class HomeViewController: UITableViewController {

    let itemArray = ["Coding", "Interview Questions", "Shopping"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

// MARK: TableView DataSource

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a Cell
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ListNameCell", for: indexPath)
        
        // Setup Cell
        newCell.textLabel?.text = itemArray[indexPath.row]
        
        // Return cell
        return newCell
        
    }
    
}
