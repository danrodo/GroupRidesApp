//
//  TrailController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/4/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

class TrailController {
    
    static let shared = TrailController()
    
    func fetchTrails(longitude: Double, latitude: Double, maxDistance: Double, completion: @escaping (_ success: Bool, _ trails: [Trail]?) -> Void) {
        
        let apiKey = TrailKeys.apiKey
        let baseUrl = URL(string: TrailKeys.baseUrl)!
        
        var queryItems: [URLQueryItem] = []
        
        let apiKeyItem = URLQueryItem(name: "key", value: apiKey)
        let longitudeItem = URLQueryItem(name: "lon", value: "\(longitude)")
        let latitudeItem = URLQueryItem(name: "lat", value: "\(latitude)")
        let maxDistanceItem = URLQueryItem(name: "maxDistance", value: "\(maxDistance)")
        
        queryItems.append(latitudeItem)
        queryItems.append(longitudeItem)
        queryItems.append(maxDistanceItem)
        queryItems.append(apiKeyItem)
        
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        
        components?.queryItems = queryItems
        
        guard let searchUrl = components?.url else { return }
        
        URLSession.shared.dataTask(with: searchUrl) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching trail information \(error.localizedDescription)")
                completion(false, nil )
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching trail information, no Data")
                return completion(false, nil)
            }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                let trailsArray = jsonDictionary["trails"] as? [[String: Any]] else {
                    NSLog("Error fetching trail information, cannot unwrap json")
                    return completion(false, nil)
            }
            
            let trails = trailsArray.flatMap { Trail(dictionary: $0) }
            completion(true, trails)
            return
        }.resume()
    }
}













