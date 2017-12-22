//
//  GameOver.swift
//  Elf
//
//  Created by Vlad verba  on 12/26/16.
//  Copyright © 2016 vladverba. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import GoogleMobileAds


class GameOver: SKScene {
    

    let gameOverSound = SKAction.playSoundFileNamed("GameOver.wav", waitForCompletion: false)
    var shareUs = SKSpriteNode()
    

    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor(red:0.49, green:0.75, blue:0.93, alpha:1.0)
        
        self.run(gameOverSound, withKey: "gameOverSound")
        
        let restart = SKSpriteNode(imageNamed: "CloudCupidRestart.png")
        restart.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        restart.zPosition = 2
        restart.name = "restartButton"
        self.addChild(restart)
        
        // what score did you get?
        let finalScoreLabel = SKLabelNode(fontNamed: "Didot-Bold")
        finalScoreLabel.text = "Score: \(numPoints)"
        finalScoreLabel.fontSize = 70
        finalScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.70)
        finalScoreLabel.fontColor = SKColor.blue
        finalScoreLabel.zPosition = 1
        self.addChild(finalScoreLabel)
        
        // high score
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if numPoints > highScoreNumber {
            highScoreNumber = numPoints
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        // high score label
        let highScoreLabel = SKLabelNode(fontNamed: "Didot-Bold")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 70
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        highScoreLabel.fontColor = SKColor.blue
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        let shareUs = SKSpriteNode(imageNamed: "ShareUs.png")
        shareUs.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        shareUs.zPosition = 2
        shareUs.name = "shareUs"
        self.addChild(shareUs)

    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch  = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let tappedNodeName = tappedNode.name
            
            if tappedNodeName == "restartButton" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view?.presentScene(sceneToMoveTo, transition: sceneTransition)
                print("tapped")
            }
            
            if tappedNodeName == "shareUs" {
                let textToShare = "Check out Cupid Shuffle on the App Store. It's free!"
                
                let objectsToShare = [textToShare]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                
                let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
                
                currentViewController.present(activityVC, animated: true, completion: nil)
            }

            
        }
        

    }
    

}
