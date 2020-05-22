//
//  Picture.swift
//  Project1
//
//  Created by Manuel Teixeira on 22/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import Foundation

struct Picture: Codable, Comparable {
    let name: String
    var shownCount: Int
    
    static func < (lhs: Picture, rhs: Picture) -> Bool {
        lhs.name < rhs.name
    }
}
