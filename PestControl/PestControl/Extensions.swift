//
//  Extensions.swift
//  PestControl
//
//  Created by John D Hearn on 10/31/16.
//  Copyright © 2016 Bastardized Productions LLC. All rights reserved.
//

import Foundation
import SpriteKit
extension SKTexture {
    convenience init(pixelImageNamed: String) {
        self.init(imageNamed: pixelImageNamed)
        self.filteringMode = .nearest
    }
}
