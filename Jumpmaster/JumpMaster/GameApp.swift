import SwiftUI
import SpriteKit

@main
struct GameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}



