//
//  ScheduledRideController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/11/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import UserNotifications

protocol AlarmScheduler: class {
    
    func scheduleUserNotifications(for alarm: ScheduledRide)
    func cancelLocalNotifications(for alarm: ScheduledRide)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: ScheduledRide) {
        
        let content = UNMutableNotificationContent()
        content.title = "\(alarm.name)"
        content.body = "times up"
        content.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else {
            return
        }
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: dateTrigger)
        
        //print(fireDate.description)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("not able to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    
    func cancelLocalNotifications(for alarm: ScheduledRide) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        
    }
    
}

class ScheduledRideController {
    
    static let shared = ScheduledRideController()
    
    var alarms: [ScheduledRide] = []
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
    init() {
        //self.alarms = self.mockAlarms
        loadFromPersistentStorage()
    }
    
    //    var mockAlarms: [Alarm] {
    //        let alarm1 = Alarm(fireTimeFromMidnight: 0.0, name: "Wake Up")
    //        let alarm2 = Alarm(fireTimeFromMidnight: 10.0, name: "eat breakfast")
    //        let alarm3 = Alarm(fireTimeFromMidnight: 100.0, name: "go back to bed")
    //        return [alarm1, alarm2, alarm3]
    //    }
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> ScheduledRide {
        
        let newAlarm = ScheduledRide(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        saveToPersistentStorage()
        return newAlarm
    }
    
    func update(alarm: ScheduledRide, fireTimeFromMidnight: TimeInterval, name: String) {
        
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: ScheduledRide) {
        
        if alarm.enabled == true {
            alarm.enabled = false
        } else {
            alarm.enabled = true
        }
        saveToPersistentStorage()
        
    }
    
    func delete(alarm: ScheduledRide) {
        
        guard let index = alarms.index(of: alarm) else { return }
        saveToPersistentStorage()
        alarms.remove(at: index)
        
    }
    
    private func saveToPersistentStorage() {
        
        guard let path = ScheduledRideController.persistentAlarmsFilePath else {return}
        
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: path)
        
    }
    
    private func loadFromPersistentStorage() {
        
        guard let path = ScheduledRideController.persistentAlarmsFilePath else {return}
        
        guard let alarmsFromStorage = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [ScheduledRide] else {return}
        
        self.alarms = alarmsFromStorage
        
    }
}





































