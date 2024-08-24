//
//  Petition.swift
//  petition
//
//  Created by Sanam Gurung on 8/24/24.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
