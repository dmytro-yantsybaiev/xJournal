//
//  UITableView+Extensions.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

extension UITableView {

    func register<T: TypeIdentifiable>(_ cell: T.Type) where T: UITableViewCell {
        register(cell.nib, forCellReuseIdentifier: cell.nibName)
    }

    func register<T: TypeIdentifiable>(_ headerFooterView: T.Type) where T: UIView {
        register(headerFooterView.nib, forHeaderFooterViewReuseIdentifier: headerFooterView.nibName)
    }

    func dequeueReusableCell<T: TypeIdentifiable>(at indexPath: IndexPath) -> T? where T: UITableViewCell {
        dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T
    }

    func dequeueReusableHeaderFooterView<T: TypeIdentifiable>() -> T? where T: UIView {
        dequeueReusableHeaderFooterView(withIdentifier: T.nibName) as? T
    }
}
