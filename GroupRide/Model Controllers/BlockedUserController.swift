//
//  AttendingRidesController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData

class BlockedUserController {
    
    var fetchedResultsController: NSFetchedResultsController<BlockedUser>!
    
    static let shared = BlockedUserController()
    
    init() {
        
        let request: NSFetchRequest<BlockedUser> = BlockedUser.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "userRecordIDString", ascending: true)]
        
        if fetchedResultsController == nil {
            let frc = NSFetchedResultsController<BlockedUser>(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
            //frc.delegate = self
            fetchedResultsController = frc
            
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Error loading from persistent store \(error)")
        }
        
    }
    
    func blockUser(userRecordIDString: String) {
        
        let _ = BlockedUser(userRecordIDString: userRecordIDString, context: CoreDataStack.context)
        
        saveToPersistentStore()
        
    }
    
    func unBlockUser(blockedUser: BlockedUser) {
        
        let moc = blockedUser.managedObjectContext
        moc?.delete(blockedUser)
        
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("Error saving to persistent store \(error)")
        }
    }
    
    func fetchBlockedUsers() -> [BlockedUser] {
        let request: NSFetchRequest<BlockedUser> = BlockedUser.fetchRequest()
        do {
            return try CoreDataStack.context.fetch(request)
        } catch let error {
            print("Error loading from persistent store \(error)")
        }
        return []
    }
}



















