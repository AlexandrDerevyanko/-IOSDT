//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 13.05.2023.
//

import Foundation
import UserNotifications

class LocalNotificationsService {
    
    static let defaultService = LocalNotificationsService()
    
    func registerForLatestUpdatesIfPossible() {
        
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, error in
                if granted {
                    self.register()
                }
                else {
                    print("Доступ не получен")
                }
            }
    }
    
    func register() {
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Уведомление"
        content.body = "Посмотрите последние обновления"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["CustomData": "qwerty"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
}
