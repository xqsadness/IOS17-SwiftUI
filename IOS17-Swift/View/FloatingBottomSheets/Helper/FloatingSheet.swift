//
//  FloatingSheet.swift
//  IOS17-Swift
//
//  Created by xqsadness on 29/8/24.
//

import SwiftUI

extension View{
    @ViewBuilder
    func floatingBottomSheet<Content: View>(isPresented: Binding<Bool>, onDismiss: @escaping () -> () = {}, @ViewBuilder content: @escaping () -> Content) -> some View{
        self
            .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                content()
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
            }
    }
} 
