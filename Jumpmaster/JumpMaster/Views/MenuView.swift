import SwiftUI
import SpriteKit

struct MenuView: View {
    @StateObject private var gameData = GameData()
    
    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 20) {
                    MenuButton(icon: "🎮", title: "Start", isNavigating: true, destination: AnyView(LevelSelectionView(gameData: gameData)))
                    MenuButton(icon: "⚙️", title: "Settings", isNavigating: true, destination: AnyView(DifficultySettingsView(gameData: gameData)))
                    MenuButton(icon: "🎮", title: "Game Stats", isNavigating: true, destination: AnyView(GameStatsView(gameData: gameData)))
                    MenuButton(icon: "🏆", title: "Achievements", isNavigating: true, destination: AnyView(AchievementsView(gameData: gameData)))
                    MenuButton(icon: "❌", title: "Quit", iconColor: .red, isNavigating: false, action: { exit(0) })
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MenuButton: View {
    var icon: String
    var title: String
    var iconColor: Color = .white
    var isNavigating: Bool
    var destination: AnyView? = nil
    var action: (() -> Void)? = nil
    
    
    var body: some View {
        if isNavigating {
            NavigationLink(destination: destination) {
                ButtonContent(icon: icon, title: title, iconColor: iconColor)
            }
        } else {
            Button(action: {
                action!()
            }) {
                ButtonContent(icon: icon, title: title, iconColor: iconColor)
            }
        }
    }
}

struct ButtonContent: View {
    var icon: String
    var title: String
    var iconColor: Color
    
    var body: some View {
        HStack {
            Text(icon)
            
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .frame(width: 300, height: 50)
        .background(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
