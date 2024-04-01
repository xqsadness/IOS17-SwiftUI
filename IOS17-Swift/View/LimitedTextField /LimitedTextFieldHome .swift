//
//  LimitedTextFieldHome .swift
//  IOS17-Swift
//
//  Created by xqsadness on 01/04/2024.
//

import SwiftUI

struct LimitedTextFieldHome: View {
    //View props
    @State private var text: String = ""
    var body: some View {
        VStack{
            LimitedTextField(
                config: .init(
                    limit: 40,
                    tint: .secondary,
                    autoResizes: true
                ),
                hint: "Type here",
                value: $text
            )
            .autocorrectionDisabled()
            .frame(maxHeight: 150)
            .padding()
        }
    }
}

#Preview {
    LimitedTextFieldHome()
}
