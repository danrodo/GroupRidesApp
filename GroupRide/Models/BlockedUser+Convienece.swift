//
//  BlockedUser+Convienece.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData

extension BlockedUser {
    
    
    convenience init(userRecordIDString: String, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.userRecordIDString = userRecordIDString
        
    }
    
}
