//
//  Bug.swift
//  PestControl
//
//  Created by John D Hearn on 11/1/16.
//  Copyright © 2016 Bastardized Productions LLC. All rights reserved.
//

import SpriteKit

enum BugSettings {
    static let bugDistance: CGFloat = 16
}

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
        physicsBody?.categoryBitMask = PhysicsCategory.Bug

        createAnimations(character: "bug")
    }

    func move() {
        let randomX = CGFloat(Int.random(min: -1, max: 1))
        let randomY = CGFloat(Int.random(min: -1, max: 1))
        let vector = CGVector(dx: randomX * BugSettings.bugDistance,
                              dy: randomY * BugSettings.bugDistance)
        let moveBy = SKAction.move(by: vector, duration: 1)
        let moveAgain = SKAction.run(move)

        let direction = animationDirection(for: vector)

        if direction == .left {
            xScale = abs(xScale)
        } else if direction == .right {
            xScale = -abs(xScale)
        }

        run(animations[direction.rawValue], withKey: "animation")
        run(SKAction.sequence([moveBy, moveAgain]))
    }

    func die() {
        removeAllActions()
      texture = SKTexture(pixelImageNamed: "bug_lt1")
      yScale = -1
      physicsBody = nil
      run(SKAction.sequence([ SKAction.fadeOut(withDuration: 3),
                              SKAction.run(removeFromParent)     ]))
    }
}

extension Bug : Animatable {}
