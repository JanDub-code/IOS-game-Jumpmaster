//
//  DifficultySettingsView.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//

import SwiftUI

struct GameStatsView: View {
    @Environment(\.presentationMode) var presentationMode
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
            
            VStack(spacing: 30) {
                HStack {
                    Text("🎮")
                        .font(.largeTitle)
                    
                    Text("Game Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    StatsBox(label: "Levels Completed:", value: "\(String(gameData.getLevelsCompleted().filter { $0 }.count - 1))", icon: "🏆")
                        .frame(width: 450) // Narrower box
                    StatsBox(label: "Coins Collected:", value: "\(String(gameData.getCoinsCollected()))", icon: "💰")
                        .frame(width: 450) // Narrower box
                    StatsBox(label: "Enemies Killed:", value: "\(String(gameData.getEnemiesKilled()))", icon: "👾")
                        .frame(width: 450) // Narrower box
                }
                
                Button(action: {
                    dismissView()
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
                .frame(width: 200)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
    
    private func dismissView() {
        print("Dismissing view...")
        presentationMode.wrappedValue.dismiss()
    }
}

struct StatsBox: View {
    var label: String
    var value: String
    var icon: String
    
    var body: some View {
        HStack {
            Text(icon)
            Text(label)
                .foregroundColor(.white)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(red: 11 / 255, green: 1 / 255, blue: 1 / 255, opacity: 0.2))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
