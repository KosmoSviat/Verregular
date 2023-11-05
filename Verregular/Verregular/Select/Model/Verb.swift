//
//  Verb.swift
//  MVC_Lesson
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import Foundation

struct Verb {
    let infinitive: String
    let pastSimple: String
    let participle: String
    var translation: String {
        NSLocalizedString(self.infinitive, comment: "")
    }
}
