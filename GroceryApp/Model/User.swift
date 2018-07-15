//
//  User.swift
//  GroceryApp
//
//  Created by Kamil Gacek on 08.07.2018.
//  Copyright © 2018 Kamil Gacek. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(uid: String, email:String){
        self.uid = uid
        self.email = email
    }
}
