//
//  FruitsonalityVisionOsApp.swift
//  FruitsonalityVisionOs
//
//  Created by Elena Galluzzo on 2024-06-06.
//

import SwiftUI

@main
struct FruitsonalityVisionOsApp: App {
    @StateObject var fruitQuizViewModel: FruitQuizViewModel = FruitQuizViewModel()
    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
        }

        ImmersiveSpace(id: "Quiz") {
            ImmersiveView()
                .environmentObject(fruitQuizViewModel)
        }
    }
}
