//
//  HackerTextEffectView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 30/05/2024.
//

import SwiftUI

fileprivate enum TransitionType: String, Identifiable, CaseIterable {
    case interpolate
    case identity
    case numericText
    
    var id: String { self.rawValue }
    
    // Map TransitionType to ContentTransition
    var contentTransition: ContentTransition {
        switch self {
        case .interpolate:
            return .interpolate
        case .identity:
            return .identity
        case .numericText:
            return .numericText()
        }
    }
}
struct HomeHackerTextEffectView: View {
    
    @State private var text: String = "Hello world!"
    @State private var trigger: Bool = false
    @State private var selectedTransition: TransitionType = .interpolate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Spacer()
            
            HackerTextEffectView(
                text: text,
                trigger: trigger,
                transition: selectedTransition.contentTransition,
                speed: 0.06
            )
            .font(.largeTitle).bold()
            .lineLimit(2)
            
            Picker("Transition", selection: $selectedTransition) {
                Text("Interpolate").tag(TransitionType.interpolate)
                Text("Identity").tag(TransitionType.identity)
                Text("Numeric Text").tag(TransitionType.numericText)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 10)
            
            Spacer()
            
            Button{
                if text == "Hello world!"{
                    text = "This is hacker\ntext view"
                }else if text == "This is hacker\ntext view"{
                    text = "I am xqsadness"
                }else{
                    text = "Hello world!"
                }
                trigger.toggle()
            }label: {
                Text("Trigger")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 2)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HackerTextEffectView: View {
    
    //Config
    var text: String
    var trigger: Bool
    var transition: ContentTransition = .interpolate
    var duration: CGFloat = 1.0
    var speed: CGFloat = 0.1
    //view props
    @State private var animatedText: String = ""
    @State private var randomCharacters: [Character] = {
        let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
        return Array(string)
    }()
    @State private var animationID: String = UUID().uuidString
    
    var body: some View {
        Text(animatedText)
            .fontDesign(.monospaced)
            .truncationMode(.tail)
            .contentTransition(transition)
            .animation(.easeInOut(duration: 0.1), value: animatedText)
            .onAppear{
                guard animatedText.isEmpty else { return }
                setRandomCharacter()
                animateText()
            }
            .customOnchange(value: trigger) { newValue in
                animateText()
            }
            .customOnchange(value: text) { newValue in
                animatedText = text
                animationID = UUID().uuidString
                setRandomCharacter()
                animateText()
            }
    }
    
    private func animateText(){
        let currentID = animationID
        for index in text.indices{
            let delay = CGFloat.random(in: 0...duration)
            var timeDuation: CGFloat = 0
            let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                if currentID != animationID{
                    timer.invalidate()
                }else{
                    timeDuation += speed
                    if timeDuation >= delay{
                        if text.indices.contains(index){
                            let actualCharacter = text[index]
                            replaceCharacter(at: index, character: actualCharacter)
                        }
                        timer.invalidate()
                    }else{
                        guard let randomCharacter = randomCharacters.randomElement() else { return }
                        replaceCharacter(at: index, character: randomCharacter)
                    }
                }
            }
            timer.fire()
        }
    }
    
    private func setRandomCharacter(){
        animatedText = text
        for index in animatedText.indices{
            guard let randomCharacter = randomCharacters.randomElement() else { return }
            replaceCharacter(at: index, character: randomCharacter)
        }
    }
    
    // Changes character at the given index
    func replaceCharacter(at index: String.Index, character: Character){
        guard animatedText.indices.contains(index) else { return }
        let indexCharacter = String(animatedText[index])
        
        if indexCharacter.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            animatedText.replaceSubrange(index...index, with: String(character))
        }
    }
}

fileprivate extension View{
    @ViewBuilder
    func customOnchange<T: Equatable>(value: T, result: @escaping (T) -> ()) -> some View{
        if #available(iOS 17, *){
            self
                .onChange(of: value) { oldValue, newValue in
                    result(newValue)
                }
        }else{
            self
                .onChange(of: value) { value in
                    result(value)
                }
        }
    }
}

#Preview {
    HomeHackerTextEffectView()
}
