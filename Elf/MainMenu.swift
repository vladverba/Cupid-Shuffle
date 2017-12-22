//
//  MainMenu.swift
//  Elf
//
//  Created by Vlad verba  on 12/27/16.
//  Copyright © 2016 vladverba. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    override func didMove(to view: SKView) {
        
        // what score did you get?
        let cupidshuffle = SKLabelNode(fontNamed: "Didot-Bold")
        cupidshuffle.text = "Cupid Shuffle"
        cupidshuffle.fontSize = 120
        cupidshuffle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.70)
        cupidshuffle.fontColor = SKColor.white
        cupidshuffle.zPosition = 1
        self.addChild(cupidshuffle)
        
        let rotL = SKAction.rotate(byAngle: -0.20, duration: 0.3)
        let rotR = SKAction.rotate(byAngle: 0.20, duration: 0.3)

        
        let cycleRot = SKAction.sequence([rotR, rotL, rotL, rotR])
        let cycleRotF = SKAction.repeatForever(cycleRot)
        cupidshuffle.run(cycleRotF)
        
        
        self.backgroundColor = UIColor(red:0.49, green:0.75, blue:0.93, alpha:1.0)

        // play cloud
        let play = SKSpriteNode(imageNamed: "PlayCloud.png")
        play.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        play.zPosition = 2
        play.name = "letsgo"
        
        // action forcloud
        let moveForward = SKAction.moveBy(x: 60.0, y: 0, duration: 1.0)
        let moveBack = SKAction.moveBy(x: -60.0, y: 0, duration: 1.0)
        let cycle = SKAction.sequence([moveForward, moveBack, moveForward, moveBack])
        play.run(SKAction.repeatForever(cycle))
        
        // add cloud
        self.addChild(play)
        
        // buttons
        let rateUs = SKSpriteNode(imageNamed: "RateUs.png")
        rateUs.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        rateUs.zPosition = 2
        rateUs.name = "rateUs"
        self.addChild(rateUs)
        
        let shareUs = SKSpriteNode(imageNamed: "ShareUs.png")
        shareUs.position = CGPoint(x: self.size.width * 0.30, y: self.size.height / 4)
        shareUs.zPosition = 2
        shareUs.name = "shareUs"
        self.addChild(shareUs)
        
        let otherApps = SKSpriteNode(imageNamed: "OurApps.png")
        otherApps.position = CGPoint(x: self.size.width * 0.70, y: self.size.height / 4)
        otherApps.zPosition = 2
        otherApps.name = "otherApps"
        self.addChild(otherApps)
        
        
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch  = touch.location(in: self)
            let tappedNode = atPoint(pointOfTouch)
            let tappedNodeName = tappedNode.name
            
            if tappedNodeName == "letsgo" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view?.presentScene(sceneToMoveTo, transition: sceneTransition)
                print("tapped")
            }
            
            if tappedNodeName == "rateUs" {

                UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/developer/vlad-verba/id1124770532")! as URL)
                }
            
            if tappedNodeName == "otherApps" {
                
                UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/developer/vlad-verba/id1124770532")! as URL)
                }
            
            if tappedNodeName == "shareUs" {
                let textToShare = "Check out NAME OF GAME on the App Store. It's free!"
                
                let objectsToShare = [textToShare]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                
                let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!
                
                currentViewController.present(activityVC, animated: true, completion: nil)
            }

        }
    }
}

