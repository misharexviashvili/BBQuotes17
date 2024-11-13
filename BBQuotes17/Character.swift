//
//  Character.swift
//  BBQuotes17
//
//  Created by Misho's Mac on 13.11.24.
//

import Foundation

struct Character : Decodable {
    let name : String
    let birthday : String
    let occupations : [String]
    let images : [URL]
    let aliases : [String]
    let status : String
    let portrayedBy : String
}
