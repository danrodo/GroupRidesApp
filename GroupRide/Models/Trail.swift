//
//  Trail.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/4/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

struct Trail {
    
    let trailId: Double
    let name: String
    let type: String
    let summary: String
    let difficulty: String
    let stars: Double
    let starVotes: Double
    let location: String
    let url: String
    let imageMedium: String
    let length: Double
    let ascent: Double
    let descent: Double
    let high: Double
    let low: Double
    let longitude: Double
    let latitude: Double
    let conditionStatus: String
    let conditionDetails: String
    let conditionDate: String
    
    
    init?(dictionary: [String: Any]) {
        
        guard let trailId = dictionary[TrailKeys.idKey] as? Double,
            let name = dictionary[TrailKeys.nameKey] as? String,
            let type = dictionary[TrailKeys.typeKey] as? String,
            let summary = dictionary[TrailKeys.summaryKey] as? String,
            let difficulty = dictionary[TrailKeys.difficultyKey] as? String,
            let stars = dictionary[TrailKeys.starsKey] as? Double,
            let starVotes = dictionary[TrailKeys.starVotesKey] as? Double,
            let location = dictionary[TrailKeys.locationKey] as? String,
            let url = dictionary[TrailKeys.urlKey] as? String,
            let imageMedium = dictionary[TrailKeys.imageMediumKey] as? String,
            let length = dictionary[TrailKeys.lengthKey] as? Double,
            let ascent = dictionary[TrailKeys.ascentKey] as? Double,
            let descent = dictionary[TrailKeys.descentKey] as? Double,
            let high = dictionary[TrailKeys.highKey] as? Double,
            let low = dictionary[TrailKeys.lowKey] as? Double,
            let longitude = dictionary[TrailKeys.longitudeKey] as? Double,
            let latitude = dictionary[TrailKeys.latitudeKey] as? Double,
            let conditionStatus = dictionary[TrailKeys.conditionStatusKey] as? String,
            let conditionDetails = dictionary[TrailKeys.conditionDetailsKey] as? String,
            let conditionDate = dictionary[TrailKeys.conditionDateKey] as? String
            else {
                return nil
        }
        
        self.trailId = trailId
        self.name = name
        self.type = type
        self.summary = summary
        self.difficulty = difficulty
        self.stars = stars
        self.starVotes = starVotes
        self.location = location
        self.url = url
        self.imageMedium = imageMedium
        self.length = length
        self.ascent = ascent
        self.descent = descent
        self.high = high
        self.low = low
        self.longitude = longitude
        self.latitude = latitude
        self.conditionStatus = conditionStatus
        self.conditionDetails = conditionDetails
        self.conditionDate = conditionDate
        
    }
    
    
}
