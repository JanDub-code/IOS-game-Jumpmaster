import SwiftUI

struct DifficultySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var selectedDifficulty: String = "easy"
    @State private var isSoundOn: Bool = true
    @State private var isMusicOn: Bool = true
    
    @StateObject var gameData: GameData
    

    
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
            
            VStack(spacing: 16) {
                Text("⚙️ Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Difficulty Section
                VStack(spacing: 10) {
                    Text("Difficulty")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    HStack(spacing: 30) {
                        DifficultyButton(title: "Easy", action: {
                            selectedDifficulty = "easy"
                            gameData.setDifficulty("easy")
                        }, selectedDificulty: selectedDifficulty == "easy")
                        
                        DifficultyButton(title: "Medium", action: {
                            selectedDifficulty = "medium"
                            gameData.setDifficulty("medium")
                        }, selectedDificulty: selectedDifficulty == "medium")
                        
                        DifficultyButton(title: "Hard", action: {
                            selectedDifficulty = "hard"
                            gameData.setDifficulty("hard")
                        }, selectedDificulty: selectedDifficulty == "hard")
                    }
                }
                
                // Sound and Music Toggles in one row
                HStack(spacing: 20) {
                    ToggleRow(title: "Sound", isOn: $isSoundOn, onChange: { isOn in
                        gameData.setSoundsEnabled(isOn)
                    })
                    
                    ToggleRow(title: "Music", isOn: $isMusicOn, onChange: { isOn in
                        gameData.setMusicEnabled(isOn)
                    })
                }
                .padding(.horizontal, 10)
                .padding(.top, 30)
                
                Spacer()
                
                // Reset and Back Buttons in one row
                HStack(spacing: 20) {
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
                        .frame(width: 180, height: 50)
                        .background(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Reset button tapped")
                        selectedDifficulty = "easy"
                        isSoundOn = true
                        isMusicOn = true
                        
                        gameData.resetGameData()
                    })  {
                        HStack {
                            Text("Reset")
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 140, height: 50)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            selectedDifficulty = gameData.getDifficulty()

            isSoundOn = gameData.getSoundsEnabled()
            isMusicOn = gameData.getMusicEnabled()
        }
        .navigationBarHidden(true)
    }
}

struct DifficultyButton: View {
    var title: String
    var action: () -> Void
    var selectedDificulty: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(width: 220, height: 50)
                .background(selectedDificulty ? Color(red: 235 / 255, green: 43 / 255, blue: 0 / 255) : Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255))
                .cornerRadius(12)
                .shadow(radius: 5)
        }
    }
}

// ToggleRow for Sound and Music switches
struct ToggleRow: View {
    var title: String
    @Binding var isOn: Bool
    var onChange: (Bool) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Toggle(isOn: $isOn) {
                    Text("") // Empty label for the toggle
                }
                .onChange(of: isOn, perform: onChange)
                .toggleStyle(SwitchToggleStyle(tint: Color.red.opacity(0.8)))
            }
            .padding()
            .background(Color(red: 255 / 255, green: 87 / 255, blue: 51 / 255, opacity: 0.8))
            .cornerRadius(12)
            .shadow(radius: 5)
            .frame(width: 170)
        }
    }
}
