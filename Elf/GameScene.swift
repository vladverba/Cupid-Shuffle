//
//  GameScene.swift
//  Cupid Game
//
//  Created by Vlad verba  on 12/24/16.
//  Copyright © 2016 vladverba. All rights reserved.
//


// standard importing
import SpriteKit
import Foundation
import GameplayKit
import GoogleMobileAds

// extension to create a sin wave for heart
let π = CGFloat(M_PI)

extension SKAction {
    static func oscillation(amplitude a: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint) -> SKAction {
        let action = SKAction.customAction(withDuration: Double(t)) { node, currentTime in
            let displacement = a * sin(2 * π * currentTime / t)
            node.position.y = midPoint.y + displacement
        }
        
        return action
    }
}

// enum for collisions and physics
enum BodyType: UInt32 {
    case player = 1
    case enemy = 2
    case ground = 4
    case heart = 8
    case star = 16
    case shield = 32
}

var numPoints = 0


// GameScene Starts
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var frequencyHeart = 3.0
    var timerStar = Timer()
    var timerExtraHearts = Timer()
    var timerShield = Timer()
    
    
    // sayings and phrases
    var saying1 = SKLabelNode(fontNamed: "HoeflerText-Italic")
    var saying2 = SKLabelNode(fontNamed: "HoeflerText-Italic")
    var saying3 = SKLabelNode(fontNamed: "HoeflerText-Italic")
    var saying4 = SKLabelNode(fontNamed: "HoeflerText-Italic")
    var saying5 = SKLabelNode(fontNamed: "HoeflerText-Italic")
    var instructions = SKLabelNode(fontNamed: "HoeflerText-Italic")
    

    // sprites
    var cloudBackground = SKSpriteNode()
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var heart = SKSpriteNode()
    var wall = SKSpriteNode()
    
    var shield = SKSpriteNode()
    
    var goldenStar = SKSpriteNode()
    
    var cupidShield = SKSpriteNode()
    
    // main character texture atlas
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    // points and score
    let points = SKLabelNode(text: "0")
    
    // score
    let ding = SKAction.playSoundFileNamed("HeartCaught.wav", waitForCompletion: false)
    var backgroundMusic: SKAudioNode!
    let powerUpStar = SKAction.playSoundFileNamed("PowerUpStar.wav", waitForCompletion: false)

    
    
    // did move to view function
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -15.0)
        
        numPoints = 0
        
        //world's contact delegate
        physicsWorld.contactDelegate = self

        if let musicURL = Bundle.main.url(forResource: "Morning_Stroll", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    
        
        // timer for the hearts
        _ = Timer.scheduledTimer(timeInterval: frequencyHeart, target: self, selector: #selector(GameScene.spawnHeart), userInfo: nil, repeats: true)
        
        
        
        timerStar = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(GameScene.goldenStarSpawn), userInfo: nil, repeats: true)
        
        timerShield = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(GameScene.spawnShield), userInfo: nil, repeats: true)
        
        

        // texture atlas for player
        TextureAtlas = SKTextureAtlas(named: "Cupids.atlas")
        
        for i in 1...TextureAtlas.textureNames.count {
        
            let Name = "Cupid\(i).png"
            TextureArray.append(SKTexture(imageNamed: Name))
        
        }


        // set up the player and add to the scene
        player = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0] )
        player.size = CGSize(width: 250, height: 330)
        player.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.80)
        player.zPosition = 1
        self.addChild(player)
        
        // run the texture of the player
        player.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.05)))

        // physics of the player
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width/2, height: player.size.height / 1.4))
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = BodyType.player.rawValue
        player.physicsBody?.collisionBitMask = BodyType.enemy.rawValue
        player.physicsBody?.contactTestBitMask = BodyType.enemy.rawValue
        player.physicsBody?.affectedByGravity = true
        

        
        // 4 - Set scene background color to blue
        backgroundColor = UIColor(red:0.49, green:0.75, blue:0.93, alpha:1.0)
        
        // set action for spawn enemy
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy),
                SKAction.wait(forDuration: 0.9)])))

        //set action for spawn clouds
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnClouds),
                SKAction.wait(forDuration: 2.5)])))

        // add clouds and labels
        spawnClouds()
        setupLabels()
        


        

    }
    
    
    
    func setupLabels() {

        points.position = CGPoint(x: frame.size.width/2, y: frame.size.height * 0.1)
        points.fontColor = UIColor.white
        points.fontSize = 100
        addChild(points)
        
        // set up label for sayings
        saying1.fontSize = 200.0
        saying1.text = "nice start!"
        saying1.fontColor = UIColor(red:0.90, green:0.37, blue:0.64, alpha:1.0)
        saying1.zPosition = 5
        saying1.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        
        saying2.fontSize = 200.0
        saying2.text = "sweet!"
        saying2.fontColor = UIColor(red:0.90, green:0.37, blue:0.64, alpha:1.0)
        saying2.zPosition = 5
        saying2.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        
        saying3.fontSize = 200.0
        saying3.text = "keep it up"
        saying3.fontColor = UIColor(red:0.90, green:0.37, blue:0.64, alpha:1.0)
        saying3.zPosition = 5
        saying3.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        
        saying4.fontSize = 200.0
        saying4.text = "sweet!"
        saying4.fontColor = UIColor(red:0.90, green:0.37, blue:0.64, alpha:1.0)
        saying4.zPosition = 5
        saying4.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        
        saying5.fontSize = 150.0
        saying5.text = "BONUS POINTS"
        saying5.fontColor = UIColor.yellow
        saying5.zPosition = 5
        saying5.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        
        instructions.fontSize = 70.0
        instructions.text = "Avoid arrows, collect the hearts!"
        instructions.fontColor = UIColor.white
        instructions.zPosition = 5
        instructions.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.70)
        self.addChild(instructions)
        
    }
    
    // random function
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnClouds(){
    
        cloudBackground = SKSpriteNode(imageNamed: "CloudCupid.png")
        cloudBackground.alpha = 0.7
        cloudBackground.position = CGPoint(x: frame.size.width + cloudBackground.size.width/2, y: frame.size.height * random(min: 0, max: 1))
        self.addChild(cloudBackground)
        
        cloudBackground.run(
            SKAction.moveBy(x: -size.width - cloudBackground.size.width, y: 0.0,
                            duration: TimeInterval(random(min: 8.0, max: 12.0))))

    
    }
    
    // Spawn enemy function
    func spawnEnemy() {
        // set the enemy
        enemy = SKSpriteNode(imageNamed: "ArrowCupidGame.png")
        // give it a name
        enemy.name = "enemy"
        // position of the enemy
        enemy.position = CGPoint(x: frame.size.width + enemy.size.width/2,
                                 y: frame.size.height * random(min: 0, max: 1))
        // 5
        addChild(enemy)
        
        // move enemy forward
        enemy.run(
            SKAction.moveBy(x: -size.width - enemy.size.width, y: 0.0,
                             duration: TimeInterval(random(min: 1.5, max: 3))))

        enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.size.width / 1.2, height: enemy.size.height / 1.2))
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        enemy.physicsBody?.collisionBitMask = BodyType.player.rawValue
        enemy.physicsBody?.contactTestBitMask = BodyType.player.rawValue

        
    }
    
    func goldenStarSpawn() {
        
        let goldenStar = SKSpriteNode(imageNamed: "GoldStarCupid.png")
        goldenStar.size = CGSize(width: 120.0, height: 120.0)

        goldenStar.position = CGPoint(x: frame.size.width + goldenStar.size.width/2,
                                 y: frame.size.height * random(min: 0, max: 1))
        
        goldenStar.physicsBody = SKPhysicsBody(circleOfRadius: goldenStar.size.width)
        goldenStar.physicsBody?.allowsRotation = false
        goldenStar.physicsBody?.categoryBitMask = BodyType.star.rawValue
        goldenStar.physicsBody?.collisionBitMask = BodyType.player.rawValue
        goldenStar.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        goldenStar.physicsBody?.affectedByGravity = false
        
        
        self.addChild(goldenStar)
        
        let rotate = SKAction.rotate(byAngle: 1.0, duration: 0.5)
        goldenStar.run(SKAction.repeatForever(rotate))

        
        let oscillate = SKAction.oscillation(amplitude: 300, timePeriod: 1, midPoint: goldenStar.position)
        goldenStar.run(SKAction.repeatForever(oscillate))
        goldenStar.run(SKAction.moveBy(x: -size.width, y: 0, duration: 5))
        
    }

    
    
    func spawnHeart() {
    
        let heart = SKSpriteNode(imageNamed: "SinHeart.png")
        heart.size = CGSize(width: 100.0, height: 100.0)
        heart.position = CGPoint(x: frame.size.width + heart.size.width/2,
                                y: frame.size.height * random(min: 0, max: 1))
        
        heart.physicsBody = SKPhysicsBody(circleOfRadius: heart.size.width)
        heart.physicsBody?.allowsRotation = false
        heart.physicsBody?.categoryBitMask = BodyType.heart.rawValue
        heart.physicsBody?.collisionBitMask = BodyType.player.rawValue
        heart.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        heart.physicsBody?.affectedByGravity = false

        
        self.addChild(heart)
        
        let oscillate = SKAction.oscillation(amplitude: 150, timePeriod: 1, midPoint: heart.position)
        heart.run(SKAction.repeatForever(oscillate))
        heart.run(SKAction.moveBy(x: -size.width, y: 0, duration: 5))
    
    }
    
    func spawnShield() {
        
        let shield = SKSpriteNode(imageNamed: "CandyCupid.png")
        shield.size = CGSize(width: 120, height: 120)
        shield.position = CGPoint(x: frame.size.width + shield.size.width/2,
                                 y: frame.size.height * random(min: 0, max: 1))
        
        shield.physicsBody = SKPhysicsBody(circleOfRadius: shield.size.width)
        shield.physicsBody?.allowsRotation = false
        shield.physicsBody?.categoryBitMask = BodyType.shield.rawValue
        shield.physicsBody?.collisionBitMask = BodyType.player.rawValue
        shield.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        shield.physicsBody?.affectedByGravity = false
        
        
        addChild(shield)
        
        let rotate = SKAction.rotate(byAngle: 1.0, duration: 0.5)
        shield.run(SKAction.repeatForever(rotate))

        
        let oscillate = SKAction.oscillation(amplitude: 300, timePeriod: 1, midPoint: shield.position)
        shield.run(SKAction.repeatForever(oscillate))
        shield.run(SKAction.moveBy(x: -size.width, y: 0, duration: 5))
        
    }
    
    func spawnExtraHearts() {
        
        timerExtraHearts = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameScene.spawnExtraHearts), userInfo: nil, repeats: false)
        
        let heart = SKSpriteNode(imageNamed: "SinHeart.png")
        heart.size = CGSize(width: 100.0, height: 100.0)
        heart.position = CGPoint(x: frame.size.width + heart.size.width/2,
                                 y: frame.size.height * random(min: 0, max: 1))
        
        heart.physicsBody = SKPhysicsBody(circleOfRadius: heart.size.width)
        heart.physicsBody?.allowsRotation = false
        heart.physicsBody?.categoryBitMask = BodyType.heart.rawValue
        heart.physicsBody?.collisionBitMask = BodyType.player.rawValue
        heart.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        heart.physicsBody?.affectedByGravity = false
        
        
        self.addChild(heart)
        
        let oscillate = SKAction.oscillation(amplitude: 150, timePeriod: 1, midPoint: heart.position)
        heart.run(SKAction.repeatForever(oscillate))
        heart.run(SKAction.moveBy(x: -size.width, y: 0, duration: 5))
        
    }

    
    func jumpPlayer() {
        // 1
        let impulse =  CGVector(dx: 0, dy: 75)
        // 2
        player.physicsBody?.applyImpulse(impulse)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        player.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1500))
        
        }
    
    // when contact begins
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB

        if (((firstBody.categoryBitMask == BodyType.player.rawValue) && (secondBody.categoryBitMask == BodyType.enemy.rawValue)) || ((firstBody.categoryBitMask == BodyType.enemy.rawValue) && (secondBody.categoryBitMask == BodyType.player.rawValue))) {
            
            print("Game Over :(")
            gameOver()
        }
        
        if (((firstBody.categoryBitMask == BodyType.player.rawValue) && (secondBody.categoryBitMask == BodyType.star.rawValue)) || ((firstBody.categoryBitMask == BodyType.star.rawValue) && (secondBody.categoryBitMask == BodyType.player.rawValue))){
            
            self.run(powerUpStar)

            collideWithStar(goldenStar: (secondBody.node as? SKSpriteNode)!)
            spawnExtraHearts()
            print("star and person collided")
            
            self.addChild(saying5)
            let fadeOut = SKAction.fadeOut(withDuration: 1.0)
            let grow = SKAction.scale(by: 1.4, duration: 1.0)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut,grow,remove])
            saying5.run(sequence)
            
        }
        
        if (((firstBody.categoryBitMask == BodyType.player.rawValue) && (secondBody.categoryBitMask == BodyType.shield.rawValue)) || ((firstBody.categoryBitMask == BodyType.shield.rawValue) && (secondBody.categoryBitMask == BodyType.player.rawValue))){
            
        timerExtraHearts = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(GameScene.removeArrows), userInfo: nil, repeats: false)

            
            collisionWithShield(shield: secondBody.node as! SKSpriteNode)
            removeArrows()
            self.run(powerUpStar)


        }

        
        if (((firstBody.categoryBitMask == BodyType.player.rawValue) && (secondBody.categoryBitMask == BodyType.heart.rawValue)) || ((firstBody.categoryBitMask == BodyType.heart.rawValue) && (secondBody.categoryBitMask == BodyType.player.rawValue))) {
            
            timerExtraHearts.invalidate()
            
            self.run(ding)
            
            collisionWithHeart(heart: secondBody.node as! SKSpriteNode)
            print("collidedwithheart")
            
            // change back to three
            
            if (numPoints == 1){
                
                instructions.removeFromParent()
                
            }
            
            if (numPoints == 3){
                
                self.addChild(saying1)
                let fadeOut = SKAction.fadeOut(withDuration: 2.0)
                saying1.run(fadeOut)
                
                let grow = SKAction.scale(by: 1.4, duration: 2.0)
                saying1.run(grow)
                
                
            }
            
            if (numPoints == 7){
                
                self.addChild(saying2)
                let fadeOut = SKAction.fadeOut(withDuration: 1.0)
                saying2.run(fadeOut)
                
                let grow = SKAction.scale(by: 1.4, duration: 2.0)
                saying2.run(grow)
                
            }
            
            if (numPoints == 14){
                
                self.addChild(saying3)
                let fadeOut = SKAction.fadeOut(withDuration: 1.0)
                saying3.run(fadeOut)
                
                let grow = SKAction.scale(by: 1.4, duration: 2.0)
                saying3.run(grow)
                
            }
            
            if (numPoints == 20){
                
                self.addChild(saying4)
                let fadeOut = SKAction.fadeOut(withDuration: 1.0)
                saying4.run(fadeOut)
                
                let grow = SKAction.scale(by: 1.4, duration: 2.0)
                saying4.run(grow)
                
            }

        
        
        }
        
        

        
    }
    
    func collisionWithHeart(heart: SKSpriteNode){
        
        numPoints += 1
        points.text = "\(numPoints)"
        
        heart.removeFromParent()

        }
    
    func collisionWithShield(shield: SKSpriteNode){
        
        shield.removeFromParent()
        
    }
    
    func collideWithStar(goldenStar: SKSpriteNode){
        
        
        numPoints += 5
        points.text = "\(numPoints)"
        
        goldenStar.removeFromParent()
        
    }

    

    
    override func update(_ currentTime: TimeInterval) {
        if (player.position.y > self.size.height + 100){
        print("Over the top")
            gameOver()
        }
        if (player.position.y < -100){
        print("Below")
            gameOver()
        }
        
        
    }

    
    func pauseGame() {
        scene?.view?.isPaused = true
    }
    
    func gameNotPause() {
        scene?.view?.isPaused = false
    }
    
    func gameOver(){
        

        let sceneToMoveTo = GameOver(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let sceneTransition = SKTransition.fade(withDuration: 0.2)
        self.view?.presentScene(sceneToMoveTo, transition: sceneTransition)
        
        var randomImageNumber = arc4random()%2
        print(randomImageNumber)
        
        if (randomImageNumber == 1) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowInterAd"), object: nil)

        }
    }
    
    func removeArrows(){

        // Removing Specific Children
        for child in self.children {
            
        let remove = SKAction.removeFromParent()

            //Determine Details
            if (child.name == "enemy") {
                child.run(remove)
            }
        }
        
        }

}
    
    

