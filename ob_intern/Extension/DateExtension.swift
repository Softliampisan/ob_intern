//
//  Date+Extension.swift
//
//
//  Created by Pakkapon on 26/6/23.
//

import Foundation

extension Date {
    
    func thaiFullDateTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th_TH")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "dd MMMM yyyy HH:mm น."
        return formatter.string(from: self)
    }
    
    func convertDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: self)
    }
    
    func thaiTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        let local = Locale(identifier: "TH")
        dateFormatter.locale = local
        dateFormatter.dateFormat = "HH:mm น."
        
        return dateFormatter.string(from: self)
    }
    
    public var timeAgo: String {
        var components = self.dateComponents()
        components.timeZone = TimeZone.current
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let week = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
        if day >= 2 || week > 0 || month > 0 || year > 0 {
            return self.thaiFullDateTimeFormat()
        } else if day >= 1 {
            return "\("เมื่อวาน") \("เวลา") \(self.thaiTimeFormat())"
        } else if hour >= 2 {
            return "\(hour) \("ชั่วโมงที่แล้ว")"
        } else if hour >= 1 {
            return "ชั่วโมงที่แล้ว"
        } else if minute >= 2 {
            return "\(minute) \("นาทีที่แล้ว")"
        } else if minute >= 1 {
            return "นาทีที่แล้ว"
        } else {
            return "เมื่อสักครู่"
        }
    }
    
    func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return (calander as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: self, to: Date(), options: [])
    }
    
}

