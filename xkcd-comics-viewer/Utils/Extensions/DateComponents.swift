//
//  DateComponents.swift
//  xkcd-comics-viewer
//
//  Created by Saad Qureshi on 19/03/2020.
//  Copyright © 2020 Saad. All rights reserved.
//

import Foundation

// MARK: - DateComponents: to parse the date returned by served to Date object
extension DateComponents {
    static func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }
}
