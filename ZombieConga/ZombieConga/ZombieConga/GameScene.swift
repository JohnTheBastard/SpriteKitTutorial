//
//  GameScene.swift
//  ZombieConga
//
//  Created by John D Hearn on 10/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    let zombieRotateRadiansPerSec:CGFloat = 4.0 * π
    var lastTouchLocation: CGPoint?
    var velocity = CGPoint.zero
    let playableRect: CGRect

    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let background = SKSpriteNode(imageNamed: "background1")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        addChild(background)

        zombie.position = CGPoint(x: 400, y: 400)
        addChild(zombie)
        debugDrawPlayableArea()
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0{
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000) milliseconds since last update")

        if let lastTouchLocation = lastTouchLocation {
            let diff = lastTouchLocation - zombie.position
            if diff.length() <= zombieMovePointsPerSec * CGFloat(dt) {
                zombie.position = lastTouchLocation
                velocity = CGPoint.zero
            } else {
                move(sprite: zombie, velocity: velocity)
                rotate(sprite: zombie, direction: velocity,
                       rotateRadiansPerSec: zombieRotateRadiansPerSec)
            }
        }
        
        boundsCheckZombie()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        sceneTouched(touchLocation: touchLocation)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        sceneTouched(touchLocation: touchLocation)
    }

    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        print("Amount to move: \(amountToMove)")
        sprite.position += amountToMove
    }

    func moveZombieToward(location: CGPoint) {
        let offset = location - zombie.position
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSec
    }

    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(location: touchLocation)
    }

    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }

    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }

    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
}




