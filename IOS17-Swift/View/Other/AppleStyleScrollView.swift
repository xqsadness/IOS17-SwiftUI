//
//  AppleStyleScrollView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 2/6/25.
//

import SwiftUI

struct CardItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

private let cardItems: [CardItem] = [
    CardItem(
        imageName: "jj1",
        title: "Lorem Ipsum 1",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    ),
    CardItem(
        imageName: "jj2",
        title: "     2",
        description: "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    ),
    CardItem(
        imageName: "jj3",
        title: "Lorem Ipsum 3",
        description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco."
    ),
    CardItem(
        imageName: "jj4",
        title: "Lorem Ipsum 4",
        description: "Duis aute irure dolor in reprehenderit in voluptate velit esse."
    ),
    CardItem(
        imageName: "test-img",
        title: "Lorem Ipsum 5",
        description: "Excepteur sint occaecat cupidatat non proident, sunt in culpa."
    )
]

fileprivate struct CardView: View {
    var item: CardItem
    
    var body: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 24))
            .overlay(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(
                        LinearGradient(stops: [
                            .init(color: .white.opacity(0), location: 0.4),
                            .init(color: Color(.systemGroupedBackground).opacity(0.8), location: 1)
                        ], startPoint: .top, endPoint: .bottom)
                    )
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.system(size: 23).bold())
                    Text(item.description)
                        .padding(.trailing, 20)
                        .font(.system(size: 14))
                }
                .padding()
            }
    }
}

struct AppleStyleScrollView: View {
    @State var visibleItem: CardItem? = cardItems.first
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(cardItems) { item in
                    CardView(item: item)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                        }
                        .id(item)
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $visibleItem)
        .background(.gray.opacity(0.3))
        .clipShape(.rect(cornerRadius: 24))
        .overlay{
            RoundedRectangle(cornerRadius: 24).stroke(lineWidth: 8)
                .foregroundStyle(.gray.opacity(0.3))
        }
        .frame(height: 200)
        .padding(.leading, 16)
        .padding(.trailing, 35)
        .overlay(alignment: .trailing) {
            VStack(spacing: 12) {
                ForEach(cardItems) { item in
                    Circle()
                        .frame(
                            width: item == visibleItem ? 10 : 6,
                            height: item == visibleItem ? 10 : 6
                        )
                        .foregroundStyle(item == visibleItem ? Color.primary : .gray)
                        .animation(.linear, value: visibleItem)
                }
            }
            .padding(.trailing, 10)
        }
    }
}
