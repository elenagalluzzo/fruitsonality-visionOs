//
//  FruitQuizModel.swift
//  FruitsonalityVisionOs
//
//  Created by Elena Galluzzo on 2024-06-06.
//

import Foundation
import Combine
import RealityKit
import SwiftUI

enum Results: String {
    case clementine = "Cool Clementine"
    case apple = "Angry Apple"
    case strawberry = "Sweet Strawberry"
    case blueberry = "Blue Blueberry"
}

class FruitQuizViewModel: ObservableObject  {
   
    @Published var questionNumber = 0
    
    @Published var answersArray = [String]()
    @Published var isQuizEnded = false
    @Published var questionLabel = "You have ran into a friend. How do you greet them?"
    @Published var option1Button = "Sup."
    @Published var option2Button = "I don’t want to talk!"
    @Published var option3Button = "It’s nice to see you!"
    @Published var option4Button = "Sobs"

    
    @Published var answer = Results.clementine
    @Published var modelAnswer: ModelEntity?
    @Published var addAnswer: Bool = false
    
    var buttons: [ModelEntity] = []
    
    let quizQuestions = [
        QuizModel(
            question: "You have ran into a friend. How do you greet them?",
            option1: "Sup.",
            option2: "I don’t want to talk!",
            option3: "It’s nice to see you!",
            option4: "Sobs"
        ),
        QuizModel(
            question: "You are getting lunch with your friend. What do you order?",
            option1: "Filet mignon.",
            option2: "Nothing..",
            option3: "Red velvet cake.",
            option4: "Ice cream."
        ),
        QuizModel(
            question: "Your friend told you about their break-up. How do you comfort them?",
            option1: "Their loss.",
            option2: "I don’t care.",
            option3: "I’m so sorry!",
            option4: "Cry with them"
        ),
        QuizModel(
            question: "The waiter has brought the bill. How do you react?",
            option1: "This one’s on me.",
            option2: "Don't look at me.",
            option3: "I got it!.",
            option4: "My wallet was stolen."
        ),
        QuizModel(
            question: "You and your friend are parting ways. How do you say goodbye?",
            option1: "I gotta bounce.",
            option2: "Don’t contact me again.",
            option3: "Nice meeting you!",
            option4: "Sobs. They all leave."
        )
    
    ]
    
    func createButton(text: String, index: Int) -> ModelEntity {
//        let box = MeshResource.generateBox(size: [0.3, 0.1, 0.2])
//        let material = SimpleMaterial(color: .systemBlue, isMetallic: false)
//        let model = ModelEntity(mesh: box, materials: [material])
        let textMesh = MeshResource.generateText(text, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        let textMaterial = SimpleMaterial(color: .systemBlue, isMetallic: false)
        let textModel = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textModel.position = [0, 0.00, 0.00]
        

        
        textModel.generateCollisionShapes(recursive: true)
        textModel.components.set(InputTargetComponent())
        textModel.components.set(HoverEffectComponent())
//        model.look(at: [0,1.25,0], from: model.position, relativeTo: nil, forward: .positiveZ)
        textModel.name = String(index)
        
        return textModel
    }
    
    func getCurrentQuestion() -> String {
        return quizQuestions[questionNumber].question
    }
    
    func getOption1() -> String {
        return quizQuestions[questionNumber].option1
    }
    
    func getOption2() -> String {
        return quizQuestions[questionNumber].option2
    }
    
    func getOption3() -> String {
        return quizQuestions[questionNumber].option3
    }
    
    func getOption4() -> String {
        return quizQuestions[questionNumber].option4
    }
    
    func nextQuestion() {
        if questionNumber < quizQuestions.count - 1 {
            questionNumber += 1
            if questionNumber == quizQuestions.count - 1 {
                isQuizEnded = true
            }
        }
    }
    
    func optionPressed(index: Int) {
        if isQuizEnded {
            endQuiz()
        } else {
            nextQuestion()
        }
        updateQuestion()
        trackAnswers(chosenOption: index)
    }
    
    func trackAnswers(chosenOption: Int) {
        if chosenOption == 0 {
            answersArray.append("option1")
        } else if chosenOption == 1 {
            answersArray.append("option2")
        } else if chosenOption == 2 {
            answersArray.append("option3")
        } else {
            answersArray.append("option4")
        }
    }

    func updateQuestion() {
        questionLabel = getCurrentQuestion()
        option1Button = getOption1()
        option2Button = getOption2()
        option3Button = getOption3()
        option4Button = getOption4()
        let nextTextMesh1 = MeshResource.generateText(option1Button, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        buttons[0].model?.mesh = nextTextMesh1
        let nextTextMesh2 = MeshResource.generateText(option2Button, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        buttons[1].model?.mesh = nextTextMesh2
        let nextTextMesh3 = MeshResource.generateText(option3Button, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        buttons[2].model?.mesh = nextTextMesh3
        let nextTextMesh4 = MeshResource.generateText(option4Button, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        buttons[3].model?.mesh = nextTextMesh4
    }
    
    func getResult() {
        let countedSet = NSCountedSet(array: answersArray)
        let mostFrequent = countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) }
        if mostFrequent as? String == "option1"{
        } else if mostFrequent as? String == "option2"{
            answer = .apple
        } else if mostFrequent as? String == "option3" {
            answer = .strawberry
        } else {
            answer = .blueberry
        }
    }
    
    func endQuiz() {
        buttons.forEach { $0.removeFromParent() }
        questionLabel = "You are ..."
        getResult()
        let sphere = MeshResource.generateSphere(radius: 20)
        guard let texture =  try? TextureResource.load(named: answer.rawValue) else {
            print("Failed to load image")
            return
        }

        
        var material = SimpleMaterial()
        material.baseColor = MaterialColorParameter.texture(texture)
        
        let model = ModelEntity(mesh: sphere, materials: [material])
        
//        let anchor = AnchorEntity(world: [0, 0, 0])
//        anchor.addChild(model)
        
        model.position = SIMD3(x: 0, y: 1, z:0)
       

        
//        model.setParent(anchor)
        model.generateCollisionShapes(recursive: true)
        
        let spin = model.transform.rotation * simd_quatf(angle: .pi, axis: [0, 1, 0])
        let rotation = model.move(to: Transform(scale: .one, rotation: spin, translation: model.transform.translation), relativeTo: model.parent, duration: 10, timingFunction: .linear)
        self.modelAnswer = model
        addAnswer = true
        
    }
    
    func resetFruitModel() {
        updateQuestion()
    }
}
