//
//  User.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/22/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct User {
    var firstName: String
    var lastName: String
    
    // array of references to rides
    
    var attendingRides: [CKReference]
    
    var photoData: Data?
    
    var cloudKitRecordID: CKRecordID?
    var appleUserReference: CKReference
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    var temporaryPhotoURL: URL {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    init(firstName: String, lastName: String, appleUserRef: CKReference, photoData: Data?, attendingRides: [CKReference]) {
        self.firstName = firstName
        self.lastName = lastName
        self.photoData = photoData
        self.appleUserReference = appleUserRef
        self.attendingRides = attendingRides
    }
}

// MARK: - CloudKit init section

extension User {
    
    init?(cloudKitRecord: CKRecord) {
        
        guard let firstName = cloudKitRecord[UserKeys.firstNameKey] as? String,
            let lastName = cloudKitRecord[UserKeys.lastNameKey] as? String,
            let asset = cloudKitRecord[UserKeys.assetKey] as? CKAsset,
            let appleUserRef = cloudKitRecord[UserKeys.appleUserRefKey] as? CKReference else { return nil }
        
        let photoData = try? Data(contentsOf: asset.fileURL)
        
        self.firstName = firstName
        self.lastName = lastName
        self.photoData = photoData
        self.appleUserReference = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
        self.attendingRides = cloudKitRecord[UserKeys.attendingRidesKey] as? [CKReference] ?? []
    }
}

//MARK: - create a CKRecord from a User

extension CKRecord {
    
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: UserKeys.recordTypeKey, recordID: recordID)
        
        let asset = CKAsset(fileURL: user.temporaryPhotoURL)
        
        self.setValue(user.firstName, forKey: UserKeys.firstNameKey)
        self.setValue(user.lastName, forKey: UserKeys.lastNameKey)
        self.setValue(asset, forKey: UserKeys.assetKey)
        self.setValue(user.appleUserReference, forKey: UserKeys.appleUserRefKey)
        
        if user.attendingRides.count > 0 {
            self.setValue(user.attendingRides, forKey: UserKeys.attendingRidesKey)

        }
    }
}



































