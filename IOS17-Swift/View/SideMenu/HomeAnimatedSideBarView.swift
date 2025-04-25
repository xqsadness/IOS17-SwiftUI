//
//  HomeSideMenuView.swift
//  IOS17-Swift
//
//  Created by iamblue on 28/03/2024.
//

import SwiftUI

struct HomeAnimatedSideBarView: View {
    
    //view props
    @State private var showMenu = false
    @State private var theValue: Double = 0.0
    
    var body: some View {
        AnimatedSideBar(
            rotationsWhenExpands: true,
            disableInteraction: true,
            sideMenuWidth: 200,
            connerRadius: 25,
            showMenu: $showMenu) { safeArea in
                NavigationStack{
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 15) {
                            //All screen here
                            navigationScreen("Parallax Carousel Scroll") { ParallaxCarouselScrollView() }
                            navigationScreen("Dark Light Mode") { TestDarkLightModeView() }
                            navigationScreen("Theme Change Switch") { TestThemeChangeSwitch() }
                            navigationScreen("Toast Group") { VStack{
                                Button("Present Toast"){
                                    Toast.shared.present(
                                        title: "Hello world",
                                        symbol: "globe",
                                        isUserInteractionEnabled: true,
                                        timing: .long,
                                        position: .bottom
                                    )
                                }}}
                            navigationScreen("Parallax Scroll Effect") { ParallaxScrollEffectView() }
                            navigationScreen("Scroll Progress Tracker") { ScrollProgressTrackerView() }
                            navigationScreen("Image Paralax") { ImageParalaxView() }
                            navigationScreen("Cover Flow Show View") { CoverFlowShowView() }
                            navigationScreen("Stretchy Slider") { StretchySliderView() }
                            navigationScreen("MapInteraction") { MapInteraction() }
                            navigationScreen("YouTube Mini Player") { YouTubeMiniPlayerView() }
                            //                        navigationScreen("Animated SideBar View") { HomeAnimatedSideBarView() }
                            navigationScreen("Limited TextField") { LimitedTextFieldHome() }
                            navigationScreen("Passcode") { PasscodeHomeView() }
                            navigationScreen("Floating Action Button") { FloatingActionButton() }
                            navigationScreen("Hacker Text Effect") { HomeHackerTextEffectView() }
                            navigationScreen("Glitch Text Effect") { GlitchTextEffectView() }
                            navigationScreen("Custom Slider") { CustomSlider2(width: 10, height: 500, axis: .vertical, thevalue: $theValue) }
                            navigationScreen("Flip Clock Text Effect") { FlipClockTextEffectView() }
                            navigationScreen("OnBoarding") { OnBoardingScreen() }
                            navigationScreen("Layout Caching") { LayoutCaching() }
                            navigationScreen("Delete account view") { DeleteAccountView() }
                            navigationScreen("Home Swipe Actions For Scrollview") { HomeSwipeActions_() }
                            //MARK: Available in xcode 16 - navigationScreen("Floating TabBar") { FloatingTabBarView() }
                            navigationScreen("Onboarding with transition") { HomeCustomTransition() }
                            navigationScreen("Custom field") { CustomTextField() }
                            navigationScreen("Stack Animation") { StackAnimation() }
                            navigationScreen("DropDown") { DropDown() }
                            navigationScreen("Dynamic Tabbar") { DynamicTabbar() }
                            navigationScreen("Pattern Lock") { PatternLockScreen() }
                            navigationScreen("Inline Toast") { HomeInlineToastView() }
                        }
                        .padding()
                    }
                    .navigationTitle("Home")
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading) {
                            Button{
                                showMenu.toggle()
                            } label: {
                                Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                                    .foregroundColor(Color.primary)
                                    .contentTransition(.symbolEffect)
                            }
                        }
                    }
                }
            } menuView: { safeArea in
                SideBarMenu(safeArea)
            } background: {
                Rectangle()
                    .fill(.sideMenu)
            }
    }
    
    @ViewBuilder
    func navigationScreen<Content: View>(_ title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        NavigationLink {
            content()
        } label: {
            HStack {
                Text("\(title)")
                    .font(.title3)
                    .foregroundStyle(.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.large)
                    .foregroundStyle(.text)
            }
        }
    }
    
    @ViewBuilder
    func SideBarMenu(_ safeArea: UIEdgeInsets) ->some View{
        VStack(alignment: .leading, spacing: 12){
            Text("Side Menu")
                .font(.largeTitle.bold())
                .padding(.bottom)
            
            SideBarButton(.home)
            SideBarButton(.favourite)
            SideBarButton(.bookmark)
            SideBarButton(.profile)
            
            Spacer(minLength: 0)
            
            SideBarButton(.logout)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .environment(\.colorScheme, .dark)
    }
    
    @ViewBuilder
    func SideBarButton(_ tab: Tab, ontap: @escaping () -> () = {}) -> some View {
        Button {
            ontap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: tab.rawValue)
                    .font(.title3)
                
                Text(tab.title)
                    .font(.callout)
                
                Spacer(minLength: 0)
            }
            .padding(.vertical)
            .contentShape(.rect)
            .foregroundColor(.white)
        }
    }
    
    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case bookmark = "book.fill"
        case favourite = "heart.fill"
        case profile = "person.crop.circle"
        case logout = "rectangle.portrait.and.arrow.forward.fill"
        
        var title : String {
            switch self {
            case .home:
                return "Home"
            case .bookmark:
                return "Bookmark"
            case .favourite:
                return "Favourite"
            case .profile:
                return "Profile (iamblue)"
            case .logout:
                return "Logout"
            }
        }
    }
}
