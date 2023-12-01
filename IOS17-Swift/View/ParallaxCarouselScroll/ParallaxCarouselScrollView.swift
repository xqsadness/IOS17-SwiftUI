//
//  ParallaxCarouselScrollView.swift
//  IOS17-Swift
//
//  Created by darktech4 on 01/12/2023.
//

import SwiftUI
import Kingfisher

struct ParallaxCarouselScrollView: View {
    @StateObject var parallaxCarouselScrollViewModel = ParallaxCarouselScrollViewModel()
    
    var body: some View {
        VStack(spacing: 15){
            Text("Wallpaper")
                .font(.title)
                .bold()
            
            GeometryReader{ geo in
                let size = geo.size
                
                if parallaxCarouselScrollViewModel.isLoading{
                    VStack{
                        Text("Loading data ...")
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity ,alignment: .center)
                }else{
                    ScrollView(.horizontal){
                        HStack(spacing: 5){
                            
                            ForEach(parallaxCarouselScrollViewModel.imageData, id: \.id){ imageData in
                                
                                GeometryReader{ proxy in
                                    let cardSize = proxy.size
                                    //                                    let minX = proxy.frame(in: .scrollView).minX - 30.0
                                    let minX = min((proxy.frame(in: .scrollView).minX - 30.0) * 1.4, size.width * 1.4)
                                    
                                    KFImage(URL(string: imageData.urls.raw))
                                        .placeholder {
                                            Image("ImageDefault")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .offset(x: -minX)
                                                .frame(width: proxy.size.width * 2.5)
                                                .frame(width: cardSize.width, height: cardSize.height)
                                        }
                                        .loadDiskFileSynchronously()
                                        .cacheMemoryOnly()
                                        .fade(duration: 0.25)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    //                                        .scaleEffect(1.25)
                                        .offset(x: -minX)
                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay(content: {
                                            OverlayView(imageData)
                                        })
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                }
                                .frame(width: size.width - 60, height: size.height - 50)
                                // scroll animation
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .top)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                }
                
            }
            .frame(height: 500)
            .padding(.horizontal, -15)
            .padding(.top, 10)
            .overlay(alignment: .bottomTrailing, content: {
                Text("By: I am blue !")
                    .font(.callout)
                    .italic()
            })
            .padding(15)
            
            Spacer()
        }
        .scrollIndicators(.hidden)
    }
    
    /// Overlay View
    @ViewBuilder
    func OverlayView (_ card: ImageUnsplash) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient (colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity (0.1),
                .black.opacity (0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 4, content: {
                Text (card.user.username)
                    .font (.title2)
                    .fontWeight(.black)
                    .foregroundStyle (.white)
                Text (card.user.name)
                    .font(.callout)
                    .foregroundStyle (.white.opacity (0.8))
            })
            .padding()
        })
    }
}

#Preview {
    ParallaxCarouselScrollView()
}
