//
//  GameScene.swift
//  SpriteKitTutorial
//
//  Created by John D Hearn on 10/20/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
    }
}
