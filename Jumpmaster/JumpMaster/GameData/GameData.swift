//
//  GameData.swift
//  JumpMaster
//
//  Created by Jan Dub on 25.12.2024.
//

import Foundation
import Combine

class GameData: ObservableObject {
    private let defaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private let enemiesKilledKey = "enemiesKilled"
    private let coinsCollectedKey = "coinsCollected"
    private let levelsCompletedKey = "levelsCompleted"
    private let lastLevelSuccessKey = "lastLevelSuccess"
    private let difficultyKey = "difficulty"
    private let soundsEnabledKey = "sounds"
    private let musicEnabledKey = "music"
    private let achievementsKey = "achievements"

    private var canPlay = [true, false, false, false, false, false, false, false, false, false, false] // zatím o vždy musí být o jedno víc než je levelů
    
    private var achievements: [Achievement] = [
        Achievement(id: 1, title: "Enemy killer", text: "Kill 10 enemies", goal: 10, reward: "👾", key: "enemiesKilled"),
        Achievement(id: 2, title: "Coin collector", text: "Get 10 coins", goal: 10, reward: "🤑", key: "coinsCollected"),
        Achievement(id: 3, title: "True adventurer", text: "Complete 5 levels", goal: 5, reward: "🏆", key: "levelsCompleted"),
        Achievement(id: 4, title: "Coin master", text: "Get 50 coins", goal: 50, reward: "💰", key: "coinsCollected")
    ]
    
    init() {
        let keyToGetter: [String: () -> Int] = [
            enemiesKilledKey: getEnemiesKilled,
            coinsCollectedKey: getCoinsCollected,
            levelsCompletedKey: { self.getLevelsCompleted().filter { $0 }.count - 1}
        ]
        
        if let savedAchievementsData = defaults.data(forKey: achievementsKey),
           var savedAchievements = try? JSONDecoder().decode([Achievement].self, from: savedAchievementsData) {
            
            savedAchievements = updateAchievementsAttributes(savedAchievements: savedAchievements)
            achievements = mergeAchievements(savedAchievements, with: achievements)
        }
        
        for achievement in achievements {
            if let getter = keyToGetter[achievement.getKey()] {
                let progress = getter()
                achievement.setProgress(num: progress)
                
                if achievement.getProgress() >= achievement.getGoal() {
                    achievement.setAsCompleted()
                }
            }
        }
        
        if let encodedAchievements = try? JSONEncoder().encode(achievements) {
            defaults.set(encodedAchievements, forKey: achievementsKey)
        }
        
        if let savedArray = defaults.array(forKey: levelsCompletedKey) as? [Bool] {
            canPlay = savedArray
        } else {
            defaults.set(canPlay, forKey: levelsCompletedKey)
        }
        
        if defaults.object(forKey: soundsEnabledKey) == nil {
                defaults.set(true, forKey: soundsEnabledKey)
            }
            
            if defaults.object(forKey: musicEnabledKey) == nil {
                defaults.set(true, forKey: musicEnabledKey)
            }
    }
    
    private func mergeAchievements(_ saved: [Achievement], with newAchievements: [Achievement]) -> [Achievement] {
        var achievementDict = Dictionary(uniqueKeysWithValues: saved.map { ($0.getId(), $0) })
        
        for (index, _) in achievementDict {
            var isDeleted = true
            
            for achievement in achievements {
                if achievementDict[index]?.getId() == achievement.getId() {
                    isDeleted = false
                }
            }
            
            if isDeleted {
                achievementDict[index] = nil
            }
        }
        
        for achievement in newAchievements {
            if achievementDict[achievement.getId()] == nil {
                achievementDict[achievement.getId()] = achievement
            }
        }
        
        return Array(achievementDict.values)
    }
    
    
    func updateAchievementsAttributes(savedAchievements: [Achievement])  -> [Achievement] {
        for savedAchievement in savedAchievements {
            for achievement in achievements {
                if achievement.getId() == savedAchievement.getId() {
                    savedAchievement.setText(text: achievement.getText())
                    savedAchievement.setGoal(num: achievement.getGoal())
                    savedAchievement.setReward(rew: achievement.getReward())
                    savedAchievement.setTitle(title: achievement.getTitle())
                    
                    if savedAchievement.getProgress() >= savedAchievement.getGoal() {
                        savedAchievement.setAsCompleted()
                    }
                    
                }
            }
        }
        
        return savedAchievements
    }
    // MARK: - Setters
    
    func setEnemiesKilled(_ count: Int) {
        defaults.set(count, forKey: enemiesKilledKey)
        
        updateAchievements(key: enemiesKilledKey, progress: getEnemiesKilled())
    }
    
    func setCoinsCollected(_ count: Int) {
        defaults.set(count, forKey: coinsCollectedKey)
        
        updateAchievements(key: coinsCollectedKey, progress: getCoinsCollected())
    }
    
    func setLevelCompleted(_ index: Int) {
        if index < canPlay.count {
            
            canPlay[index] = true
            defaults.set(canPlay, forKey: levelsCompletedKey)
        }
        
        
        updateAchievements(key: levelsCompletedKey, progress: getLevelsCompleted().filter { $0 }.count - 1)
    }
    
    func setLastLevelSuccess(_ success: Bool) {
        defaults.set(success, forKey: lastLevelSuccessKey)
    }
    
    func addEnemiesKilled(_ count: Int) {
        let currentCount = defaults.integer(forKey: enemiesKilledKey)
        defaults.set(currentCount + count, forKey: enemiesKilledKey)
        
        updateAchievements(key: enemiesKilledKey, progress: getEnemiesKilled())
    }
    
    func addCoinsCollected(_ count: Int) {
        let currentCount = defaults.integer(forKey: coinsCollectedKey)
        defaults.set(currentCount + count, forKey: coinsCollectedKey)
        
        updateAchievements(key: coinsCollectedKey, progress: getCoinsCollected())
    }
    
    // Set difficulty
    func setDifficulty(_ difficulty: String) {
        defaults.set(difficulty, forKey: difficultyKey)
    }
    
    // MARK: - Getters
    
    func getEnemiesKilled() -> Int {
        return defaults.integer(forKey: enemiesKilledKey)
    }
    
    func getCoinsCollected() -> Int {
        return defaults.integer(forKey: coinsCollectedKey)
    }
    
    func getLevelsCompleted() -> [Bool] {
        if let savedArray = defaults.array(forKey: levelsCompletedKey) as? [Bool] {
            return savedArray
        }
        defaults.set(canPlay, forKey: levelsCompletedKey)
        
        return canPlay
    }
    
    func wasLastLevelSuccessful() -> Bool {
        return defaults.bool(forKey: lastLevelSuccessKey)
    }
    
    // Get difficulty
    func getDifficulty() -> String {
        return defaults.string(forKey: difficultyKey) ?? "easy" // Default is "easy"
    }
    
    func getSoundsEnabled() -> Bool {
        return defaults.bool(forKey: soundsEnabledKey) // Default is "easy"
    }
    
    func getMusicEnabled() -> Bool {
        return defaults.bool(forKey: musicEnabledKey) // Default is "easy"
    }
    
    func setSoundsEnabled(_ soundsEnabled: Bool) {
        defaults.set(soundsEnabled, forKey: soundsEnabledKey)
    }
    
    func setMusicEnabled(_ musicEnabled: Bool) {
        defaults.set(musicEnabled, forKey: musicEnabledKey)
    }
    
    func getAchievements() -> [Achievement] {
        if let data = defaults.data(forKey: achievementsKey),
           let achievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            return achievements
        }
        return achievements
    }
    
    func updateAchievements(key: String, progress: Int) {
        for achievement in achievements {
            if achievement.getKey() == key {
                achievement.setProgress(num: progress)
                
                if achievement.getProgress() >= achievement.getGoal() {
                    achievement.setAsCompleted()
                }
            }
        }

        if let encodedAchievements = try? JSONEncoder().encode(achievements) {
            defaults.set(encodedAchievements, forKey: achievementsKey)
        }
    }
    
    // MARK: - Reset All Data
    
    func resetGameData() {
        canPlay = [true, false, false, false, false, false, false, false, false, false, false]
        
        for achievement in achievements {
            achievement.setProgress(num: 0)
            achievement.setAsCompletedManually(compl: false)
        }
        
        defaults.set(0, forKey: enemiesKilledKey)
        defaults.set(0, forKey: coinsCollectedKey)
        defaults.set(canPlay, forKey: levelsCompletedKey)
        defaults.set(false, forKey: lastLevelSuccessKey)
        defaults.set("easy", forKey: difficultyKey)
        defaults.set(true, forKey: soundsEnabledKey)
        defaults.set(true, forKey: musicEnabledKey)
        
        if let encodedAchievements = try? JSONEncoder().encode(achievements) {
            defaults.set(encodedAchievements, forKey: achievementsKey)
        }
    }
}
