//
//  MiniPlayerView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 08/03/2024.
//

import SwiftUI

struct MiniPlayerView: View {
    @Binding var config: PlayerConfig
    var size: CGSize
    var close: () -> ()
    let miniPlayerHeight: CGFloat = 50
    let playerHeight: CGFloat = 200
    var body: some View {
        let progress = config.progress > 0.7 ? (config.progress - 0.7) / 0.3 : 0
        VStack{
            ZStack(alignment: .top){
                GeometryReader{
                    let size = $0.size
                    let width = size.width - 120
                    let height = size.height
                    
                    
                    VideoPlayerView()
                        .frame(width: 120 + (width - (width * progress)), height: height)
                }
                .zIndex(1)
                
                PlayerMinifiedContent()
                    .padding(.leading, 130)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
                    .opacity(progress)
            }
            .frame(minHeight: miniPlayerHeight, maxHeight: playerHeight)
            .zIndex(1)
            
            ScrollView(.vertical){
                if let playerItem = config.selectedPlayerItem{
                    PlayerExpandContent(playerItem)
                }
            }
            .opacity(1.0 - (config.progress * 1.6))
            .zIndex(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .clipped()
        .contentShape(.rect)
        .offset(y: config.progress * -tabBarHeight)
        .frame(height: size.height - config.position, alignment: .top)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .gesture(
            DragGesture()
                .onChanged{ value in
                    let start = value.startLocation.y
                    guard start < playerHeight || start > (size.height - (tabBarHeight + miniPlayerHeight)) else {return}
                    
                    let height = config.lastPosition + value.translation.height
                    config.position = min(height, (size.height - miniPlayerHeight))
                    gennerateProgress()
                }.onEnded{ value in
                    let start = value.startLocation.y
                    guard start < playerHeight || start > (size.height - (tabBarHeight + miniPlayerHeight)) else {return}
                    
                    let velocity = value.velocity.height
                    withAnimation(.smooth(duration: 0.3)) {
                        if (config.position + velocity) > (size.height * 0.65){
                            config.position = (size.height - miniPlayerHeight)
                            config.lastPosition = config.position
                            config.progress = 1
                        }else{
                            config.resetPosition()
                        }
                        
                    }
                }.simultaneously(with: TapGesture().onEnded({ _ in
                    withAnimation(.smooth(duration: 0.3)){
                        config.resetPosition()
                    }
                }))
        )
        .transition(.offset(y:config.progress == 1 ? tabBarHeight : size.height))
        .onChange(of: config.selectedPlayerItem) {  _ , newValue  in
            withAnimation(.smooth(duration: 0.3)){
                config.resetPosition()
            }
        }
    }
    
    @ViewBuilder
    func VideoPlayerView() -> some View{
        GeometryReader{
            let size = $0.size
            
            Rectangle()
                .fill(.black)
            
            if let playerItem = config.selectedPlayerItem{
                Image(playerItem.image)
                    .resizable()
                //                    .aspectRatio(16/9,contentMode: .fill)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
            }
            
        }
    }
    @ViewBuilder
    func PlayerMinifiedContent() -> some View{
        if let playerItem = config.selectedPlayerItem{
            HStack(spacing: 10){
                VStack(alignment: .leading, spacing: 3){
                    Text(playerItem.title)
                        .font(.callout)
                        .textScale(.secondary)
                        .lineLimit(1)
                        .foregroundColor(.black)
                    
                    Text(playerItem.author)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                    
                }
                .frame(maxHeight: .infinity)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "pause.fill")
                        .font(.title2)
                        .frame(width: 35, height: 35)
                        .contentShape(.rect)
                        .foregroundColor(.gray)
                })
                
                Button(action: {
                    close()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .frame(width: 35, height: 35)
                        .contentShape(.rect)
                        .foregroundColor(.gray)
                })
            }
        }
    }
    
    //Player Expanded content
    @ViewBuilder
    func PlayerExpandContent(_ item: PlayerItem) -> some View{
        VStack(alignment: .leading, spacing: 15){
            Text(item.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(item.description)
                .font(.callout)
                .foregroundColor(.gray)
            
        }
        .frame(maxHeight: .infinity, alignment: .leading)
        .padding(15)
    }
    
    func gennerateProgress(){
        let progress = max(min(config.position / (size.height - miniPlayerHeight), 1.0), .zero)
        config.progress = progress
        
    }
}

