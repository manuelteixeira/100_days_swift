//
//  Utils.swift
//  Projects 10-12
//
//  Created by Manuel Teixeira on 25/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import Foundation

struct Utils {
    static func getDocumentsPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        
        return paths[0]
    }
}
