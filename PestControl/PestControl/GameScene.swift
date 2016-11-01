/**

 */

import SpriteKit

class GameScene: SKScene {
    var background: SKTileMapNode!
    var player = Player()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        background = childNode(withName: "background") as! SKTileMapNode
    }

    override func didMove(to view: SKView) {
        addChild(player)
        setupCamera()
        setupWorldPhysics()
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
    }
}
