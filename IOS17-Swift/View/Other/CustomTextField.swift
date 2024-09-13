//
//  CustomTextField.swift
//  IOS17-Swift
//
//  Created by xqsadness on 9/9/24.
//

import SwiftUI

struct CustomSearchField: View {
    @State var show = false
    @State var text = ""
    @FocusState var Istyping: Bool
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle (cornerRadius: show ? 15: 30)
                .foregroundStyle(.thinMaterial)
                .shadow(color: .black.opacity (0.1), radius: 0, x: 0, y: 6)
            HStack{
                Image(systemName: show ? "xmark": "magnifyingglass")
                    .font(.title2)
                    .foregroundStyle (.primary.opacity (0.5))
                    .contentTransition(.symbolEffect)
                    .onTapGesture {
                        withAnimation {
                            text = ""
                            show.toggle()
                            Istyping.toggle()
                        }
                    }
                
                TextField("Type here", text: $text)
                    .focused($Istyping)
                    .opacity(show ? 1 : 0)
            }
            .padding(.leading, 11)
        }
        .frame(width: show ? 300: 50, height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 70).clipped ()
    }
}

#Preview {
    CustomTextField()
}

struct CustomTextField: View {
    @State private var name: String = ""
    @State private var email: String = ""
    var body: some View {
        VStack(spacing: 50){
            InfoField(title: "Name", text: $name)
            InfoField(title: "Email", text: $email)
            
            CustomSearchField()
        }
        .padding(.horizontal)
    }
}

struct InfoField: View {
    let title: String
    @Binding var text: String
    @FocusState var isTying: Bool
    var body: some View {
        ZStack(alignment: .leading){
            TextField("", text: $text)
                .padding(.leading)
                .frame(height: 55)
                .focused($isTying)
                .background(isTying ? .blue : Color.primary, in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 2))
            
            Text(title)
                .padding(.horizontal, 5)
                .background(.rev.opacity(isTying || !text.isEmpty ? 1 : 0))
                .foregroundStyle(isTying ? .blue : Color.primary)
                .padding(.leading)
                .offset(y: isTying || !text.isEmpty ? -27 : 0)
                .onTapGesture {
                    isTying.toggle()
                }
        }
        .animation(.linear(duration: 0.2), value: isTying)
    }
}
