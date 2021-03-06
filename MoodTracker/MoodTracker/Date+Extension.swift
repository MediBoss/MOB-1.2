//
//  Date+Extension.swift
//  MoodTracker
//
//  Created by Medi Assumani on 12/5/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import Foundation


extension Date {
    var stringValue: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}
