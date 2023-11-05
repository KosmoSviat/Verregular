//
//  IrregularVerbs.swift
//  MVC_Lesson
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import Foundation

final class IrregularVerbs {
    // MARK: - Singletone
    static var shared = IrregularVerbs()
    private init() {
        configureVerbs()
    }
    
    // MARK: - Properties
    private(set) var verbs: [Verb] = []
    var selectedVerbs: [Verb] = []
    
    // MARK: - Methods
    private func configureVerbs() {
        verbs = [
            Verb(infinitive: "blow", pastSimple: "blew", participle: "blown"),
            Verb(infinitive: "draw", pastSimple: "drew", participle: "drawn"),
            Verb(infinitive: "eat", pastSimple: "ate", participle: "eaten"),
            Verb(infinitive: "fall", pastSimple: "fell", participle: "fallen"),
            Verb(infinitive: "arise", pastSimple: "arose", participle: "arisen"),
            Verb(infinitive: "awake", pastSimple: "awoke", participle: "awoken"),
            Verb(infinitive: "bear", pastSimple: "bore", participle: "born"),
            Verb(infinitive: "beat", pastSimple: "beat", participle: "beaten"),
            Verb(infinitive: "begin", pastSimple: "began", participle: "begun"),
            Verb(infinitive: "bend", pastSimple: "bent", participle: "bent"),
            Verb(infinitive: "bind", pastSimple: "bound", participle: "bound"),
            Verb(infinitive: "break", pastSimple: "broke", participle: "broken")
        ]
        verbs.forEach{ selectedVerbs.append($0) }
    }
}
