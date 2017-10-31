//
//  CollisionCategory.swift
//  ThrowableCabbage
//
//  Created by Mpalka on 30.10.2017.
//  Copyright © 2017 McPusz. All rights reserved.
//

import Foundation

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let world = CollisionCategory(rawValue: 1 << 0) //0000 0001
    static let cabbage = CollisionCategory(rawValue: 1 << 1) //0000 0010
    
}
