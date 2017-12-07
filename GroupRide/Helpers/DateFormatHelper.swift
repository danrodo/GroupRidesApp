//
//  DateFormatter.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/4/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation


class DateFormatHelper {
    
    static let shared = DateFormatHelper()
    
    let dateFormatterGet = DateFormatter()
    let dateFormatter = DateFormatter()
    
    func formatDate(date: String, completion: @escaping (_ success: Bool, _ date: String?) -> Void) {
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH-mm-ss Z"
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        
        guard let newDate: Date = dateFormatterGet.date(from: date) else { return completion(false, nil) }
        let dateString = dateFormatter.string(from: newDate)

        completion(true, dateString)
        
    }
    
}
