//
//  LocalNotifScheduler.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/13/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotifScheduler {
    
    static let shared = LocalNotifScheduler()
    
    func scheduleNotification(event: RideEvent) {
        
        guard let identifier = event.cloudKitRecordID?.recordName else { return }
        let newDate = event.date.addingTimeInterval(-3600)
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: newDate)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: components.second)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Yo dawg!"
        content.body = "Don't forget you gotta go ride bikes in an hour."
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                NSLog("Error scheduling this notification, \(error.localizedDescription)")
            }
        }
    }
    
    func cancelLocalNotifications(for event: RideEvent) {
        
        guard let identifier = event.cloudKitRecordID?.recordName else { return }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
    }
    
}
