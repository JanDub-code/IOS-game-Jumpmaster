//
//  LevelBuilder.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//
import SpriteKit

class LevelBuilder {
    private let prefabSize: CGSize
    private let scene: SKScene
    
    init(scene: SKScene, tileSize: CGFloat = 16.0) {
        self.scene = scene
        self.prefabSize = CGSize(width: tileSize, height: tileSize)
    }
    
    func buildLevel(withPrefabs prefabSequence: [Int]) {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        
        // Určujeme šířku a výšku scény podle landscape orientace
        _ = scene.size.width
        _ = scene.size.height
        
        // Výpočet výšky levelu na základě počtu prefabů
        _ = CGFloat(prefabSequence.count) * prefabSize.height
        currentY = 0 // Chceme začít na spodní části obrazovky
        
        for prefabIndex in prefabSequence {
            guard let prefab = PrefabManager.prefabs[prefabIndex] else { continue }
            placePrefab(prefab, at: CGPoint(x: currentX, y: currentY))
            currentX += CGFloat(prefab[0].count) * prefabSize.width
        }
    }
    
    private func placePrefab(_ prefab: [[TileType]], at startPosition: CGPoint) {
        let currentX = startPosition.x + 6
        // puvodní stav
        //var currentY = startPosition.y + 10
        let currentY = startPosition.y + 100

        for (y, row) in prefab.enumerated() {
            for (x, tileType) in row.enumerated() {
                let position = CGPoint(
                    x: currentX + CGFloat(x) * prefabSize.width,
                    y: currentY + CGFloat(prefab.count - y - 1) * prefabSize.height
                )
                
                if let node = PrefabManager.createNode(for: tileType, at: position) {
                    scene.addChild(node)
                }
            }
        }
    }
}
