import SwiftUI
import SpriteKit

// MARK: - Splash Screen

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                MenuView()
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 236 / 255, green: 138 / 255, blue: 37 / 255),
                        Color(red: 223 / 255, green: 74 / 255, blue: 77 / 255),
                        Color(red: 154 / 255, green: 69 / 255, blue: 158 / 255)
                    ]),
                    startPoint: .bottom,
                    endPoint: .topTrailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 25) {
                    Text("JUMPMASTER")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

                    Text("Jump, enjoy and conquer world!")
                        .font(.system(size: 20, weight: .regular, design: .default)) // Base font
                        .italic() // Apply italic style
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
