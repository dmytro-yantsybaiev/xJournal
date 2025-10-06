//
//  JournalEntrySection.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 06.09.2025.
//

import Foundation

enum JournalEntrySection: Hashable {

    case today
    case yesterday
    case month(String)

    var title: String {
        switch self {
        case .today: "Today"
        case .yesterday: "Yesterday"
        case let .month(name): name
        }
    }
}

func groupJournalEntries(_ entries: [JournalEntry]) -> [JournalEntrySection: [JournalEntry]] {
    let calendar = Calendar.current
    let now = Date.now
    let today = calendar.startOfDay(for: now)
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    let currentYear = calendar.component(.year, from: now)

    let monthFormatter = DateFormatter()
    monthFormatter.locale = Locale.current
    monthFormatter.dateFormat = "LLLL"

    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"

    return Dictionary(grouping: entries) { entry in
        let entryDate = entry.timestamp
        let entryDay = calendar.startOfDay(for: entryDate)

        if calendar.isDate(entryDay, inSameDayAs: today) {
            return .today
        }

        if calendar.isDate(entryDay, inSameDayAs: yesterday) {
            return .yesterday
        }

        let entryYear = calendar.component(.year, from: entryDay)
        let monthName = monthFormatter.string(from: entryDay)

        if entryYear == currentYear {
            return .month(monthName)
        } else {
            return .month("\(monthName) \(entryYear)")
        }
    }
}
