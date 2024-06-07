//
//  ContentView.swift
//  FruitsonalityVisionOs
//
//  Created by Elena Galluzzo on 2024-06-06.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Image("Background Fruitsonality")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            VStack {
                VStack {
                    Text("Fruitsonality")
                        .font(.extraLargeTitle)
                        .foregroundStyle(.black)
                    Text("Discover your fruit personality")
                        .font(.extraLargeTitle2)
                        .foregroundStyle(.black)
                        .fontWeight(.regular)
                    }
                    .padding(40)
                    .background(.white)
                    .cornerRadius(35)
                Button {
                    Task {
                        if await openImmersiveSpace(id: "Quiz") == .opened {
                            dismiss()
                        }
                    }
                } label: {
                    Text("Play")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding()
                }
                .background(.blue)
                .cornerRadius(35)
                .padding(35)
            }
            .padding(20)
        }
       
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
