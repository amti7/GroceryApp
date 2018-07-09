//
//  GroceryItem.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 08.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import Foundation

struct GroceryItem {

    let name: String
    let addedByUser: String
    var completed: Bool
    let key: String
    
    init(name: String, addedByUser: String, completed: Bool, key: String = ""){
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.key = key
    }
    
    
    
}
