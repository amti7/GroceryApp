//
//  GroceryListTableViewController.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 07.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class GroceryTableViewController: UITableViewController {
    
    let ref = Database.database().reference(withPath: "grocery-items")
    var items: [GroceryItem] = []
    var user: User!
    let usersRef = Database.database().reference(withPath: "online")
    
    override func viewDidLoad() {
        observeDataFromFirebase()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(uid: user.uid, email: user.email!)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)
        let groceryArray = items[indexPath.row]
        cell.textLabel?.text = groceryArray.name
        cell.detailTextLabel?.text = groceryArray.addedByUser
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let groceryItem = items[indexPath.row]
        let toggledCompletition = !groceryItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletition)
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletition
            ])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Grocery Item", message: "Add Item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            
            let groceryItem = GroceryItem(name: textField.text!, addedByUser: self.user.email, completed: false)
            let groceryItemRef = self.ref.child(text.lowercased())
            groceryItemRef.setValue(groceryItem.toAnyObject())
            self.items.append(groceryItem)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func observeDataFromFirebase(){
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [GroceryItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let groceryItem = GroceryItem(snapshot: snapshot) {
                    newItems.append(groceryItem)
                }
            }
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool){
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
            
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .gray
        }
    }
    
    @IBAction func didSignOut(_ sender: Any) {
        signOutUser()
    }
    
    func signOutUser(){
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        onlineRef.removeValue() { (error, _) in
            if let error = error {
                print("Removing online failed \(error)")
                return
            }
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
}
