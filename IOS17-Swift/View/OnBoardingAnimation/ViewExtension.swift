//
//  ViewExtension.swift
//  IOS17-Swift
//
//  Created by xqsadness on 04/07/2024.
//

import SwiftUI

extension View{
    func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}
