//
//  GameScene.swift
//  ZombieConga
//
//  Created by John D Hearn on 10/28/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let background = SKSpriteNode(imageNamed: "background1")
//      background.position = CGPoint(x: size.width/2, y: size.height/2)
//      background.zRotation = CGFloat(M_PI) / 8
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        addChild(background)


    }
}
