//
//  OnboardingScreen.swift
//  IOS17-Swift
//
//  Created by xqsadness on 04/07/2024.
//

import SwiftUI

struct OnBoardingScreen: View {
    // Intros Data
    @State var intros: [Intro] = [
        Intro(title: "", subTitle: "Welcome", description: "Experience the joy of music, a lifelong journey that soothes the soul and uplifts the spirit.", pic: "pic1", color: LinearGradient(colors: [Color.cyan, Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)),
        Intro(title: "", subTitle: "Relax with Music", description: "Immerse yourself in our curated playlists designed to help you relax and unwind.", pic: "pic2", color: LinearGradient(colors: [Color.indigo, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)),
        Intro(title: "", subTitle: "Daily Tunes", description: "Start your day on a high note with our daily music selections tailored for every mood.", pic: "pic3", color: LinearGradient(colors: [Color.cyan, Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)),
        Intro(title: "Healthy with Music", subTitle: "Stay Healthy with Music", description: "Boost your wellbeing with regular listening sessions designed to keep you healthy and happy.", pic: "pic4", color: LinearGradient(colors: [Color.indigo, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
    ]
    
    // Gesture Properties
    @GestureState var isDragging: Bool = false
    
    @State var fakeIndex: Int = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            ForEach(intros.indices.reversed(), id: \.self) { index in
                IntroView(intro: intros[index])
                // Custom Liquid Shape
                    .clipShape(LiquidShape(offset: intros[index].offset, curvePoint: currentIndex == intros.count - 3 ? 0 : (fakeIndex == index ? 50 : 0)))
                    .padding(.trailing, currentIndex == intros.count - 3 ? 0 : (fakeIndex == index ? 15 : 0))
                    .ignoresSafeArea()
            }
            
            HStack(spacing: 10){
                ForEach(0..<intros.count - 2, id: \.self){ index in
                    Circle()
                        .fill(currentIndex == index ? .white : .gray)
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentIndex == index ? 1.15 : 0.85)
                        .opacity(currentIndex == index ? 1 : 0.25)
                }
                
                Spacer()
                
                Button{
                    withAnimation(.spring()) {
                        if currentIndex == intros.count - 3 {
                            // Handle "Get Started" action
                            print("Get Started")
                        } else {
                            intros[fakeIndex].offset.width = -getRect().height * 1.5
                            
                            fakeIndex += 1
                            
                            if currentIndex == intros.count - 3 {
                                currentIndex = 0
                            } else {
                                currentIndex += 1
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if fakeIndex == (intros.count - 2) {
                                    for index in 0..<intros.count - 2 {
                                        intros[index].offset = .zero
                                    }
                                    fakeIndex = 0
                                }
                            }
                        }
                    }
                }label: {
                    Text(currentIndex == intros.count - 3 ? "Get Started" : "Next")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .overlay(alignment: .topTrailing){
            Image(systemName: currentIndex == intros.count - 3 ? "" : "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(width: 50, height: 50)
                .foregroundStyle(.white)
                .contentShape(Rectangle())
            
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { value, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.5)){
                                intros[fakeIndex].offset = isDragging ? value.translation : .zero
                            }
                        })
                        .onEnded{ value in
                            withAnimation(.spring()){
                                if -intros[fakeIndex].offset.width > getRect().width / 2{
                                    intros[fakeIndex].offset.width = -getRect().height * 1.5
                                    
                                    fakeIndex += 1
                                    
                                    if currentIndex == intros.count - 3{
                                        currentIndex = 0
                                    }else{
                                        currentIndex += 1
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                                        if fakeIndex == (intros.count - 2){
                                            for index in 0..<intros.count - 2{
                                                intros[index].offset = .zero
                                            }
                                            fakeIndex = 0
                                        }
                                    }
                                }else{
                                    intros[fakeIndex].offset = .zero
                                }
                            }
                        }
                )
                .ignoresSafeArea()
                .offset(y: (80 + 25) - getSafeArea().top)
                .opacity(isDragging ? 0 : 1)
                .animation(.linear, value: isDragging)
        }
        .onAppear{
            guard let first = intros.first else { return }
            guard var last = intros.last else { return }
            
            last.offset.width = -getRect().height * 1.5
            
            intros.append(first)
            intros.insert(last, at: 0)
            
            fakeIndex = 1
        }
    }
    
    // IntroView Builder
    @ViewBuilder
    func IntroView(intro: Intro) -> some View {
        ZStack {
            Image(intro.pic)
                .resizable()
                .ignoresSafeArea()
            
            Rectangle()
                .foregroundColor(.black.opacity(0.4))
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(intro.title)
                    .font(.system(size: 50, weight: .bold))
                    .hidden()
                
                Text(intro.subTitle)
                    .font(.system(size: 50, weight: .bold))
                
                Text(intro.description)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.top)
//                    .frame(width: getRect().width - 100)
                    .lineSpacing(0)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding([.trailing, .top])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(intro.color)
    }
}

#Preview {
    OnBoardingScreen()
}
