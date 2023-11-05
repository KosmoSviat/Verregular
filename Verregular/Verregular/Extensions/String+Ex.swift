//
//  String+Ex.swift
//  Verregular
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
