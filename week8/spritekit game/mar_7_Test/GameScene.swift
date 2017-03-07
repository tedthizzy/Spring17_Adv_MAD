//
//  GameScene.swift
//  mar_7_Test
//
//  Created by Brittany Ann Kos on 3/6/17.
//  Copyright © 2017 Brittany Ann Kos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "helvetica")
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addStar),
                SKAction.wait(forDuration: 0.5)
                ])
        ))
        
        scoreLabel.fontSize = 30
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontColor = SKColor.blue
        scoreLabel.position = CGPoint(x: 0, y: 0)
        scoreLabel.verticalAlignmentMode = .bottom
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let location = t.location(in: self)
            let touchedNode = self.atPoint(location)
            
            //print(touchedNode)
            if(touchedNode.name == "star50") {
            
                touchedNode.removeFromParent()
                
                score += 1
                
            
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scoreLabel.text = "Score: \(score)"
    }
    
    
    
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(max))) + min
    }
    
    func addStar() {
        
        //print("adding star")
        
        // Create sprite
        let star = SKSpriteNode(imageNamed: "star50")
        star.name = "star50"
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        let x = random(min: 0, max: size.width)
        let y = random(min: 0, max: size.height)
        star.position = CGPoint(x: x, y: y)
        //print("star position -- x: \(x) -- y: \(y)")
        
        // Add the monster to the scene
        addChild(star)
        
        // Create the actions
        let actionMove = SKAction.rotate(byAngle: CGFloat(2*M_PI), duration: 1)
        
        
        star.run(SKAction.repeatForever(actionMove))
        star.run(SKAction.sequence([SKAction.wait(forDuration: 2),
                                    SKAction.fadeOut(withDuration: 0.5),
                                    SKAction.removeFromParent()]))
        
    }
    
    
}
