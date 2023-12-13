
import SwiftUI

struct ContentView: View {
    @AppStorage("colorScheme") var colorScheme = "dark"
    @State var show = true
    
    var body: some View {
        VStack {
            VStack {
                Text("Hello, world!")
                    .foregroundStyle (.primary)
                Button (action: {
                    withAnimation {
                        show.toggle()
                    }
                }, label: {
                    Text("Appearance").bold().font (.title2)
                        .frame(width: 200, height: 60)
                        .background (.text, in: RoundedRectangle (cornerRadius: 20))
                })
                .tint(.text2)
            }
            
        }
        .preferredColorScheme(getColorScheme())
    }
    
    func getColorScheme() -> ColorScheme?{
        if colorScheme == "dark"{
            return .dark
        }else if colorScheme == "light"{
            return .light
        }else{
            return nil
        }
    }
}
#Preview {
    ContentView()
}
