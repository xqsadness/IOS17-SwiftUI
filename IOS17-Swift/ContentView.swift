
import SwiftUI

struct ContentView: View {
    //Props for DarkLightModeView
    @AppStorage("colorScheme") var colorScheme = "dark"
    @State var show = true
    
    //Props for Dark Mode Switch
    @State private var changeTheme: Bool = false
    @Environment(\.colorScheme) private var scheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDedault
        
    var body: some View {
        VStack {
            //MARK: - DarkLightModeView
            //            VStack {
            //                Text("Hello, world!")
            //                    .foregroundStyle (.primary)
            //                Button (action: {
            //                    withAnimation {
            //                        show.toggle()
            //                    }
            //                }, label: {
            //                    Text("Appearance").bold().font (.title2)
            //                        .frame(width: 200, height: 60)
            //                        .background (.text, in: RoundedRectangle (cornerRadius: 20))
            //                })
            //                .tint(.text2)
            //            }
            //            DarkLightModeView(show: $show)
            //                .opacity(show ? 0 : 1)
            
            //MARK: - Toast
            Button("Present Toast"){
                Toast.shared.present(
                    title: "Hello world",
                    symbol: "globe",
                    isUserInteractionEnabled: true,
                    timing: .long,
                    position: .bottom
                )
            }
            
            //MARK: - Dark Mode Switch
            Button("Change Theme"){
                changeTheme.toggle()
            }
            
        }
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeSwitch(scheme: scheme)
            //Since max height is 410
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
        //For DarkLightModeView
//        .preferredColorScheme(getColorScheme())
        
        //For Dark Mode Switch
        .preferredColorScheme(userTheme.colorScheme)
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
    RootView{
        ContentView()
    }
}
