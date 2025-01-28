//
//  Untitled.swift
//  JumpMaster
//
//  Created by Dejw on 19.01.2025.
//

import Foundation

class Achievement: Codable, Identifiable {
    internal var id: Int
    private var title: String
    private var text: String
    private var goal: Int
    private var progress: Int = 0
    private var completed = false
    private var reward: String
    private var key: String
    
    
    init(id: Int, title: String, text: String, goal: Int, reward: String, key: String) {
        self.id = id
        self.title = title
        self.text = text
        self.goal = goal
        self.reward = reward
        self.key = key
        self.key = key
    }
    
    func setAsCompleted() {
        self.completed = true
    }
    
    func setAsCompletedManually(compl: Bool) {
        self.completed = compl
    }
    
    func setProgress(num: Int) {
        self.progress = num
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setText(text: String) {
        self.text = text
    }
    
    func setGoal(num: Int) {
        self.goal = num
    }
    
    func setReward(rew: String) {
        self.reward = rew
    }
    
    func setKey(num: Int) {
        self.progress = num
    }
    
    func getProgress() -> Int {
        return self.progress
    }
    
    func getGoal() -> Int {
        return self.goal
    }
    
    func getText() -> String {
        return self.text
    }
    
    func getKey() -> String {
        return self.key
    }
    
    func getReward() -> String {
        return self.reward
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getCompleted() -> Bool {
        return self.completed
    }
    
    func getId() -> Int {
        return self.id
    }
    
}

