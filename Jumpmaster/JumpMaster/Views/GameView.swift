//
//  GameView.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//

import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    let scene: SKScene
    @Environment(\.dismiss) var dismiss
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}
