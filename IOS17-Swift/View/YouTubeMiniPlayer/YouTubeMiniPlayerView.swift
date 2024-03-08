//
//  YouTubeMiniPlayerView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 24/02/2024.
//

import SwiftUI

struct YouTubeMiniPlayerView: View {
    //View props
    @State private var activeTab: Tab = .home
    @State private var config: PlayerConfig = .init()
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                HomeTabView()
                    .setuptab(.home)
                
                Text(Tab.shorts.rawValue)
                    .setuptab(.shorts)
                
                Text(Tab.subscriptions.rawValue)
                    .setuptab(.subscriptions)
                
                Text(Tab.you.rawValue)
                    .setuptab(.you)
            }
            .padding(.bottom, tabBarHeight)
            
            GeometryReader{
                let size = $0.size
                if config.showMiniPlayer{
                    MiniPlayerView(config: $config, size: size){
                        withAnimation(.easeInOut(duration: 0.3)) {
                            config.showMiniPlayer = false
                            config.selectedPlayerItem = nil
                            
                        }
                    }
                }
            }
            
            CustomTabbar()
                .offset(y: config.showMiniPlayer ? tabBarHeight - (config.progress * tabBarHeight) : 0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    func HomeTabView() -> some View{
        NavigationStack{
            ScrollView(.vertical){
                ForEach(items){item in
                    PlayerItemCardView(item) {
                        config.selectedPlayerItem = item
                        
                        withAnimation(.easeIn(duration: 0.3)) {
                            config.showMiniPlayer = true
                        }
                    }
                }
            }
            .navigationTitle("YouTube")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    func PlayerItemCardView(_ item: PlayerItem, ontap: @escaping () -> ()) -> some View{
        VStack(alignment: .leading, spacing: 6){
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect)
                .onTapGesture(perform: ontap)
            
            HStack(spacing: 10){
                Image(systemName: "person.circle.fill")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4){
                    Text(item.title)
                        .font(.callout)
                        .lineLimit(2)
                    
                    HStack(spacing: 6){
                        Text(item.author)
                        
                        Text("  2 Day ago")
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
            }
        }
    }
    
    @ViewBuilder
    func CustomTabbar() -> some View{
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue){ tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbol)
                        .font(.title3)
                    
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? Color.red : .gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                }
            }
        }
        //        .frame(height: 49)
        .overlay(alignment: .top){
            Divider()
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .frame(height: tabBarHeight)
        .background(.white)
    }
}

extension View{
    @ViewBuilder
    func setuptab(_ tab: Tab) -> some View{
        self
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    // SafeArea Value
    var safeArea: UIEdgeInsets{
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets{
            return safeArea
        }
        return .zero
    }
    
    var tabBarHeight: CGFloat{
        return 49 + safeArea.bottom
    }
}



#Preview {
    YouTubeMiniPlayerView()
}
