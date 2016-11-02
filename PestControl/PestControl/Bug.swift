//
//  Bug.swift
//  PestControl
//
//  Created by John D Hearn on 11/1/16.
//  Copyright © 2016 Bastardized Productions LLC. All rights reserved.
//

import SpriteKit

class Bug: SKSpriteNode {
  var animations: [SKAction] = []

  required init?(coder aDecoder: NSCoder) {
    fatalError("Use init()")
  }

  init() {
    let texture = SKTexture(pixelImageNamed: "bug_ft1")
    super.init(texture: texture, color: .white,
               size: texture.size())
    name = "Bug"
    zPosition = 40

    physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
    physicsBody?.restitution = 0.5
    physicsBody?.linearDamping = 0.5
    physicsBody?.friction = 0
    physicsBody?.allowsRotation = false

    //createAnimations(character: "bug")
  }
}

extension Bug : Animatable {}
