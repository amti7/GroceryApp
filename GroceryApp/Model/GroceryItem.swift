//
//  GroceryItem.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 08.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct GroceryItem {

    let ref: DatabaseReference?
    let name: String
    let addedByUser: String
    var completed: Bool
    let key: String
    
    init(name: String, addedByUser: String, completed: Bool, key: String = ""){
        self.ref = nil
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.key = key
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let completed = value["completed"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
    }
    
    func toAnyObject() -> Any{
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed
        ]
    }
}
