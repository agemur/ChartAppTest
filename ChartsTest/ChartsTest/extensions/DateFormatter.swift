//
//  DateFormatter.swift
//  ChartsTest
//
//  Created by User on 11/26/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


extension DateFormatter {
    static var chartDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        formatter.dateFormat = "dd.MM"
        return formatter
    }
}
