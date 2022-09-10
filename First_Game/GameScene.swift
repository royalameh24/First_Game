//
//  GameScene.swift
//  First_Game
//
//  Created by ROY ALAMEH on 9/9/22.
//

import SpriteKit
import GameplayKit

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
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Space")
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
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run(addAlien)])))
        
        let animationDuration:TimeInterval = 3
        let animation1:SKAction = SKAction.move(to: CGPoint(x: 768 - player.size.width / 2, y: player.size.height / 2), duration: animationDuration)
        let animation2:SKAction = SKAction.move(to: CGPoint(x: 0 + player.size.width / 2, y: player.size.height / 2), duration: animationDuration)
        
        let actionArray = [animation1, animation2]
        
        player.run(SKAction.repeatForever(SKAction.sequence(actionArray)))
        
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
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //makes explosion appear where tapped, not dragged
            explosion = SKEmitterNode(fileNamed: "explosion")
            explosion.position = CGPoint(x: location.x, y: location.y)
            self.addChild(explosion)
            score += 1
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //allows you to drag spaceship with finger
            //player.position = CGPoint(x: location.x, y: location.y)
            explosion = SKEmitterNode(fileNamed: "explosion")
            explosion.position = CGPoint(x: location.x, y: location.y)
            self.addChild(explosion)
            
        }
    }
}
