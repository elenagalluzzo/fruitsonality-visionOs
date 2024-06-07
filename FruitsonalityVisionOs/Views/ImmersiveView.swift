//
//  ImmersiveView.swift
//  FruitsonalityVisionOs
//
//  Created by Elena Galluzzo on 2024-06-06.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var viewModel: FruitQuizViewModel
    
    
    var body: some View {
        RealityView { content in
            let button1 = viewModel.createButton(text: viewModel.option1Button, index: 0)
            let button2 = viewModel.createButton(text: viewModel.option2Button, index: 1)
            let button3 = viewModel.createButton(text: viewModel.option3Button, index: 2)
            let button4 = viewModel.createButton(text: viewModel.option4Button, index: 3)

            button1.position = [-0.75, 1, -1]
            button2.position = [-0.25, 1, -1]
            button3.position = [0.25, 1, -1]
            button4.position = [0.75, 1, -1]

            viewModel.buttons = [button1, button2, button3, button4]
            
            content.add(button1)
            content.add(button2)
            content.add(button3)
            content.add(button4)
            if viewModel.addAnswer {
                if let answer = viewModel.modelAnswer {
                    content.add(answer)
                }
            }
        }
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded { gesture in
                    viewModel.optionPressed(index: Int(gesture.entity.name) ?? 0)
                }
        )

        .overlay(
            VStack {
                Text(viewModel.questionLabel)
                    .font(.extraLargeTitle)
                    .padding()
                    .frame(maxWidth: .infinity, idealHeight: 50)
                    .background(Color.white)
                    .foregroundColor(.black)
                Spacer()
            }
                .padding(.top, 50)
                .offset(z: -2000)
                .offset(y: -1500)
        )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
