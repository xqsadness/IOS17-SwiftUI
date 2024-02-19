//
//  StretchySliderView.swift
//  IOS17-Swift
//
//  Created by iamblue on 19/02/2024.
//

import SwiftUI

struct StretchySliderView: View {
    //View props
    @State private var progress: CGFloat = 0.6
    @State private var axis: CustomSlider.SliderAxis = .vertical
    
    var body: some View {
        VStack{
            Picker("", selection: $axis){
                Text("Vertical")
                    .tag(CustomSlider.SliderAxis.vertical)
                
                Text("Horizontal")
                    .tag(CustomSlider.SliderAxis.horizontal)
            }
            .pickerStyle(.segmented)
            
            CustomSlider(
                sliderProgress: $progress,
                symbol: .init(
                    icon: "airpodspro",
                    tint: .gray,
                    font: .system(
                        size: 23
                    ),
                    padding: 20,
                    display: axis == .vertical,
                    alignment: .bottom
                ),
                axis: axis,
                tint: .white
            )
            .frame(width: axis == .horizontal ? 220 : 60, height: axis == .horizontal ? 30 : 180)
            .frame(maxHeight: .infinity)
            .animation(.snappy, value: axis)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.fill)
    }
}

#Preview {
    StretchySliderView()
}
