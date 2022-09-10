//
//  GameScene.swift
//  First_Game
//
//  Created by ROY ALAMEH on 9/9/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{
    var starfield:SKEmitterNode!
    var explosion:SKEmitterNode!
    var player:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer:Timer!
    var alienCategory:UInt32 = 1
    var torpedoCategory:UInt32 = 2
    /*let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0*/
    
    
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "space")
        starfield.position = CGPoint(x: 0, y: 1024)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
        
        explosion = SKEmitterNode(fileNamed: "explosion")
        //self.addChild(explosion)
        
        player = SKSpriteNode(imageNamed: "rocketShip")
        let factor : CGFloat = 4
        player.size.height = player.size.height / factor
        player.size.width = player.size.width / factor
        player.position = CGPoint(x: self.frame.size.width / 2, y : player.size.height / 2 + 20)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        self.addChild(scoreLabel)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        
        //does not work
        /*gameTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true) */
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.75), SKAction.run(addAlien)])))
        
        /*let animationDuration:TimeInterval = 3
        let animation1:SKAction = SKAction.move(to: CGPoint(x: 768 - player.size.width / 2, y: player.size.height / 2), duration: animationDuration)
        let animation2:SKAction = SKAction.move(to: CGPoint(x: 0 + player.size.width / 2, y: player.size.height / 2), duration: animationDuration)
        
        let actionArray = [animation1, animation2]
        
        player.run(SKAction.repeatForever(SKAction.sequence(actionArray))) */
        
    }
    
    func addAlien() {
        let alien = SKSpriteNode(imageNamed: "rocket2")
        alien.zRotation = Double.pi
        alien.size.width = alien.size.width / 8
        alien.size.height = alien.size.height / 8
        
        let xPosition = CGFloat(GKRandomDistribution(lowestValue: Int(alien.size.width) / 2, highestValue: 768 - Int(alien.size.width / 2)).nextInt())
        alien.position = CGPoint(x: xPosition, y: 1024 + alien.size.height / 2)
        self.addChild(alien)
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: alien.position.x, y: -alien.size.height / 2), duration: 5))
        actions.append(SKAction.run(alien.removeFromParent))
        alien.run(SKAction.sequence(actions))
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = false
        alien.physicsBody?.affectedByGravity = false
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = torpedoCategory
        alien.physicsBody?.collisionBitMask = 0
    }
    
    func fireTorpedo() {
        let torpedo = SKShapeNode(circleOfRadius: 5)
        torpedo.fillColor = UIColor.green
        torpedo.position = CGPoint(x: player.position.x, y: player.position.y)
        let finalPosition = CGPoint(x: torpedo.position.x, y: 1300)
        torpedo.run(SKAction.move(to: finalPosition, duration: 1.25))
        self.addChild(torpedo)
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        torpedo.physicsBody?.categoryBitMask = torpedoCategory
        torpedo.physicsBody?.contactTestBitMask = alienCategory
        torpedo.physicsBody?.collisionBitMask = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            alienHit(alien: contact.bodyA.node as! SKSpriteNode, torpedo: contact.bodyB.node as! SKShapeNode)
        }
        else if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            alienHit(alien: contact.bodyB.node as! SKSpriteNode, torpedo: contact.bodyA.node as! SKShapeNode)
        }
    }
    
    func alienHit(alien:SKSpriteNode, torpedo:SKShapeNode) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = alien.position
        self.addChild(explosion)
        alien.removeFromParent()
        torpedo.removeFromParent()
        
        score += 1
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            player.position.x = touch.location(in: self).x
        }
    }
}
