//
//  DataService.swift
//  Society2
//
//  Created by George Atuan on 9/4/16.
//  Copyright © 2016 George Atuan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = FIRDatabase.database().referenceFromURL("https://society2-fb414.firebaseio.com/")
    private var _REF_POSTS = FIRDatabase.database().referenceFromURL("https://society2-fb414.firebaseio.com/posts")
    private var _REF_USERS = FIRDatabase.database().referenceFromURL("https://society2-fb414.firebaseio.com/users")


    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = REF_BASE.child("users").child(uid)
        return user
    }
    
    func createFirebaseUser(uid:String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}
