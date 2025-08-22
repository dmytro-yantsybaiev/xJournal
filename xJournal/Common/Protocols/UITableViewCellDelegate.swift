//
//  UITableViewCellDelegate.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 22.08.2025.
//

import UIKit

@MainActor
protocol UITableViewCellDelegate: AnyObject {
    func contentDidChange(cell: UITableViewCell)
}
