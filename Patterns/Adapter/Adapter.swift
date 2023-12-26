//
//  Adapter.swift
//  IOS17-Swift
//
//  Created by iamblue on 26/12/2023.
//

import SwiftUI

/*:
  Adapter
 ----------
 
 The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.
 
 ### Example
 */
protocol NewDeathStarSuperLaserAiming {
    var angleV: Double { get }
    var angleH: Double { get }
}
/*:
 **Adapte**
 */
struct OldDeathStarSuperlaserTarget {
    let angleHorizontal: Float
    let angleVertical: Float
    
    init(angleHorizontal: Float, angleVertical: Float) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
/*:
 **Adapter**
 */
struct NewDeathStarSuperlaserTarget: NewDeathStarSuperLaserAiming {
    
    private let target: OldDeathStarSuperlaserTarget
    
    var angleV: Double {
        return Double(target.angleVertical)
    }
    
    var angleH: Double {
        return Double(target.angleHorizontal)
    }
    
    init(_ target: OldDeathStarSuperlaserTarget) {
        self.target = target
    }
}

#Preview {
    VStack{ }
    .onAppear{
        /*:
         ### Usage
         */
        let target = OldDeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
        let newFormat = NewDeathStarSuperlaserTarget(target)
        
        print(newFormat.angleH)
        print(newFormat.angleV)
    }
}
