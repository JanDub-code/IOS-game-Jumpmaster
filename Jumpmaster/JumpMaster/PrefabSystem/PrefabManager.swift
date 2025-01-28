//
//  PrefabManager.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//

import SpriteKit

// Třída pro správu prefabrikátů
class PrefabManager {
    // Definice prefabrikátů - každý prefab je 2D pole s typy elementů
    static let prefabs: [Int: [[TileType]]] = [
        0: [ // Základní platformový prefab
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .decoration(.palmaTop), .empty, .empty, .collectible , .empty],
            [.empty, .empty, .empty, .empty, .decoration(.palmaLevo), .decoration(.palmaStred), .decoration(.palmaPravo), .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .decoration(.palmaSpod), .empty, .empty, .empty, .empty],
            [.empty, .decoration(.cedule), .empty, .empty, .empty, .decoration(.palmaZem), .empty, .empty, .movingBox(.krabice), .empty],
            [.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava), .ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava)],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina) ]
           ],
        1: [ // Prefab s překážkami
            [.empty, .empty, .empty, .empty, .collectible, .empty, .empty, .collectible, .collectible, .empty],
            [.collectible, .collectible, .empty, .empty, .empty, .empty, .empty, .ground(.trava),.ground(.trava), .empty],
            [.ground(.trava),.ground(.trava), .empty, .empty, .spike, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .ground(.trava),.ground(.trava),.ground(.trava), .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.movingBox(.krabice), .enemy, .spike, .empty, .collectible, .empty, .spike, .empty, .enemy, .ground(.trava)],
            [.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava)]
           ],
        2: [ // Základní platformový prefab
            [.empty, .collectible, .empty, .empty, .collectible, .empty, .empty, .collectible, .empty, .ground(.kamen)],
            [.empty, .ground(.kamen), .empty, .empty, .ground(.kamen), .empty, .empty, .ground(.kamen), .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .collectible, .empty, .empty],
            [.empty, .collectible, .empty, .empty, .collectible, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .spike, .empty, .empty, .empty, .empty, .empty],
            [.ground(.kamen),.empty,.empty,.ground(.kamen),.ground(.kamen),.ground(.kamen),.empty,.empty,.ground(.kamen),.ground(.kamen)],
            [.ground(.kamen),.lava(.lava),.lava(.lava),.ground(.kamen),.ground(.hlina),.ground(.kamen),.lava(.lava),.lava(.lava),.ground(.kamen),.ground(.kamen) ]
           ],
        3: [ // Základní platformový prefab
            [.empty, .empty, .collectible, .empty, .empty, .collectible, .empty, .empty, .empty, .empty],
            [.empty, .empty, .ground(.kamen), .empty, .empty, .ground(.kamen), .empty, .empty, .empty, .empty],
            [.empty, .collectible, .empty, .empty, .empty, .empty, .empty, .empty, .collectible, .empty],
            [.empty, .ground(.kamen), .empty, .empty, .empty, .empty, .empty, .empty, .spike, .empty],
            [.empty, .empty, .ground(.kamen), .empty, .empty, .collectible, .empty, .ground(.kamen),.ground(.kamen),.ground(.kamen)],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .ground(.kamen), .empty, .empty, .empty, .empty]
           ],
        4: [ // Základní platformový prefab
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .collectible],
            [.empty, .empty, .empty, .decoration(.palmaTop), .empty, .collectible, .collectible, .empty, .decoration(.palmaTop), .ground(.trava)],
            [.empty, .empty, .decoration(.palmaLevo), .decoration(.palmaStred), .decoration(.palmaPravo), .empty, .empty, .decoration(.palmaLevo), .decoration(.palmaStred), .decoration(.palmaPravo)],
            [.empty, .empty, .empty, .decoration(.palmaSpod), .ground(.orechLevo), .ground(.orechStred), .ground(.orechStred), .ground(.orechPravo), .decoration(.palmaSpod), .empty],
            [.movingBox(.krabice), .empty, .enemy, .decoration(.palmaZem), .collectible, .collectible, .empty, .enemy, .decoration(.palmaZem), .movingBox(.krabice)],
            [.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava)],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina) ]
           ],
        5: [
            [.empty, .empty, .empty, .empty, .collectible, .collectible, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .collectible, .empty, .empty, .empty],
            [.empty, .movingBox(.krabice), .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.ground(.trava),.ground(.trava),.ground(.trava),.ground(.kamen1),.empty, .empty, .empty,.ground(.kamen1),.ground(.trava),.ground(.trava)],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.kamen1),.empty, .empty, .empty,.ground(.kamen1),.ground(.hlina),.ground(.hlina) ],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.kamen1),.empty, .empty, .empty,.ground(.kamen1),.ground(.hlina),.ground(.hlina) ],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.kamen1),.empty, .empty, .empty,.ground(.kamen1),.ground(.hlina),.ground(.hlina) ]
            
        ],
        6: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .decoration(.strom2_3), .empty, .empty, .empty, .empty, .decoration(.strom1_3)],
            [.empty, .empty, .empty, .empty, .decoration(.strom2_2), .empty, .empty, .empty, .empty, .decoration(.strom1_2)],
            [.empty, .decoration(.houba), .empty, .empty, .decoration(.strom2_1), .empty, .empty, .empty, .empty, .decoration(.strom1_1)],
            [.ground(.trava),.ground(.trava),.ground(.trava),.ground(.trava),.final,.final,.final,.final,.final,.final],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina) ]
            
        ],
        7: [
            [.empty, .empty, .collectible, .empty, .ground(.kamen), .empty, .empty, .ground(.kamen), .empty, .ground(.kamen)],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .ground(.kamen), .empty, .empty, .empty, .collectible, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .ground(.kamen), .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .collectible, .empty, .empty, .empty, .ground(.kamen), .empty, .empty, .empty],
            [.ground(.kamen), .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .ground(.kamen), .empty, .empty, .ground(.kamen), .empty, .empty, .empty, .empty]
            
        ],
        8: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .collectible, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .ground(.cihly), .ground(.cihly), .ground(.cihly), .ground(.cihly), .ground(.cihly), .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.ground(.cihly), .empty, .collectible, .enemy, .empty, .empty, .empty, .collectible, .enemy, .collectible],
            [.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),],
            [.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),]
            
        ],
        9: [
            [.empty, .empty, .empty, .empty, .collectible, .collectible, .empty, .empty, .empty, .empty],
            [.empty, .ground(.cihly), .empty, .empty, .empty, .empty, .empty, .empty, .ground(.cihly), .empty],
            [.ground(.cihly), .ground(.cihly), .ground(.cihly), .empty, .empty, .empty, .empty, .ground(.cihly), .ground(.cihly), .ground(.cihly)],
            [.empty, .empty, .empty, .empty, .collectible, .collectible, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .enemy, .ground(.cihly), .ground(.cihly), .enemy, .empty, .empty, .empty],
            [.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),],
            [.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),]
        ],
        10: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .ground(.cihly), .ground(.cihly), .ground(.cihly), .ground(.cihly), .ground(.cihly), .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.collectible, .enemy, .collectible, .empty, .empty, .empty, .empty, .collectible, .enemy, .ground(.cihly)],
            [.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),.ground(.cihly),],
            [.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),.ground(.kamen1),]
        ],
        11: [
            [.empty, .collectible, .empty, .empty, .empty, .empty, .empty, .empty, .collectible, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .decoration(.dyne)],
            [.ground(.pisek), .ground(.pisek), .ground(.pisek), .empty, .collectible, .collectible, .empty, .ground(.pisek), .ground(.pisek), .ground(.pisek)],
            [.empty, .empty, .empty, .decoration(.strom2_3), .empty, .empty, .decoration(.strom2_3), .empty, .empty, .empty],
            [.decoration(.dybe2), .empty, .empty, .decoration(.strom2_1), .ground(.pisek), .ground(.pisek), .decoration(.strom2_1), .empty, .empty, .empty],
            [.ground(.pisek), .ground(.pisek), .ground(.pisek), .ground(.pisek), .ground(.sandstone), .ground(.sandstone), .ground(.pisek), .ground(.pisek), .ground(.pisek), .ground(.pisek)],
            [.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),]
            
        ],
        12: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .ground(.pisek), .ground(.pisek), .empty, .empty, .empty, .ground(.pisek), .ground(.pisek), .empty],
            [.collectible, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .collectible],
            [.movingBox(.krabice), .empty, .enemy, .empty, .collectible, .ground(.pisek), .empty, .enemy, .empty, .movingBox(.krabice)],
            [.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),.ground(.sandstone),]
            
        ],
        13: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .decoration(.palmaTop), .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .decoration(.palmaLevo), .decoration(.palmaStred), .decoration(.palmaPravo), .empty, .empty],
            [.collectible, .empty, .decoration(.houby), .empty, .empty, .empty, .decoration(.palmaSpod), .empty, .empty, .collectible],
            [.empty, .empty, .ground(.trava),.ground(.trava), .ground(.trava), .ground(.trava), .ground(.trava), .ground(.trava), .empty, .empty],
            [.empty,.ground(.trava),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.trava),.empty ],
            [.ground(.trava),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.trava) ],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina) ]
            
            
        ],
        14: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .collectible, .empty, .collectible, .empty, .collectible, .empty, .collectible, .empty],
            [.empty, .empty, .empty, .decoration(.dyne), .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .ground(.trava), .empty, .ground(.trava), .empty, .ground(.trava), .empty, .ground(.trava), .empty, .decoration(.ker)],
            [.ground(.trava), .ground(.hlina), .spike, .ground(.hlina), .spike, .ground(.hlina), .spike, .ground(.hlina), .spike, .ground(.trava)],
            [.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina),.ground(.hlina) ]
            
            
        ],
        15: [
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
            [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty]
            
        ],
    ]
    
    // Vytvoření herního objektu podle typu
    static func createNode(for type: TileType, at position: CGPoint) -> SKNode? {
        guard type != .empty else { return nil }
        
        let node = SKSpriteNode(imageNamed: type.assetName)
        node.position = position
        
        let texture: SKTexture? = nil

        if type.hasPhysics {
            var physicsBody: SKPhysicsBody
            
            if texture != nil {
                physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: 0.5, size: CGSize(width: 16, height: 16))
                
            } else {
                physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 16, height: 16))
            }
            
            
            if type == .spike {
                let texture = SKTexture(imageNamed: type.assetName)
                physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
            }
            
            switch type {
            case .ground(_), .platform:
                physicsBody.contactTestBitMask = CollisionBitMask.ground
                physicsBody.collisionBitMask = CollisionBitMask.ground
                
            case .enemy:
                physicsBody.contactTestBitMask = CollisionBitMask.enemy
                physicsBody.collisionBitMask = CollisionBitMask.enemy
                
                var randMovement = Double.random(in: -1.0...1.0)
                
                while randMovement == 0.0 {
                    randMovement = Double.random(in: -1.0...1.0)
                }
                
                node.userData = ["direction": randMovement]
                node.name = "enemy"
                
                if randMovement < 0.0 {
                    node.animateEnemy(state: "run-doleva")
                } else {
                    node.animateEnemy(state: "run-doprava")
                }
                
            case .collectible:
                physicsBody.contactTestBitMask = CollisionBitMask.player
                physicsBody.collisionBitMask = CollisionBitMask.collectible
                
            case .decoration(_):
                physicsBody.contactTestBitMask = CollisionBitMask.decoration
                physicsBody.collisionBitMask = CollisionBitMask.decoration
                
            case .spike:
                physicsBody.contactTestBitMask = CollisionBitMask.player
                physicsBody.collisionBitMask = CollisionBitMask.spike
                
            case .movingBox(_):
                physicsBody.contactTestBitMask = CollisionBitMask.movingBox
                physicsBody.collisionBitMask = CollisionBitMask.movingBox
                
            case .lava(_):
                physicsBody.contactTestBitMask = CollisionBitMask.lava
                physicsBody.collisionBitMask = CollisionBitMask.lava
                
                
            case .final:
                physicsBody.contactTestBitMask = CollisionBitMask.final
                physicsBody.collisionBitMask = CollisionBitMask.final
                
            default:
                break
            }
            
            physicsBody.isDynamic = type.isDynamic
            physicsBody.categoryBitMask = type.categoryBitMask
            physicsBody.friction = 0.0
            physicsBody.linearDamping = 0.1
            physicsBody.restitution = 0.0
            physicsBody.allowsRotation = false
            
            node.physicsBody = physicsBody
        }
        
        
        // Pokud je to collectible, přidáme animaci
        if type == .collectible {
            animateCollectible(node)
        }
        
        return node
    }
    
    // Funkce pro animaci collectibles
    static func animateCollectible(_ node: SKNode) {
        var textures: [SKTexture] = []
        for i in 0...11 {
            let textureName = "coin_0\(i)"
            textures.append(SKTexture(imageNamed: textureName))
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1, resize: false, restore: true)
        let repeatForever = SKAction.repeatForever(animation)
        node.run(repeatForever)
    }
}
