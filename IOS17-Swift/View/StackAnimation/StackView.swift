//
//  StackView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 1/10/24.
//

import SwiftUI

struct DataModel{
    var title: String
    var isCompleted: Bool = false
}

struct StackView: View {
    @State private var tasks: [DataModel] = [
        DataModel(title: "Task 1"),
        DataModel(title: "Task 2"),
        DataModel(title: "Task 3"),
        DataModel(title: "Task 4"),
        DataModel(title: "Task 5"),
    ]
    @State private var show = false
    var Tcolor: Color
    var color: Color
    var icon: String
    var title: String
    var completedTasks: Int {
        tasks.filter { $0.isCompleted } .count
    }
    var progress: Double {
        tasks.isEmpty ? 0 : Double(completedTasks) / Double(tasks.count)
    }
    var body: some View {
        ZStack{
            VStack(spacing: 12){
                ForEach(tasks.indices, id: \.self) { index in
                    let task = tasks[index]
                    let scaleValue = 1.0 - (CGFloat(index) * 0.02)
                    let opacityValue = 1.0 - (CGFloat(index) * 0.2)
                    
                    HStack {
                        Text(task.title).strikethrough(task.isCompleted, color: .white)
                        Spacer()
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2).contentTransition(.symbolEffect)
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .opacity(show ? 1 : 0)
                    .background(color, in: .rect(cornerRadius: 12))
                    .scaleEffect(show ? 1 : scaleValue)
                    .opacity(show ? 1 : opacityValue)
                    .offset(y: CGFloat(show ? 0 * index : -56 * index))
                    .onTapGesture {
                        withAnimation {
                            tasks[index].isCompleted.toggle()
                        }
                    }
                }
            }
            .frame(height: show ? nil : 50, alignment: .top)
            .padding(.top, show ? 68 : 5)
            .overlay(alignment: .top) {
                HStack {
                    Image(systemName: icon)
                    Text(title)
                    Spacer()
                    ProgressV(progress: progress)
                }
                .bold().foregroundStyle(.white)
                .frame(height: 52)
                .padding(.horizontal)
                .background(Tcolor, in: .rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 2.5)
                }
                .onTapGesture {
                    withAnimation {
                        show.toggle()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    StackAnimation()
}

struct ProgressV: View {
    var progress: Double
    var lineWidth: CGFloat = 3
    var circleSize: CGFloat = 20
    var body: some View {
        ZStack {
            let strokeColor = progress >= 1.0 ? Color.green : Color.white
            Circle()
                .trim(from: 0, to: progress)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
        }
    }
}
