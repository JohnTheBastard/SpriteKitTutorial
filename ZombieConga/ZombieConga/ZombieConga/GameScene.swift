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


    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        let background = SKSpriteNode(imageNamed: "background1")
//      background.position = CGPoint(x: size.width/2, y: size.height/2)
//      background.zRotation = CGFloat(M_PI) / 8
//      print("\n\n\n\nSize of background: \(background.size)\n\n\n\n")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -1
        addChild(background)

        zombie.position = CGPoint(x: 400, y: 400)
        zombie.scale(to: CGSize(width: 2*zombie.size.width,
                                height: 2*zombie.size.height) )
        addChild(zombie)
    }
}
