
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            //Jump to definition
            HomeAnimatedSideBarView()
        }
    }
}

#Preview {
    RootView{
        ContentView()
    }
}

//struct FloatingActionButton2: View {
//    @State private var isExpanded = false
//    
//    var body: some View {
//        ZStack(alignment: .bottomTrailing) {
//            Color.black.ignoresSafeArea()
//            
//            VStack(spacing: 20) {
//                ForEach(0..<3) { index in
//                    Button{
//                        
//                    }label: {
//                        Image(systemName: ["pencil", "photo", "trash"][index])
//                            .symbolEffect(.scale.up.wholeSymbol, options: .nonRepeating)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Circle().fill(.blue))
//                    }
//                    .buttonStyle(.plain)
//                    .offset(y: isExpanded ? 0 : 100)
//                    .opacity(isExpanded ? 1 : 0)
//                }
//                
//                Button {
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
//                        isExpanded.toggle()
//                    }
//                } label: {
//                    Image(systemName: "plus")
//                        .rotationEffect(.degrees(isExpanded ? 45 : 0))
//                        .foregroundColor(.white)
//                        .imageScale(.large)
//                        .padding(24)
//                        .background(Circle().fill(.blue))
//                }
//                .buttonStyle(.plain)
//            }
//        }
//    }
//}
