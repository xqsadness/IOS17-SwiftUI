//
//  CustomViewTransition.swift
//  IOS17-Swift
//
//  Created by xqsadness on 4/9/24.
//

import SwiftUI
import UserNotifications
import AppTrackingTransparency

struct PageModel: Identifiable{
    var id = UUID()
    var page: AnyView
}

struct CustomViewTransition: View {
    @State private var show = false
    @State private var currentIndex = 0
    @State private var isGoingBack = false
    
    let pages: [PageModel]
    let numberOfRectangles: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                if currentIndex < pages.count{
                    pages[currentIndex].page
                        .frame(width: geo.size.width, height: geo.size.height)
                    
                    pages[max(0, min(currentIndex + (isGoingBack ? -1 : 1), pages.count - 1))].page
                        .frame(width: geo.size.width, height: geo.size.height)
                        .mask {
                            VStack(spacing: 0){
                                ForEach(0..<numberOfRectangles,id: \.self){ index in
                                    Rectangle()
                                        .frame(height: geo.size.height / CGFloat(numberOfRectangles))
                                        .offset(x: show ? 0 : (index % 2 == 0 ? (isGoingBack ? geo.size.height : -geo.size.height) : (isGoingBack ? -geo.size.height : geo.size.height)))
                                }
                            }
                        }
                }
                
                if currentIndex < pages.count - 1{
                    HStack{
                        if currentIndex != 0{
                            CustomButton(right: false) {
                                back()
                            }
                        }
                        
                        Spacer()
                        
                        CustomButton() {
                            next()
                        }
                    }
                    .padding()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    func back(){
        isGoingBack = true
        withAnimation {
            show.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if show{
                if currentIndex > 0{
                    currentIndex -= 1
                }
                show.toggle()
            }
        }
    }
    
    func next(){
        isGoingBack = false
        withAnimation {
            show.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if show{
                if currentIndex < pages.count - 1{
                    currentIndex += 1
                }
                show.toggle()
            }
        }
    }
}

struct HomeCustomTransition: View {
    
    @State private var intros: [Intro] = [
        Intro(title: "", subTitle: "Welcome", description: "Experience the joy of music, a lifelong journey that soothes the soul and uplifts the spirit.", pic: "pic1", color: LinearGradient(colors: [Color.cyan, Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)),
        Intro(title: "", subTitle: "Relax with Music", description: "Immerse yourself in our curated playlists designed to help you relax and unwind.", pic: "pic2", color: LinearGradient(colors: [Color.indigo, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)),
        Intro(title: "", subTitle: "Daily Tunes", description: "Start your day on a high note with our daily music selections tailored for every mood.", pic: "pic3", color: LinearGradient(colors: [Color.cyan, Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)),
        Intro(title: "Healthy with Music", subTitle: "Stay Healthy with Music", description: "Boost your wellbeing with regular listening sessions designed to keep you healthy and happy.", pic: "pic4", color: LinearGradient(colors: [Color.indigo, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
    ]
    @State private var isTracking = true
    @State private var showLoading = false
    
    var body: some View {
        CustomViewTransition(pages: pagesWithIntros(), numberOfRectangles: 6)
    }
    
    func createPage(intro: Intro) -> AnyView {
        return AnyView(
            ZStack(alignment: .center){
                Image(intro.pic)
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.4))
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    Text(intro.subTitle)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(intro.description)
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 100)
            }
        )
    }
    
    func pagesWithIntros() -> [PageModel] {
        var pages = intros.map { intro in
            PageModel(page: createPage(intro: intro))
        }
        
        pages.append(PageModel(page: AnyView(
            OnboardingPermissionView(showLoading: $showLoading, isTracking: $isTracking)
        )))
        
        return pages
    }
}

struct CustomButton: View {
    var right: Bool = true
    var action: () -> Void
    var body: some View {
        Button{
            action()
        }label: {
            Image(systemName: right ? "chevron.right" : "chevron.left")
                .imageScale(.large).bold()
                .frame(width: 24, height: 24)
                .padding(13)
                .background(.black.opacity(0.7), in: .rect(cornerRadius: 12))
        }
        .tint(.white)
        .padding()
    }
}

struct OnboardingPermissionView: View {
    
    // These properties will trigger a re-render of the view when their values are updated.
    @Binding var showLoading: Bool
    @Binding var isTracking: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.85), Color.black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(.lock)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(14)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // Title and subtitle
                Text("Before we get started")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white, .accentColor]), startPoint: .top, endPoint: .bottom))
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                Text("We need your permission to send you important notifications and track how you interact with the app. This allows us to offer the best possible experience tailored just for you.")
                    .font(.body)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.7), .accentColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                VStack{
                    if showLoading {
                        CubeOffset(four_colors: [.white, .init(hex: "#40E0D0"), .init(hex: "#FF8C00"), .init(hex: "#FF0080")])
                            .scaleEffect(.init(width: 0.45, height: 0.45))
                    }else{
                        Text(isTracking ? "Allow Permissions" : "Get started")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(.white, in: .rect(cornerRadius: 14))
                .padding(.horizontal)
                .safeAreaPadding(.bottom, 10)
                .animation(.spring, value: showLoading)
                .animation(.spring, value: isTracking)
                .contentShape(.rect)
                .onTapGesture {
                    if isTracking{
                        appTracking()
                    }else{
                        print("Go to home view")
                    }
                }
            }
        }
    }
    
    func appTracking() {
        showLoading = true
        
        UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .badge, .sound]) { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    DispatchQueue.main.async {
                        showLoading = false
                        isTracking = false
                    }
                }
            }
        }
    }
}
