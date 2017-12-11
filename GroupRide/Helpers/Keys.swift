//
//  Keys.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/22/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation


struct UserKeys {
    
    // User keys
    
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let photoDataKey = "photoData"
    static let appleUserRefKey = "appleUserReference"
    static let recordTypeKey = "User"
    static let assetKey = "asset"
    static let attendingRidesKey = "attendingRides"
    static let recordIDStringKey = "recordIDString"
    
    // MARK: - Notification
    
    static let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    static let attendingUsersWereSetNotification = Notification.Name("attendingUsersWereSet")
    
}

struct RideEventKeys {
    
    // Ride keys
    
    static let locationKey = "location"
    static let dateKey = "date"
    static let descriptionKey = "description"
    static let recordTypeKey = "RideEvent"
    static let userRefKey = "userRef"
    
    // MARK: - Notification
    
    static let rideEventFeedWasSetNotification = Notification.Name("rideEventFeedWasSet")
    
}

struct TrailKeys {
    
    static let apiKey = "200172211-9a083ff77555a96ca67e3ceed205300c"
    static let baseUrl = "https://www.mtbproject.com/data/get-trails"
    
    static let idKey = "id"
    static let nameKey = "name"
    static let typeKey = "type"
    static let summaryKey = "summary"
    static let difficultyKey = "difficulty"
    static let starsKey = "stars"
    static let starVotesKey = "starVotes"
    static let locationKey = "location"
    static let urlKey = "url"
    static let imageMediumKey = "imgMedium"
    static let lengthKey = "length"
    static let ascentKey = "ascent"
    static let descentKey = "descent"
    static let highKey = "high"
    static let lowKey = "low"
    static let longitudeKey = "longitude"
    static let latitudeKey = "latitude"
    static let conditionStatusKey = "conditionStatus"
    static let conditionDetailsKey = "conditionDetails"
    static let conditionDateKey = "conditionDate"
    
}
