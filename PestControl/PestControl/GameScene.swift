/**

 */

import SpriteKit

class GameScene: SKScene {
    var background: SKTileMapNode!
    var obstaclesTileMap: SKTileMapNode?
    var player = Player()
    //var bug = Bug()
    var bugsNode = SKNode()

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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        player.move(target: touch.location(in: self))

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

    func createBugs() {
        guard let bugsMap = childNode(withName: "bugs") as? SKTileMapNode
            else { return }
        for row in 0..<bugsMap.numberOfRows {
            for column in 0..<bugsMap.numberOfColumns {
              guard let tile = tile(in: bugsMap, at: (column, row) )
                    else { continue }

                let bug = Bug()
                bug.position = bugsMap.centerOfTile(atColumn: column, row: row)
                bugsNode.addChild(bug)
                bug.move()
            }
        }
        bugsNode.name = "Bugs"
        addChild(bugsNode)
        bugsMap.removeFromParent()
    }


    func setupObstaclePhysics(){
        guard let obstaclesTileMap = obstaclesTileMap else { return }
        var physicsBodies = [SKPhysicsBody]()

        for row in 0..<obstaclesTileMap.numberOfRows {
            for column in 0..<obstaclesTileMap.numberOfColumns {
                guard let tile = tile(in: obstaclesTileMap, at: (column, row) )
                    else { continue }
                let center = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
                let body = SKPhysicsBody(rectangleOf: tile.size, center: center)
                physicsBodies.append(body)
            }
        }
        obstaclesTileMap.physicsBody = SKPhysicsBody(bodies: physicsBodies)
        obstaclesTileMap.physicsBody?.isDynamic = false
        obstaclesTileMap.physicsBody?.friction = 0

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
          default:
              break
        }
    }
}


