//
//  GameScene.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene,SKPhysicsContactDelegate {
    private var levelBuilder: LevelBuilder!
    private var player: SKSpriteNode!
    private var background: SKSpriteNode!
    
    private var leftButton: SKSpriteNode!
    private var rightButton: SKSpriteNode!
    private var upButton: SKSpriteNode!
    
    private var backButton: SKSpriteNode! // Tlačítko pro návrat do menu
    private var pauseButton: SKSpriteNode! // Tlačítko pro pozastavení hry
    
    private var isMovingLeft = false
    private var isMovingRight = false
    private var isGamePaused = false
    private var isGameOver = false
    
    private var isJumping = false
    private var initMove = false
    private var levelsequence: [Int]
    
    private var cameraNode: SKCameraNode!
    //private var cameraSpeed: CGFloat = 25.0 // Rychlost pohybu kamery
    private var cameraSpeed: CGFloat = 5.0
    
    private var multiTouchList: [UITouch: SKNode] = [:]
    
    private let gameData: GameData
    private let backgroundName: String
    private var playerState = "idle-doprava"
    private var levelNum: Int
    var enemies: [SKNode] = []
    
    init(size: CGSize, cameraSpeed: CGFloat,levelSequence: [Int], levelNum: Int, gameData: GameData, backgroundName: String) {
        self.cameraSpeed = cameraSpeed
        self.levelsequence = levelSequence
        self.levelNum = levelNum
        self.gameData = gameData
        self.backgroundName = backgroundName
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //test rychlost
    override func didMove(to view: SKView) {
        levelBuilder = LevelBuilder(scene: self)
        
        view.isMultipleTouchEnabled = true
        
        let levelSequence = levelsequence //[2,2,3,0, 1, 0, 1, 0,0,0,0,0,0,1]
        
        let playerTile = TileType.player
        player = playerTile.createNode(size: CGSize(width: 20, height: 20), position: CGPoint(x: 40, y: self.size.height / 2), name: "player")
        player.physicsBody?.contactTestBitMask = CollisionCategory.player | CollisionCategory.spike | CollisionCategory.collectible
        player.physicsBody?.collisionBitMask = CollisionBitMask.player
        player.physicsBody?.friction = 0.0
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.allowsRotation = false
        player.zPosition = 997
        
        self.addChild(player)
        
        levelBuilder.buildLevel(withPrefabs: levelSequence)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self
        // Nastavení kamery
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        self.addChild(cameraNode)
        
        cameraNode.position.x = CGFloat(self.size.width / 2) //CGPoint(x : self.size.height / 2)
        createMovementButtons()
        createAdditionalButtons()
        
        background = createBackground(name: backgroundName)
        playMusic(name: "time_for_adventure.mp3")
        
    }
    
    private func createAdditionalButtons() {
        // Tlačítko pro pozastavení hry
        pauseButton = createButton(label: "pauseStaticBtn", width: 50, text: "| |", color: SKColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2)), position: CGPoint(x: cameraNode.position.x + (self.size.width / 2) - 40, y: (self.size.height) - 40), action: pauseGame)
        
        self.addChild(pauseButton)
    }
    
    private func goBackToMenu() {
        if let skView = self.view {
            skView.isPaused = true
            DispatchQueue.main.async {
                skView.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func pauseGame() {
        if !isGameOver {
            isGamePaused.toggle() // Přepnutí stavu pauzy
            
            if isGamePaused {
                self.isPaused = true
                // Pozastavení hry
                removeGameStateMessage(labels: ["pauseStaticBtn"])
                
                showGameState(message: "", buttons: [{ self.createButton(label: "pauseBtn", width: 180, text: "🎮 Continue", color: SKColor(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255)), position: CGPoint(x: self.cameraNode.position.x, y: self.cameraNode.position.y + 30), action: self.pauseGame) }, { self.createButton(label: "backBtn", width: 180, text: "❌ Back to menu", color: SKColor(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255)), position: CGPoint(x: self.cameraNode.position.x, y: self.cameraNode.position.y - 30), action: self.goBackToMenu) }])
                
            } else {
                self.isPaused = false // Pokračování hry
                removeGameStateMessage(labels: ["pauseBtn", "backBtn"])
                
                createAdditionalButtons()
            }
        }
    }
    
    private func createMovementButtons() {
        // Ovládací tlačítka
        leftButton = createButton(label: "leftBtn", width: 50, text: "←", color: SKColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2)), position: CGPoint(x: self.size.width - 120, y: 40), action: moveLeft)
        rightButton = createButton(label: "rightBtn", width: 50, text: "→", color: SKColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2)), position: CGPoint(x: self.size.width - 40, y: 40), action: moveRight)
        upButton = createButton(label: "upBtn", width: 50, text: "↑", color: SKColor(Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.2)), position: CGPoint(x: 40, y: 40), action: moveUp)
        
        self.addChild(leftButton)
        self.addChild(rightButton)
        self.addChild(upButton)
    }
    
    private func createButton(label: String, width: Int, text: String, color: SKColor, position: CGPoint, action: @escaping () -> Void) -> SKSpriteNode {
        let size = CGSize(width: width, height: 50)
        let cornerRadius: CGFloat = 12
        
        // Create a rounded rectangle path
        let path = CGPath(roundedRect: CGRect(origin: .zero, size: size),
                          cornerWidth: cornerRadius,
                          cornerHeight: cornerRadius,
                          transform: nil)
        
        let shapeNode = SKShapeNode(path: path)
        shapeNode.fillColor = color
        shapeNode.strokeColor = .clear
        
        let texture = SKView().texture(from: shapeNode)
        
        let button = SKSpriteNode(texture: texture, size: size)
        button.position = position
        button.zPosition = 999
        button.name = label
        button.userData = ["action": action]
        
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = "Helvetica-Bold" // Match bold style
        labelNode.fontSize = 18               // Larger font size for visibility
        labelNode.fontColor = .white          // White text color
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.position = CGPoint(x: 0, y: 0)
        labelNode.zPosition = 1000
        labelNode.name = label
        
        button.addChild(labelNode)
        
        return button
    }
    
    private func createBackground(name: String) -> SKSpriteNode{
        let texture = SKTexture(imageNamed: name)
        let node = SKSpriteNode(texture: texture, color: .clear, size: texture.size())
        
        node.zPosition = -999
        
        self.addChild(node)
        
        node.anchorPoint = .zero
        
        return node
    }
    
    private func moveLeft() {
        if !initMove {
            initMove = true
        }
        
        guard !isGameOver else { return }
        guard !isGamePaused else { return }
        
        player.animatePlayer(state: "run-doleva")
        playerState = "run-doleva"
        
        isMovingLeft = true
    }
    
    private func moveRight() {
        if !initMove {
            initMove = true
        }
        
        guard !isGameOver else { return }
        guard !isGamePaused else { return }
        
        player.animatePlayer(state: "run-doprava")
        playerState = "run-doprava"
        
        isMovingRight = true
    }
    
    private func moveUp() {
        if !initMove {
            initMove = true
        }
        
        guard !isGameOver else { return }
        guard !isGamePaused else { return }
        
        if !isJumping { // Zajistí, že hráč nemůže skočit, pokud už je ve vzduchu
            isJumping = true // Nastaví, že hráč skáče
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2.5)) // Aplikace síly směrem nahoru
            
            playSound(name: "jump.wav")
        }
    }
    
    private func gameOver() {
        self.isGameOver = true
        self.isPaused = true
        
        showGameState(message: "Game Over", buttons: [{ self.createButton(label: "backBtn", width: 180, text: "❌ Back to menu", color: SKColor(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255)), position: CGPoint(x: self.cameraNode.position.x, y: self.cameraNode.position.y), action: self.goBackToMenu) }])
        removeGameStateMessage(labels: ["pauseStaticBtn"])
        player.stopPlayerAnimation()
    }
    
    private func Win() {
        self.isGameOver = true
        self.isPaused = true
        
        gameData.setLevelCompleted(levelNum)
        
        showGameState(message: "You Win!", buttons: [{ self.createButton(label: "backBtn", width: 180, text: "❌ Back to menu", color: SKColor(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255)), position: CGPoint(x: self.cameraNode.position.x, y: self.cameraNode.position.y), action: self.goBackToMenu) }])
        
        removeGameStateMessage(labels: ["pauseStaticBtn"])
    }
    
    private func showGameState(message: String, buttons: [() -> SKSpriteNode] = []) {
        if(message != "") {
            let label = SKLabelNode(text: message)
            
            label.fontName = "Arial-BoldMT"
            label.fontSize = 40
            label.fontColor = .red
            label.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y + CGFloat(35 * buttons.count))
            label.zPosition = 1000
            
            self.addChild(label)
        }
        
        for button in buttons {
            self.addChild(button())
        }
        
    }
    
    // Kontinuální pohyb při držení tlačítka
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if isMovingLeft {
            player.position.x -= 1.5
        }
        if isMovingRight {
            player.position.x += 1.5
        }
        cameraNode.position.y = self.size.height / 2
        
        // Pohyb kamery nezávisle (doprava)
        if initMove {
            cameraNode.position.x += cameraSpeed * 0.02 // Kamera se pohybuje čtvrtinovou rychlostí
            
            // Změna pozice kamery na ose Y o 100 výše
            
            
            // Pohyb tlačítek stejnou rychlostí jako kamera
            leftButton.position.x += cameraSpeed * 0.02
            background.position.x += cameraSpeed * 0.02
            rightButton.position.x += cameraSpeed * 0.02
            upButton.position.x += cameraSpeed * 0.02
            pauseButton.position.x += cameraSpeed * 0.02
            
            let cameraFrame = CGRect(
                x: cameraNode.position.x - self.size.width / 2,
                y: cameraNode.position.y - self.size.height / 2,
                width: self.size.width,
                height: self.size.height
            )
            
            if !cameraFrame.contains(player.position) {
                gameOver() // Ukončení hry
            }
            
            if player.physicsBody?.velocity.dy == 0 {
                isJumping = false
            }
        }
        
        enumerateChildNodes(withName: "enemy") { enemy, _ in
            guard let direction = enemy.userData?["direction"] as? Double else { return }
            
            enemy.position.x += CGFloat(direction)
            
        }
    }
    
    // Dotyková událost pro detekci kliknutí na tlačítka
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtTouch = nodes(at: location)
            
            for node in nodesAtTouch {
                multiTouchList[touch] = node
                if let action = node.userData?["action"] as? () -> Void {
                    action()
                }
            }
        }
    }
    
    private func removeGameStateMessage(labels: [String]) {
        for label in labels {
            self.enumerateChildNodes(withName: label) { node, _ in
                node.removeFromParent()
            }
        }
    }
    
    // Dotyková událost pro detekci uvolnění tlačítka
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if leftButton.contains(location) {
                isMovingLeft = false
            }
            if rightButton.contains(location) {
                isMovingRight = false
            }
            
            if multiTouchList[touch] != nil {
                multiTouchList[touch] = nil
            }
            
            if !isGameOver && !isGamePaused {
                if !isMovingLeft && !isMovingRight {
                    if playerState == "run-doprava" {
                        player.animatePlayer(state: "idle-doprava")
                    }
                    else if playerState == "run-doleva" {
                        player.animatePlayer(state: "idle-doleva")
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player && (secondBody.categoryBitMask == CollisionCategory.ground || secondBody.categoryBitMask == CollisionCategory.movingBox) {
            let playerNode = firstBody.node!
            let floorNode = secondBody.node!
            
            if playerNode.position.y >= floorNode.position.y {
                playerNode.physicsBody?.velocity.dy = 0
                
                isJumping = false
            }
        }
        
        if (firstBody.categoryBitMask == CollisionCategory.ground || firstBody.categoryBitMask == CollisionCategory.movingBox)  && secondBody.categoryBitMask == CollisionCategory.player{
            let playerNode = secondBody.node!
            let floorNode = firstBody.node!
            
            print("ddd")
            
            if playerNode.position.y > floorNode.position.y {
                isJumping = false
            }
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player &&
            secondBody.categoryBitMask == CollisionCategory.enemy {
            guard let playerNode = firstBody.node, let enemyNode = secondBody.node else { return }
            
            if playerNode.position.y >= enemyNode.position.y + enemyNode.frame.height - 2 {
                
                gameData.addEnemiesKilled(1)
                
                playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.9)) // Bounce the player
                
                playSound(name: "hurt.wav")
                
                enemyNode.removeFromParent()
            } else {
                gameOver()
            }
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player &&
            secondBody.categoryBitMask == CollisionCategory.collectible {
            gameData.addCoinsCollected(1)
            
            playSound(name: "coin.wav")
            
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player &&
            secondBody.categoryBitMask == CollisionCategory.final {
            Win()
        }
        
        if firstBody.categoryBitMask == CollisionCategory.enemy &&
            secondBody.categoryBitMask == CollisionCategory.enemy {
            firstBody.node?.userData?["direction"] = (firstBody.node?.userData?["direction"] as! Double) * -1.0
            secondBody.node?.userData?["direction"] = (secondBody.node?.userData?["direction"] as! Double) * -1.0
            
            changeEnemyAnimation(movement: firstBody.node?.userData?["direction"] as! Double, node: firstBody.node as? SKSpriteNode)
            changeEnemyAnimation(movement: secondBody.node?.userData?["direction"] as! Double, node: secondBody.node as? SKSpriteNode)
        }
        
        if firstBody.categoryBitMask == CollisionCategory.ground &&
            secondBody.categoryBitMask == CollisionCategory.enemy {
            if secondBody.node != nil && Int(round(secondBody.node!.position.y)) == Int(round(firstBody.node!.position.y)) {
                secondBody.node!.userData?["direction"] = (secondBody.node!.userData?["direction"] as! Double) * -1.0
                
                changeEnemyAnimation(movement: secondBody.node?.userData?["direction"] as! Double, node: secondBody.node as? SKSpriteNode)
                
            }
        }
        
        if firstBody.categoryBitMask == CollisionCategory.enemy &&
            secondBody.categoryBitMask == CollisionCategory.movingBox {
            firstBody.node?.userData?["direction"] = (firstBody.node?.userData?["direction"] as! Double) * -1.0
            
            changeEnemyAnimation(movement: firstBody.node?.userData?["direction"] as! Double, node: firstBody.node as? SKSpriteNode)
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player &&
            secondBody.categoryBitMask == CollisionCategory.movingBox {
            firstBody.node!.physicsBody?.velocity.dx = (secondBody.node!.physicsBody?.velocity.dx)!
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player &&
            secondBody.categoryBitMask == CollisionCategory.lava {
            playSound(name: "hurt.wav")
            
            gameOver()
        }
        
        if firstBody.categoryBitMask == CollisionCategory.player &&
            secondBody.categoryBitMask == CollisionCategory.spike {
            if firstBody.node?.physicsBody?.velocity.dy != 0 {
                playSound(name: "hurt.wav")
                
                gameOver()
            }
        }
    }
    
    private func changeEnemyAnimation(movement: Double, node: SKSpriteNode?) {
        if movement < 0.0 {
            node?.animateEnemy(state: "run-doleva")
        } else {
            node?.animateEnemy(state: "run-doprava")
        }
    }
    
    private func playSound(name: String) {
        if gameData.getSoundsEnabled() {
            self.run(SKAction.playSoundFileNamed(name, waitForCompletion: false))
        }
    }
    
    private func playMusic(name: String) {
        if gameData.getMusicEnabled() {
            let backgroundMusic = SKAudioNode(fileNamed: name)
            backgroundMusic.autoplayLooped = true
            backgroundMusic.isPositional = false
            backgroundMusic.run(SKAction.changeVolume(to: 0.5, duration: 0))
            
            self.addChild(backgroundMusic)
        }
    }
}
