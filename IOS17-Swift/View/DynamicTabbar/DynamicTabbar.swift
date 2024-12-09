//
//  DynamicTabbar.swift
//  IOS17-Swift
//
//  Created by xqsadness on 19/11/24.
//

import SwiftUI

struct TabModel: Identifiable {
    var id = UUID()
    var icon: String
    var title: String
}

struct DynamicTabbar: View {
    var taps: [TabModel] = [
        TabModel(icon: "person", title: "Accounts"),
        TabModel(icon: "house", title: "Home"),
        TabModel(icon: "creditcard", title: "Payments"),
        TabModel(icon: "arrow.right.arrow.left", title: "Transfers")
    ]
    
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            redView()
                .tag(0)
            blueView()
                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                .tag(1)
            greenView()
                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                .tag(2)
            grayView()
                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                .tag(3)
        }
//        GeometryReader { geo in
//            HStack(spacing: 0) {
//                redView()
//                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                blueView()
//                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                greenView()
//                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                grayView()
//                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//            }
//            .offset(x: -geo.size.width * CGFloat(selectedTab))
//        }
        .overlay(alignment: .bottom) {
            HStack {
                ForEach(taps.indices, id: \.self) { tap in
                    HStack(spacing: 14) {
                        Image(systemName: taps[tap].icon)
                        // Now selectedTab is
                        if selectedTab == tap {
                            Text(taps[tap].title).bold()
                                .transition(.scale(scale: 0, anchor: .trailing).combined(with: .opacity))
                        }
                    }
                    .font(.title2)
                    .frame(maxWidth: selectedTab == tap ? .infinity : 55)
                    .frame(height: 55)
                    .background(Color(.systemGray6), in: .rect(cornerRadius: 12))
                    .clipped()
                    .onTapGesture {
                        withAnimation {
                            selectedTab = tap
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    DynamicTabbar()
}

struct redView: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            Text("YellowView").font(.largeTitle)
        }
    }
}
struct blueView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Text("YellowView").font(.largeTitle)
        }
    }
}
struct greenView: View {
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Text("YellowView").font(.largeTitle)
        }
    }
}
struct grayView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            Text("YellowView").font(.largeTitle)
        }
    }
}

struct yellowView: View {
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            Text("YellowView").font(.largeTitle)
        }
    }
}
