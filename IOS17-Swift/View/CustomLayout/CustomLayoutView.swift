//
//  CustomLayoutView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 04/07/2024.
//

import SwiftUI
import Kingfisher

protocol SelfCreateingView: View{
    init()
}

extension LayoutCaching {
    struct MasonryLayout: Layout {
        struct Cache {
            var frames: [CGRect]
            var width = 0.0
        }
        
        var columns: Int
        var spacing: Double
        
        init(columns: Int = 3, spacing: Double = 5) {
            self.columns = max(1, columns)
            self.spacing = spacing
        }
        
        func makeCache(subviews: Subviews) -> Cache {
            Cache(frames: [])
        }
        
        func frames(for subviews: Subviews, in totalWidth: Double) -> [CGRect] {
            let totalSpacing = spacing * Double(columns - 1)
            let columnWidth = (totalWidth - totalSpacing) / Double(columns)
            let columnWidthwithSpacing = columnWidth + spacing
            let proposedSize = ProposedViewSize(width: columnWidth, height: nil)
            var viewFrames = [CGRect]()
            var columnHeights = Array(repeating: 0.0, count: columns)
            for subview in subviews {
                var selectColumn = 0
                var selectedHeight = Double.greatestFiniteMagnitude
                for (columnIndex, height) in columnHeights.enumerated() {
                    if height < selectedHeight {
                        selectColumn = columnIndex
                        selectedHeight = height
                    }
                }
                let x = Double(selectColumn) * columnWidthwithSpacing
                let y = columnHeights [selectColumn]
                let size = subview.sizeThatFits(proposedSize)
                let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                
                columnHeights [selectColumn] += size.height + spacing
                viewFrames.append(frame)
            }
            
            return viewFrames
        }
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
            let width = proposal.replacingUnspecifiedDimensions().width
            let viewFrames = frames(for: subviews, in: width)
            let height = viewFrames.max{ $0.maxY < $1.maxY } ?? .zero
            
            cache.frames = viewFrames
            cache.width = width
            
            return CGSize(width: width, height: height.maxY)
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
            if cache.width != bounds.width{
                cache.frames = frames(for: subviews, in: bounds.width)
                cache.width = bounds.width
            }
            
            for index in subviews.indices{
                let frame = cache.frames[index]
                let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY)
                subviews[index].place(at: position, proposal: ProposedViewSize(frame.size))
            }
        }
    }
    
    struct placeholderView: View {
        let color: Color = [.blue, .cyan, .green, .indigo, .mint, .orange, .pink, .purple, .red,.yellow].randomElement()!
        let size: CGSize
        var imageUrl: String
        
        var body: some View {
            ZStack{
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        Image("ImageDefault")
                    }
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .resizable()
                //                    .frame(maxWidth: size.width, maxHeight: size.height)
                //                    .aspectRatio(contentMode: .fill)
                
                //                                RoundedRectangle(cornerRadius: 10)
                //                                    .fill(color)
                
                Text("\(Int(size.width))x\(Int(size.height))")
                    .foregroundStyle(.white)
                    .font(.headline)
            }
            .aspectRatio(size, contentMode: .fill)
        }
    }
}

struct LayoutCaching: SelfCreateingView{
    //get image from api
    @StateObject var parallaxCarouselScrollViewModel = ParallaxCarouselScrollViewModel()
    
    @State private var columns = 3
    @State private var views = (0..<40).map { _ in
        CGSize(width: .random(in: 100...500), height: .random(in: 100...500))
    }
    var body: some View{
        ScrollView(.vertical){
            MasonryLayout(columns: columns){
                ForEach(parallaxCarouselScrollViewModel.imageData, id: \.id){ img in
                    placeholderView(size: views[Int.random(in: 0..<40)], imageUrl: img.urls.raw)
                }
            }
            .padding(.horizontal, 5)
            .animation(.spring, value: columns)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Stepper("Column \(columns)",value: $columns)
                .padding()
                .background(.ultraThinMaterial)
        }
    }
}

#Preview {
    LayoutCaching()
}
