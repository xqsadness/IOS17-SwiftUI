//
//  ScrollProgressTrackerView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 03/01/2024.
//

import SwiftUI

struct ScrollProgressTrackerView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader{ fullView in
                ZStack(alignment: .top){
                   //3
                    ScrollView {
                        GeometryReader{ scrollViewGeo in
                            Color.clear.preference(key: ScrollOffSetKey.self, value: scrollViewGeo.frame(in: .global).minY)
                        }
                        .frame(height: 0).id(0)
                        
                        VStack{
                            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum")
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //2
                        .background(GeometryReader{ contentGeo in
                            Color.clear.preference(key: ContentHeightPreferenceKey.self, value: contentGeo.size.height)
                        })
                    }
                    .onPreferenceChange(ScrollOffSetKey.self){
                        self.scrollOffset = $0 - fullView.safeAreaInsets.top
                    }
                    .onPreferenceChange(ContentHeightPreferenceKey.self){
                        self.contentHeight = $0
                    }
                    progressView(fullView: fullView, ScrollProxy: scrollProxy)
                    
                    
                }
            }
        }
    }
    
    func progressView(fullView: GeometryProxy, ScrollProxy: ScrollViewProxy) -> some View{
        let progress = min(max(0, -scrollOffset / (contentHeight - fullView.size.height)), 1)
        let progressPercentage = Int(progress * 100)
        return ZStack{
            Group{
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 250, height: 55)
                        .foregroundStyle(.white)
                    HStack{
                        Text("\(progressPercentage)%").bold()
                        RoundedRectangle(cornerRadius: 20).foregroundStyle(.red)
                            .frame(width: 150 * progress, height: 8)
                    }
                    .padding(.leading, 20)
                    .opacity(progressPercentage > 0 && progressPercentage < 100 ? 0.8 : 0)
                    .animation(.easeInOut, value: progressPercentage)
                    
                    
                    
                }
            }
            .opacity(progressPercentage > 0 ? 0.8 : 0)
            
            Button{
                withAnimation(.easeInOut(duration: 5)) {
                    ScrollProxy.scrollTo(0, anchor: .top)
                }
            }label: {
                Image(systemName: "arrow.up").font(.title).bold()
                    .foregroundStyle(.black)
                    .frame(width: 55, height: 55)
            }
            .offset(y: progressPercentage == 100 ? 0 : 100)
            .animation(.easeInOut, value: progressPercentage)
        }
        .mask(
            RoundedRectangle(cornerRadius: 40)
                .frame(width: progressPercentage > 0 && progressPercentage < 100 ? 250 : 55, height: 55)
                .animation(.easeInOut, value: progressPercentage)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct ScrollOffSetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentHeightPreferenceKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    ScrollProgressTrackerView()
}
