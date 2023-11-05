//
//  UIStackView+Ex.swift
//  Verregular
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
