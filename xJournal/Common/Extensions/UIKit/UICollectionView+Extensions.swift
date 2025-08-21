//
//  UICollectionView+Extensions.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

extension UICollectionView {

    func register<T: TypeIdentifiable>(_ cell: T.Type) where T: UICollectionViewCell {
        register(cell.nib, forCellWithReuseIdentifier: cell.nibName)
    }

    func register<T: TypeIdentifiable>(_ view: T.Type, _ kind: String) where T: UICollectionReusableView {
        register(view.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: view.nibName)
    }

    func dequeueReusableCell<T: TypeIdentifiable>(at indexPath: IndexPath) -> T? where T: UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T
    }

    func dequeueReusableSupplementaryView<T: TypeIdentifiable>(indexPath: IndexPath, kind: String) -> T? where T: UICollectionReusableView {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.nibName, for: indexPath) as? T
    }
}
