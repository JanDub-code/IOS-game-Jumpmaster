//
//  CollisionSystem.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//
import SpriteKit

struct CollisionCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1 << 0
    static let ground: UInt32 = 0x1 << 1
    static let enemy: UInt32 = 0x1 << 2
    static let collectible: UInt32 = 0x1 << 3
    static let spike: UInt32 = 0x1 << 4
    static let movingBox: UInt32 = 0x1 << 5
    static let lava: UInt32 = 0x1 << 6
    static let decoration: UInt32 = 0x1 << 7
    static let final: UInt32 = 0x1 << 8
}

struct CollisionBitMask {
    static let none: UInt32 = 0
    static let player: UInt32 = CollisionCategory.enemy | CollisionCategory.ground | CollisionCategory.movingBox | CollisionCategory.lava | CollisionCategory.final
    static let ground: UInt32 = CollisionCategory.player | CollisionCategory.enemy | CollisionCategory.movingBox
    static let enemy: UInt32 = CollisionCategory.player | CollisionCategory.enemy | CollisionCategory.ground | CollisionCategory.movingBox | CollisionCategory.lava | CollisionCategory.final
    static let collectible: UInt32 = CollisionCategory.none
    static let spike: UInt32 = CollisionCategory.none
    static let decoration: UInt32 = CollisionCategory.none
    static let movingBox: UInt32 = CollisionCategory.player | CollisionCategory.enemy | CollisionCategory.movingBox | CollisionCategory.ground
    static let lava: UInt32 = CollisionCategory.player | CollisionCategory.enemy | CollisionCategory.movingBox
    static let final: UInt32 = CollisionCategory.player | CollisionCategory.enemy
}

enum GroundType: String {
    case trava = "trava"
    case pisek = "pisek"
    case pisek2 = "pisek2"
    case kamen = "kamen"
    case kamen1 = "kamen1"
    case led = "led"
    case led1 = "led1"
    case led2 = "led2"
    case ledBlock = "led-block"
    case hlina = "hlina"
    case orechLevo = "orech-levo"
    case orechPravo = "orech-pravo"
    case orechStred = "orech-stred"
    case cihly = "cihly"
    case sandstone = "sandstone"
    case sandstone2 = "sandstone2"
    case zlataHlina = "zlata-hlina"
    case zlataHlina2 = "zlata-hlina2"
    case zlataTrava = "zlata-trava"
    case zlata = "zlata"
    
    var assetName: String {
        return rawValue
    }
}

enum LavaType: String {
    case lava = "lava"
    case lava2 = "lava2"
    case lava3 = "lava3"
    
    var assetName: String {
        return rawValue
    }
}

enum MovigBoxType: String {
    case krabice = "krabice"
    case krabice2 = "krabice2"
    
    var assetName: String {
        return rawValue
    }
}

enum DecorationType: String {
    case cedule = "cedule"
    case dybe2 = "dybe2"
    case dyne = "dyne"
    case houba = "houba"
    case houby = "houby"
    case ker = "ker"
    case ker2 = "ker2"
    case palmaLevo = "palma-levo"
    case palmaPravo = "palma-pravo"
    case palmaSpod = "palma-spod"
    case palmaStred = "palma-stred"
    case palmaTop = "palma-top"
    case palmaZem = "palma-zem"
    case strom1_1 = "strom1-1"
    case strom1_2 = "strom1-2"
    case strom1_3 = "strom1-3"
    case strom2_1 = "strom2-1"
    case strom2_2 = "strom2-2"
    case strom2_3 = "strom2-3"
    case voda = "voda"
    
    var assetName: String {
        return rawValue
    }
}

enum TileType: Equatable {
    case empty
    case ground(GroundType)
    case decoration(DecorationType)
    case movingBox(MovigBoxType)
    case lava(LavaType)
    case platform
    case enemy
    case collectible
    case spike
    case player
    case final
    
    static func == (lhs: TileType, rhs: TileType) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.ground(let lhsGround), .ground(let rhsGround)): return lhsGround == rhsGround
        case (.decoration(let lhsGround), .decoration(let rhsGround)): return lhsGround == rhsGround
        case (.movingBox(let lhsGround), .movingBox(let rhsGround)): return lhsGround == rhsGround
        case (.lava(let lhsGround), .lava(let rhsGround)): return lhsGround == rhsGround
        case (.platform, .platform): return true
        case (.enemy, .enemy): return true
        case (.collectible, .collectible): return true
        case (.spike, .spike): return true
        case (.player, .player): return true
        case (.final, .final): return true
        default: return false
        }
    }
    
    // Asset name for each tile type
    var assetName: String {
        switch self {
        case .empty: return ""
        case .ground(let type): return type.assetName
        case .decoration(let type): return type.assetName
        case .movingBox(let type): return type.assetName
        case .lava(let type): return type.assetName
        case .platform: return "kamen"
        case .enemy: return "en-run-doprava1"
        case .collectible: return "coin_00"
        case .spike: return "spike"
        case .player: return "idle-doprava1"
        case .final: return "led"
        }
    }
    
    var categoryBitMask: UInt32 {
        switch self {
        case .empty: return 0
        case .ground, .platform: return CollisionCategory.ground
        case .enemy: return CollisionCategory.enemy
        case .collectible: return CollisionCategory.collectible
        case .spike: return CollisionCategory.spike
        case .player: return CollisionCategory.player
        case .final: return CollisionCategory.final
        case .decoration: return CollisionCategory.decoration
        case .movingBox: return CollisionCategory.movingBox
        case .lava: return CollisionCategory.lava
        }
    }
    
    // Zda má element fyziku
    var hasPhysics: Bool {
        switch self {
        case .empty: return false
        case .decoration: return true
        case .movingBox: return true
        case .lava: return true
        case .ground, .platform: return true
        case .enemy: return true
        case .collectible: return true
        case .spike: return true
        case .player: return true
        case .final: return true
        }
    }
    
    // Zda je element dynamický (může se pohybovat)
    var isDynamic: Bool {
        switch self {
        case .empty, .ground, .platform, .spike, .decoration, .final, .lava: return false
        case .enemy, .player, .movingBox: return true
        case .collectible: return false
        }
    }
}


extension TileType {
    func createNode(size: CGSize, position: CGPoint, name: String = "") -> SKSpriteNode {
        let node = SKSpriteNode(color: .clear, size: size)
        node.position = position
        
        // Pokud má typ fyziku, nastav ji
        if hasPhysics {
            node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 14, height: 16))
            node.physicsBody?.isDynamic = isDynamic
            node.physicsBody?.categoryBitMask = categoryBitMask
            node.physicsBody?.collisionBitMask = CollisionCategory.ground // Základní nastavení
            node.physicsBody?.contactTestBitMask = CollisionCategory.enemy // Základní nastavení
            node.physicsBody?.angularDamping = 100000
            node.physicsBody?.angularVelocity = 0
            node.physicsBody?.friction = 0.0
            node.physicsBody?.restitution = 0.0
            node.physicsBody?.allowsRotation = false
        }
        
        // Přizpůsobení vzhledu (volitelné)
        if let assetName = assetName.isEmpty ? nil : assetName {
            node.texture = SKTexture(imageNamed: assetName)
        }
        
        
        if name == "player" {
            node.animatePlayer(state: "idle-doprava")
        }
        
        return node
    }
}

extension SKSpriteNode {
    func animatePlayer(state: String) {
        if self.action(forKey: "playerAnimation") != nil {
            self.removeAction(forKey: "playerAnimation")
        }
        playPlayerAnimation(state: state)
    }
    
    func stopPlayerAnimation() {
        if self.action(forKey: "playerAnimation") != nil {
            self.removeAction(forKey: "playerAnimation")
        }
    }
    
    private func playPlayerAnimation(state: String) {
        var textures: [SKTexture] = []
        
        switch state {
        case "idle-doprava":
            textures = [
                SKTexture(imageNamed: "idle-doprava1"),
                SKTexture(imageNamed: "idle-doprava2"),
                SKTexture(imageNamed: "idle-doprava3"),
                SKTexture(imageNamed: "idle-doprava4")
            ]
        case "idle-doleva":
            textures = [
                SKTexture(imageNamed: "idle-doleva1"),
                SKTexture(imageNamed: "idle-doleva2"),
                SKTexture(imageNamed: "idle-doleva3"),
                SKTexture(imageNamed: "idle-doleva4")
            ]
        case "run-doprava":
            textures = [
                SKTexture(imageNamed: "run-doprava1"),
                SKTexture(imageNamed: "run-doprava2"),
                SKTexture(imageNamed: "run-doprava3"),
                SKTexture(imageNamed: "run-doprava4"),
                SKTexture(imageNamed: "run-doprava5"),
                SKTexture(imageNamed: "run-doprava6"),
                SKTexture(imageNamed: "run-doprava7"),
                SKTexture(imageNamed: "run-doprava8")
            ]
        case "run-doleva":
            textures = [
                SKTexture(imageNamed: "run-doleva1"),
                SKTexture(imageNamed: "run-doleva2"),
                SKTexture(imageNamed: "run-doleva3"),
                SKTexture(imageNamed: "run-doleva4"),
                SKTexture(imageNamed: "run-doleva5"),
                SKTexture(imageNamed: "run-doleva6"),
                SKTexture(imageNamed: "run-doleva7"),
                SKTexture(imageNamed: "run-doleva8")
            ]
        default:
            break
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true)
        let repeatForever = SKAction.repeatForever(animation)
        self.run(repeatForever, withKey: "playerAnimation")
    }
    
    func animateEnemy(state: String) {
        if self.action(forKey: "enemyAnimation") != nil {
            self.removeAction(forKey: "enemyAnimation")
        }
        playEnemyAnimation(state: state)
    }
    
    private func playEnemyAnimation(state: String) {
        var textures: [SKTexture] = []
        
        switch state {
        case "run-doprava":
            textures = [
                SKTexture(imageNamed: "en-run-doprava1"),
                SKTexture(imageNamed: "en-run-doprava2"),
                SKTexture(imageNamed: "en-run-doprava3"),
                SKTexture(imageNamed: "en-run-doprava4"),
                SKTexture(imageNamed: "en-run-doprava5")
            ]
        case "run-doleva":
            textures = [
                SKTexture(imageNamed: "en-run-doleva1"),
                SKTexture(imageNamed: "en-run-doleva2"),
                SKTexture(imageNamed: "en-run-doleva3"),
                SKTexture(imageNamed: "en-run-doleva4"),
                SKTexture(imageNamed: "en-run-doleva5")
            ]
        default:
            break
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.3, resize: false, restore: true)
        let repeatForever = SKAction.repeatForever(animation)
        self.run(repeatForever, withKey: "enemyAnimation")
    }
}
