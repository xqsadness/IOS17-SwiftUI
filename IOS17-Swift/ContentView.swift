
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false){
                    LazyVStack(spacing: 13){
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
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .navigationTitle("All screens")
            }
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
}
#Preview {
    RootView{
        ContentView()
    }
}
