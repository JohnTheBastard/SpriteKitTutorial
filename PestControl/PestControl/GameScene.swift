/**

 */

import SpriteKit

class GameScene: SKScene {
    var background: SKTileMapNode!
    var obstaclesTileMap: SKTileMapNode?
    var bugsprayTileMap: SKTileMapNode?
    var player = Player()

    var bugsNode = SKNode()
    var firebugCount:Int = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        background = childNode(withName: "background") as! SKTileMapNode
        obstaclesTileMap = childNode(withName: "obstacles") as? SKTileMapNode
    }

    override func didMove(to view: SKView) {
        //bug.position = CGPoint(x: 60, y: 0)
        //addChild(bug)
        addChild(player)
        setupCamera()
        setupWorldPhysics()
        createBugs()
        setupObstaclePhysics()
        if firebugCount > 0 {
            createBugspray(quantity: firebugCount+10)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        player.move(target: touch.location(in: self))

    }

    override func update(_ currentTime: TimeInterval) {
        if !player.hasBugspray {
            updateBugspray()
        }
        advanceBreakableTile(locatedAt: player.position)
    }

    func setupCamera() {
        guard let camera = camera, let view = view else { return }

        let zeroDistance = SKRange(constantValue: 0)
        let playerContstraint = SKConstraint.distance(zeroDistance, to: player)
        let xInset = min(view.bounds.width/2 * camera.xScale, background.frame.width/2)
        let yInset = min(view.bounds.height/2 * camera.yScale, background.frame.height/2)
        let constraintRect = background.frame.insetBy(dx: xInset, dy: yInset)
        let xRange = SKRange(lowerLimit: constraintRect.minX,
                             upperLimit: constraintRect.maxX)
        let yRange = SKRange(lowerLimit: constraintRect.minY,
                             upperLimit: constraintRect.maxY)
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = background
        camera.constraints = [playerContstraint, edgeConstraint]
    }

    func setupWorldPhysics() {
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
        background.physicsBody?.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.contactDelegate = self
    }

    func tile(in tileMap: SKTileMapNode,
              at coordinates: TileCoordinates) -> SKTileDefinition? {
        return tileMap.tileDefinition(atColumn: coordinates.column,
                                      row: coordinates.row)
    }

    func tileCoordinates(in tileMap: SKTileMapNode,
                         at position: CGPoint) -> TileCoordinates {
        let column = tileMap.tileColumnIndex(fromPosition: position)
        let row = tileMap.tileRowIndex(fromPosition: position)
        return (column, row)
    }

    func createBugs() {
        guard let bugsMap = childNode(withName: "bugs") as? SKTileMapNode
            else { return }
        for row in 0..<bugsMap.numberOfRows {
            for column in 0..<bugsMap.numberOfColumns {
              guard let tile = tile(in: bugsMap, at: (column, row) )
                    else { continue }

                //let bug = Bug()
                let bug: Bug
                if tile.userData?.object(forKey: "firebug") != nil {
                  bug = Firebug()
                  firebugCount += 1
                } else {
                  bug = Bug()
                }
                bug.position = bugsMap.centerOfTile(atColumn: column, row: row)
                bugsNode.addChild(bug)
                bug.move()
            }
        }
        bugsNode.name = "Bugs"
        addChild(bugsNode)
        bugsMap.removeFromParent()
    }

    func createBugspray(quantity: Int) {
        let tile = SKTileDefinition(texture:SKTexture(pixelImageNamed: "bugspray"))
        let tilerule = SKTileGroupRule(adjacency:SKTileAdjacencyMask.adjacencyAll, tileDefinitions: [tile])
        let tilegroup = SKTileGroup(rules: [tilerule])
        let tileSet = SKTileSet(tileGroups: [tilegroup])


        let columns = background.numberOfColumns
        let rows = background.numberOfRows
        bugsprayTileMap = SKTileMapNode(tileSet: tileSet,
                                        columns: columns,
                                           rows: rows,
                                       tileSize: tile.size)
        for _ in 1...quantity {
            let column = Int.random(min: 0, max: columns-1)
            let row = Int.random(min: 0, max: rows-1)
            bugsprayTileMap?.setTileGroup(tilegroup,
                                          forColumn: column,
                                                row: row)
        }

        bugsprayTileMap?.name = "Bugspray"
        addChild(bugsprayTileMap!)
    }

    func updateBugspray() {
        guard let bugsprayTileMap = bugsprayTileMap else { return }
        let (column, row) = tileCoordinates(in: bugsprayTileMap,
                                            at: player.position)
        if tile(in: bugsprayTileMap, at: (column, row)) != nil {
            bugsprayTileMap.setTileGroup(nil, forColumn: column, row: row)
            player.hasBugspray = true
        }
    }

    func setupObstaclePhysics() {
        guard let obstaclesTileMap = obstaclesTileMap else { return }

        for row in 0..<obstaclesTileMap.numberOfRows {
            for column in 0..<obstaclesTileMap.numberOfColumns {
                guard let tile = tile(in: obstaclesTileMap,
                                      at: (column, row))
                    else { continue }
                guard tile.userData?.object(forKey: "obstacle") != nil
                    else { continue }

                let node = SKNode()
                node.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
                node.physicsBody?.isDynamic = false
                node.physicsBody?.friction = 0
                node.physicsBody?.categoryBitMask = PhysicsCategory.Breakable
                node.position = obstaclesTileMap.centerOfTile(atColumn: column,
                                                              row: row)
                obstaclesTileMap.addChild(node)
            }
        }
    }


//    func setupObstaclePhysics(){
//        guard let obstaclesTileMap = obstaclesTileMap else { return }
//        var physicsBodies = [SKPhysicsBody]()
//
//        for row in 0..<obstaclesTileMap.numberOfRows {
//            for column in 0..<obstaclesTileMap.numberOfColumns {
//                guard let tile = tile(in: obstaclesTileMap, at: (column, row) )
//                    else { continue }
//                let center = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
//                let body = SKPhysicsBody(rectangleOf: tile.size, center: center)
//                physicsBodies.append(body)
//            }
//        }
//        obstaclesTileMap.physicsBody = SKPhysicsBody(bodies: physicsBodies)
//        obstaclesTileMap.physicsBody?.isDynamic = false
//        obstaclesTileMap.physicsBody?.friction = 0
//
//    }

    func tileGroupForName(tileSet: SKTileSet, name: String) -> SKTileGroup? {
        let tileGroup = tileSet.tileGroups.filter{ $0.name == name }.first
        return tileGroup
    }

    func advanceBreakableTile(locatedAt nodePosition: CGPoint) {
        guard let obstaclesTileMap = obstaclesTileMap else { return }
        let (column, row) = tileCoordinates(in: obstaclesTileMap,
                                            at: nodePosition)
        let obstacle = tile(in: obstaclesTileMap,
                            at: (column, row) )
        guard let nextTileGroupName =
            obstacle?.userData?.object(forKey: "breakable") as? String
        else { return }

        if let nextTileGroup = tileGroupForName(tileSet: obstaclesTileMap.tileSet,
                                                name: nextTileGroupName) {
            obstaclesTileMap.setTileGroup(nextTileGroup,
                                          forColumn: column, row: row)
        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    func remove(bug: Bug) {
        bug.removeFromParent()
        background.addChild(bug)
        bug.die()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if let physicsBody = player.physicsBody {
            if physicsBody.velocity.length() > 0 {
                player.checkDirection()
            }
        }

        let other = contact.bodyA.categoryBitMask ==
                    PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
            case PhysicsCategory.Bug:
                if let bug = other.node as? Bug {
                    remove(bug: bug)
                }
            case PhysicsCategory.Firebug:
                if player.hasBugspray {
                    if let firebug = other.node as? Firebug {
                        remove(bug: firebug)
                        player.hasBugspray = false
                    }
                }
            case PhysicsCategory.Breakable:
                if let obstacleNode = other.node {
                    advanceBreakableTile(locatedAt: obstacleNode.position)
                    obstacleNode.removeFromParent()
                }
            default:
                break
        }
    }
}


