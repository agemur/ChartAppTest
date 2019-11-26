//
//  EventRepository.swift
//  ChartsTest
//
//  Created by User on 11/25/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


class EventRepository {
    private let countEvent: Int
    var events: [EventModel] = []
    let startDate: Date
    
    init (countDays: Int = 10, startDate: Date = Date()) {
        self.startDate = startDate
        countEvent = countDays
        fillArray(date: startDate)
    }
    
    @discardableResult
    private func fillArray(date: Date) -> Bool {
        events.append(EventModel(date: date, data: Double(arc4random_uniform(20) + 3)))
        guard events.count < countEvent, let nextDay = date.nextDate() else { return true }
        return fillArray(date: nextDay)
    }
    
}

extension Date {
    func nextDate() -> Date? {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return tomorrow
    }
}
