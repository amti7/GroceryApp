//
//  GroceryListTableViewController.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 07.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import Foundation
import UIKit

class GroceryTableViewController: UITableViewController {
    
    var items: [GroceryItem] = []
    var user = User(uuid: 2938479, email: "user@looser.com")
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)
        let groceryArray = items[indexPath.row]
        print("\(groceryArray.name) |  \(groceryArray.addedByUser)")
        cell.textLabel?.text = groceryArray.name
        cell.detailTextLabel?.text = groceryArray.addedByUser
        return cell
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Grocery Item", message: "Add Item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let textField = alert.textFields![0]
            let groceryItem = GroceryItem(name: textField.text!, addedByUser: self.user.email, completed: false)
            self.items.append(groceryItem)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
