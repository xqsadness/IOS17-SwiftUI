//
//  Animation.swift
//  IOS17-Swift
//
//  Created by darktech4 on 30/11/2023.
//

import SwiftUI

struct AnimationView: View {
    @State var isShow = false
    var body: some View {
        VStack{
            if isShow{
                Rectangle()
                    .fill(.red.gradient)
                    .frame(width: 150,height: 150)
                    .transition(MyTransition())
            }
            
            Button("ShowView") {
                withAnimation(.init(MyAnimation())){
                    isShow.toggle()
                }
            }
        }
    }
}

#Preview {
    AnimationView()
}

struct MyTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .rotation3DEffect(
                .init(degrees: phase.value * (phase == .willAppear ? 90 : -90)),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
    }
}

struct MyAnimation: CustomAnimation{
    var duration: CGFloat = 1
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        if time > duration {return nil }
        return value.scaled(by: time)
    }
}
