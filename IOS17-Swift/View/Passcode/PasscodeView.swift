
import SwiftUI

struct PasscodeHomeView: View {
    @State private var isAutheticated = false
    var body: some View {
        VStack {
            if isAutheticated{
                VStack{
                    Text("You're in!")
                    
                    Button("Log Out"){
                        isAutheticated = false
                    }
                }
            }else{
                PasscodeView(isAuthenticated: $isAutheticated)
            }
        }
        .padding()
        .preferredColorScheme(.light)
    }
}

struct PasscodeView: View {
    @State private var passcode = ""
    @Binding var isAuthenticated: Bool
    
    @State private var isWrong = false
    @State private var isAnimation: Bool = false {
        didSet {
            if(isAnimation == true){
                DispatchQueue.main.asyncAfter(deadline: .now () + 0.25){
                    isAnimation = false
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 40){
            VStack(spacing: 20){
                Text("Enter Passcode")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("Please enter your 4-digit pin to securely access your account.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 60)
            } .padding(.top)
            
            // indicator view
            PasscodeIndicatorView(passcode: $passcode,isAnimation: $isAnimation)
            
            Spacer()
            
            if isWrong{
                Text("Wrong password, please re-enter")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.red)
            }
            
            //numberpad view
            NumberPadView(passcode: $passcode)
            
        }.onChange(of: passcode) { _ , _ in
            verifyPasscode()
        }
    }
    
    private func verifyPasscode(){
        guard passcode.count == 4 else{ return }
        
        Task{
            try? await Task.sleep(nanoseconds: 125_000_000)
            isAuthenticated = passcode == "1111"
            passcode = ""
            withAnimation(.spring) {
                self.isAnimation = true
                isWrong = true
            }
        }
    }
}

#Preview {
    PasscodeView(isAuthenticated: .constant(false))
}
