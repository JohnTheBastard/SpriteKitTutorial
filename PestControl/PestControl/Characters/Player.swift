//
//  Player.swift
//  PestControl
//
//  Created by John D Hearn on 10/31/16.
//  Copyright © 2016 Bastardized Productions LLC. All rights reserved.
//

import SpriteKit

enum PlayerSettings {
    static let playerSpeed: CGFloat = 280.0
}

class Player: SKSpriteNode {
    var animations: [SKAction] = []

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }

    init() {
        let texture = SKTexture(pixelImageNamed: "player_ft1")
        super.init(texture: texture, color: .white,
                   size: texture.size())
        name = "Player"
        zPosition = 50

        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0.5
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.Player
        physicsBody?.contactTestBitMask = PhysicsCategory.All
      
        createAnimations(character: "player")
    }

    func move(target: CGPoint) {
        guard let physicsBody = physicsBody else { return }

        let newVelocity = (target - position).normalized() * PlayerSettings.playerSpeed
        physicsBody.velocity = CGVector(point: newVelocity)
        checkDirection()
    }


    func checkDirection() {
        guard let physicsBody = physicsBody else { return }

        let direction = animationDirection(for: physicsBody.velocity)

        if direction == .left {
            xScale = abs(xScale)
        }
        if direction == .right {
            xScale = -abs(xScale)
        }
        run(animations[direction.rawValue], withKey: "animation")
    }
}

extension Player : Animatable {}
