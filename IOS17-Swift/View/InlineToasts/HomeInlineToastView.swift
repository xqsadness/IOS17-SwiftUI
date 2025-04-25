//
//  InlineToastView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 25/4/25.
//

import SwiftUI

struct HomeInlineToastView: View {
    
    @State private var showToast1: Bool = false
    @State private var showToast2: Bool = false
    
    var body: some View {
        NavigationStack {
            // Sample Toasts
            let toast1 = InlineToastConfig(
                icon: "exclamationmark.circle.fill",
                title: "Incorrect password :(",
                subTitle: "Oops! That didn't match. Give it another shot.",
                tint: .red,
                anchor: .top,
                animationAnchor: .top,
                actionIcon: "xmark"
            ) {
                showToast1 = false
            }

            let toast2 = InlineToastConfig(
                icon: "checkmark.circle.fill",
                title: "Password Reset Email Sent!",
                subTitle: "",
                tint: .green,
                anchor: .top,
                animationAnchor: .top,
                actionIcon: "xmark"
            ) {
                showToast2 = false
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Email Address")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("", text: .constant(""))
                
                Text("Password")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                SecureField("", text: .constant(""))
                
                VStack(alignment: .trailing, spacing: 20) {
                    Button {
                        showToast1.toggle()
                    } label: {
                        Text("Login in to Account")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 2)
                    }
                    .tint(.blue)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .buttonStyle(.borderedProminent)
                    
                    Button("Forgot Password") {
                        showToast2.toggle()
                    }
                }
                .inlineToast(config: toast1, isPresented: showToast1, alignment: .center)
                .inlineToast(config: toast2, isPresented: showToast2, alignment: .center)
                .padding(.top, 10)
                
                Spacer()
            }
            .textFieldStyle(.roundedBorder)
            .padding(15)
            .navigationTitle("Login")
            .animation(.smooth(duration: 0.35, extraBounce: 0), value: showToast1)
            .animation(.smooth(duration: 0.35, extraBounce: 0), value: showToast2)
        }
    }
}

#Preview {
    HomeInlineToastView()
}
