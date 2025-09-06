//
//  JournalEntry.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import Foundation
import SwiftData

@Model
final class JournalEntry: MenuIdentifiable {

    @Attribute(.unique) private(set) var id = UUID().uuidString

    private(set) var title: String?
    private(set) var body: String?
    private(set) var isBookmarked: Bool
    private(set) var isTitleHidden: Bool
    private(set) var timestamp = Date.now

    init(
        title: String? = nil,
        body: String? = nil,
        isBookmarked: Bool = false,
        isTitleHidden: Bool = false,
    ) {
        self.title = title
        self.body = body
        self.isBookmarked = isBookmarked
        self.isTitleHidden = isTitleHidden
    }

    func update(title: String?) {
        self.title = title
    }

    func update(body: String?) {
        self.body = body
    }

    func update(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
    }

    func update(isTitleHidden: Bool) {
        self.isTitleHidden = isTitleHidden
    }
}
