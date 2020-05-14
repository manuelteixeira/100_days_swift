//
//  Petition.swift
//  Project7
//
//  Created by Manuel Teixeira on 08/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
