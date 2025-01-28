import SwiftUI
import SpriteKit

struct LevelSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedLevel: Int? = nil
    @State private var levelsCompleted: [Bool] = []
    @StateObject var gameData: GameData
    @State private var showGameScene = false // State to trigger GameView
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255 / 255, green: 119 / 255, blue: 96 / 255),
                    Color(red: 255 / 255, green: 179 / 255, blue: 78 / 255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Level buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        if levelsCompleted.count > 0 {
                            ForEach(1...10, id: \.self) { level in
                                levelButton(level: level, levels: levelsCompleted)
                            }
                        }
                    }
                    .padding()
                    .background(Color(red: 11 / 255, green: 1 / 255, blue: 1 / 255, opacity: 0.5))
                }
                .ignoresSafeArea()
                
                // Selected level display
                if let level = selectedLevel {
                    Text("Selected Level: \(level)")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                } else {
                    Text("Select a Level")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
                
                // Start level button
                if selectedLevel != nil {
                    Button(action: {
                        showGameScene = true
                    }) {
                        HStack {
                            Text("Start Level")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 200, height: 60)
                                .background(Color.green)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                    .fullScreenCover(isPresented: $showGameScene, onDismiss: {
                        // Reload levels when returning
                        levelsCompleted = gameData.getLevelsCompleted()
                    }) {
                        if let level = selectedLevel {
                            GameView(scene: getGameScene(for: level))
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                }
                
                // Bottom buttons
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back to menu")
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            // Load levels completed when the view appears
            levelsCompleted = gameData.getLevelsCompleted()
        }
        .navigationBarHidden(true)
    }
    
    private func levelButton(level: Int, levels: [Bool]) -> some View {
        let canPlayLevel = levels[level - 1]
        return Button(action: {
            if canPlayLevel {
                selectedLevel = level
            }
        }) {
            Text("Level \(level)")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .frame(width: 120, height: 60)
                .background(selectedLevel == level ? Color(red: 235 / 255, green: 43 / 255, blue: 0 / 255) : canPlayLevel ? Color(red: 246 / 255, green: 140 / 255, blue: 33 / 255) : Color(red: 140 / 255, green: 130 / 255, blue: 130 / 255))
                .cornerRadius(15)
                .shadow(radius: 5)
        }
    }
    
    // Helper function to retrieve the game scene for a level
    private func getGameScene(for level: Int) -> SKScene {
        let difficulty = gameData.getDifficulty() // Retrieve the selected difficulty
        
        // Define camera speed based on difficulty
        let cameraSpeed: CGFloat
        switch difficulty {
        case "easy":
            cameraSpeed = 17
        case "medium":
            cameraSpeed = 25
        case "hard":
            cameraSpeed = 40
        default:
            cameraSpeed = 15 // Default to medium if no difficulty is set
        }
        
        switch level {
        case 1: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,1,2,3,4,5,11,6], levelNum: 1, gameData: gameData, backgroundName: "background1")
        case 2: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,4,3,5,1,2,7,12,6], levelNum: 2, gameData: gameData, backgroundName: "background2")
        case 3: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,8,9,10,13,5,7,6], levelNum: 3, gameData: gameData, backgroundName: "background3")
        case 4: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,11,1,12,4,13,5,6], levelNum: 4, gameData: gameData, backgroundName: "background2")
        case 5: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,12,2,11,5,14,1,14,6], levelNum: 5, gameData: gameData, backgroundName: "background1")
        case 6: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,4,3,8,9,10,11,6], levelNum: 6, gameData: gameData, backgroundName: "background3")
        case 7: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,13,3,14,4,1,6], levelNum: 7, gameData: gameData, backgroundName: "background1")
        case 8: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,14,4,13,7,2,3,6], levelNum: 8, gameData: gameData, backgroundName: "background2")
        case 9: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,11,5,13,14,4,5,6], levelNum: 9, gameData: gameData, backgroundName: "background3")
        case 10: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,7,1,4,2,8,9,10,6], levelNum: 10, gameData: gameData, backgroundName: "background1")
        default: return GameScene(size: CGSize(width: 480, height: 270),cameraSpeed: cameraSpeed,levelSequence: [0,2,4], levelNum: 1, gameData: gameData, backgroundName: "background1")
        }
    }
}
