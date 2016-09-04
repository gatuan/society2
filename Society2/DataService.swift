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
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
}
