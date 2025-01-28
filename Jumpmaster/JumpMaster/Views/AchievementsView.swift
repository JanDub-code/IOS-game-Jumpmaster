//
//  DifficultySettingsView.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//
import SwiftUI

struct AchievementsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var gameData: GameData
    @State private var achievements: [Achievement] = []
    @State private var achievementsOnPage: Int = 3
    @State private var counter: Int = 0
    
    private var widthOfCards: CGFloat {
        return 600 / CGFloat(achievementsOnPage)
    }
    
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
                Text("🏆 Achievements")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            counter-=achievementsOnPage
                            
                            if counter < 0 {
                                if achievements.count <= achievementsOnPage {
                                    counter = 0
                                } else {
                                    counter = achievements.count - (achievements.count % achievementsOnPage)
                                    
                                }
                            }
                        }
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                    
                    ForEach(counter..<(counter + achievementsOnPage), id: \.self) { index in
                        if(index < achievements.count) {
                            AchievementCardView(achievement: achievements[index], width: widthOfCards)
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            counter+=achievementsOnPage
                            
                            if(counter >= achievements.count) {
                                counter = 0
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                }
                .frame(height: 200)
                
                Spacer()
                
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
            }
            .padding()
        }
        .onAppear {
            achievements = gameData.getAchievements()
        }
        .navigationBarHidden(true)
    }
    
    private func dismissView() {
        print("Dismissing view...")
        presentationMode.wrappedValue.dismiss()
    }
}

struct AchievementCardView: View {
    let achievement: Achievement
    let width: CGFloat
    
    var body: some View {
        VStack {
            Text(achievement.getTitle())
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            
            Text(achievement.getText())
                .font(.subheadline)
                .foregroundColor(.white)
            
            ProgressBar(progress: CGFloat(achievement.getProgress()) / CGFloat(achievement.getGoal()) > 1.0 ? 1.0 : CGFloat(achievement.getProgress()) / CGFloat(achievement.getGoal()))
                .frame(height: 10)
            
            Text("\(String(achievement.getProgress())) / \(String(achievement.getGoal()))")
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text("\(achievement.getCompleted() ? "Reward:" : "Reward locked")")
                .font(.subheadline)
                .foregroundColor(.white)
            
            if achievement.getCompleted() {
                Text(achievement.getReward())
                    .font(.largeTitle)
            }
        }
        .padding()
        .frame(width: width, height: 170)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 11 / 255, green: 1 / 255, blue: 1 / 255, opacity: 0.2), lineWidth: 2)
        )
        
        .shadow(radius: 5)
    }
}

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color.white)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
                    .foregroundColor(Color.green)
            }
        }
    }
}
