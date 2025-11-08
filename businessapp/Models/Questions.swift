//
//  Questions.swift
//  BlueprintTest
//
//  Created by Євген Жадан on 06.11.2025.
//

import Foundation

struct Question: Identifiable {
    let id = UUID().uuidString
    let query: String
    let answerImage: [String]
    let answerText: [String]
    let answerSubText: [String]
}

