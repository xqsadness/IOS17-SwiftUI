//
//  DeleteAccountView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 24/07/2024.
//

import SwiftUI

struct DeleteAccountView: View {
    
    @State private var show = false
    
    var body: some View {
        ZStack{
            Button{
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)){
                    show.toggle()
                }
            }label: {
                Text("Show delete card")
            }
            
            DeleteCard(icon: "trash.circle", title: "Delete Account", details: "Are you sure you want to delete your  account? All your data will be permanently removed.", BStartTitle: "ACCOUNT DELETED", BEndTitle: "HOLD TO DELETE", show: $show)
        }
    }
}

struct DeleteCard: View {
    
    @State var trimEnd: CGFloat = 0.0
    var icon: String
    var title: String
    var details:String
    var BStartTitle: String
    var BEndTitle: String
    @Binding var show: Bool
    
    var body: some View {
        VStack(spacing:20) {
            VStack(spacing:28){
                Image(systemName: icon)
                    .font(.system (size: 70))
                    .foregroundStyle (.white)
                
                VStack(spacing:16){
                    Text(title).font (.title2.bold())
                    Text(details)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundStyle (.secondary)
                }
                
                HoldButton(BStartTitle: BStartTitle, BEndTitle: BEndTitle, trimEnd: $trimEnd, show: $show)
            }
            .padding (.horizontal)
            .frame(width: 350, height: 316)
            .background(.deleteCardBG, in: .rect (cornerRadius: 30))
            .overlay {
                ReclineLine(trimEnd: $trimEnd)
            }
            
            Button{
                withAnimation {
                    show = false
                }
            }label: {
                Text("Cancel")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.deleteCardBG, in: .rect(cornerRadius: 15))
                    .padding(.horizontal, 22)
            }
            .tint(.white)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .offset(y: show ? -20 : 500)
    }
}

#Preview {
    DeleteCard(icon: "trash.circle", title: "Delete Account", details: "Are you sure you want to delete your  account? All your data will be permanently removed.", BStartTitle: "ACCOUNT DELETED", BEndTitle: "HOLD TO DELETE", show: .constant(false))
}

struct HoldButton: View {
    
    @State var isComplete = false
    @State var isSuccess = false
    var BStartTitle: String
    var BEndTitle: String
    @Binding var trimEnd: CGFloat
    @Binding var show: Bool
    
    var body: some View {
        VStack{
            ZStack{
                ZStack(alignment: .leading){
                    Rectangle()
                        .foregroundStyle(.red.opacity(0.5))
                    
                    Rectangle()
                        .frame(maxWidth: isComplete ? .infinity : 0)
                        .foregroundStyle(isSuccess ? .deleteCardDB : .red)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .clipShape(.rect(cornerRadius: 15))
                .padding(.horizontal, 8)
                
                Text(isSuccess ? "ACCOUNT DELETED" : "HOLD TO DELETE")
                    .bold()
                    .foregroundStyle(.white)
            }
            .onLongPressGesture(minimumDuration: 2, maximumDistance: 50) { isPressing in
                if isPressing{
                    withAnimation(.linear(duration: 2)){
                        isComplete = true
                        trimEnd = 1
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        if !isSuccess{
                            withAnimation {
                                isComplete = false
                                trimEnd = 0
                            }
                        }
                    }
                }
            } perform: {
                withAnimation {
                    isSuccess = true
                    trimEnd = 1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25){
                        withAnimation {
                            show = false
                        }
                    }
                }
            }
        }
    }
}

struct ReclineLine: View {
    @Binding var trimEnd: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .trim(from: 0.5 - trimEnd / 2, to: 0.5 + trimEnd / 2)
            .stroke(lineWidth: 1)
            .frame(width: 313, height: 347)
            .foregroundStyle(.red)
            .rotationEffect(.degrees(90))
    }
}
