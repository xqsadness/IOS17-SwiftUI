//
//  PinterestLayout.swift
//  IOS17-Swift
//
//  Created by xqsadness on 4/7/25.
//

import SwiftUI

struct PinterestLayout: View {
    
    let imgs: [ImageResource] = [.stars, .pic1, .pic2, .pic3, .pic4, .jj1, .jj2, .jj3, .jj4, .p1, .p2, .testImg]
    
    var body: some View {
        NavigationStack{
            LayoutView(images: imgs)
            
            NavigationLink{
                PinterestLayout2()
            }label: {
                Text("Pinterest Layout 2")
            }
        }
    }
}

struct LayoutView: View {
    
    var images: [ImageResource]
    @State private var showImg = false
    @Namespace var namespace
    @State var selectedImage: ImageResource? = nil
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                VStack {
                    createGrid(for: images.filter { isHeavy($0) })
                    Spacer()
                }
                .zIndex(images.contains(where: isHeavy) ? 0 : 1)
                
                VStack {
                    createGrid(for: images.filter { !isHeavy($0) })
                    Spacer()
                }
                .zIndex(images.contains(where: isHeavy) ? 1 : 0)
            })
        }
        .safeAreaPadding(.horizontal, 10)
        .overlay {
            if showImg{
                ImageView(image: selectedImage!, show: $showImg, namespace: namespace)
            }
        }
    }
    
    func createGrid(for filteredImages: [ImageResource]) -> some View {
        ForEach(filteredImages, id: \.self) { item in
            GridRow {
                Image(item).resizable().scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
                    .matchedGeometryEffect(id: item, in: namespace)
                    .zIndex(selectedImage == item ? 1 : 0)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.5)) {
                            selectedImage = item
                            showImg.toggle()
                        }
                    }
            }
        }
    }
    
    func isHeavy(_ image: ImageResource) -> Bool {
        if let index = images.firstIndex(of: image) {
            return index % 2 == 1
        }
        return false
    }
}

struct ImageView: View {
    
    var image: ImageResource
    @Binding var show: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image(image).resizable().scaledToFit()
                    .matchedGeometryEffect(id: image, in: namespace)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) {
                            show.toggle()
                        }
                    }
            }
        }
        .background(.thinMaterial)
        .ignoresSafeArea()
    }
}

#Preview {
    PinterestLayout()
}

// A different Pinterest-style custom layout implementation using fixed item heights and dynamic column assignment
struct PinterestLayout2: View {
    let gridItems = [
        GridItemCustom(height: 450, imgString: "stars"),
        GridItemCustom(height: 243, imgString: "pic1"),
        GridItemCustom(height: 353, imgString: "pic2"),
        GridItemCustom(height: 352, imgString: "pic3"),
        GridItemCustom(height: 300, imgString: "pic4"),
        GridItemCustom(height: 352, imgString: "jj1"),
        GridItemCustom(height: 334, imgString: "jj2"),
        GridItemCustom(height: 115, imgString: "jj3"),
        GridItemCustom(height: 313, imgString: "jj4"),
        GridItemCustom(height: 313, imgString: "p1"),
        GridItemCustom(height: 313, imgString: "p2"),
    ]
    
    @State private var columns = 3
    var body: some View {
        ScrollView{
            PinterestGrid(gridItems: gridItems, numOfColumns: columns, spacing: 5, horizontalPadding: 10)
                .animation(.spring, value: columns)
        }
        .navigationBarItems(leading: removeBtn ,trailing: addBtn)
        .navigationTitle("Pinterest Grid")
    }
    var removeBtn: some View{
        Button(action: {
            columns -= 1
        }){
            Text("Remove")
        }
        .disabled(columns == 1)
    }
    
    var addBtn: some View{
        Button(action: {
            columns += 1
        }){
            Text("Add")
        }
    }
}

struct GridItemCustom: Identifiable{
    let id = UUID()
    let height: CGFloat
    let imgString: String
}

fileprivate struct PinterestGrid: View {
    struct Column: Identifiable{
        let id = UUID()
        var gridItems = [GridItemCustom]()
    }
    let columnss: [Column]
    
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(gridItems: [GridItemCustom], numOfColumns: Int, spacing: CGFloat = 20, horizontalPadding: CGFloat = 20){
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        
        var columnss = [Column]()
        for _ in 0 ..< numOfColumns {
            columnss.append(Column())
        }
        
        var columnsHeight = Array<CGFloat>(repeating: 0, count: numOfColumns)
        
        for gridItem in gridItems {
            var smallestColumnIndex = 0
            var smallestHeight = columnsHeight.first!
            for i in 1 ..< columnsHeight.count{
                let curHeight = columnsHeight[i]
                if curHeight < smallestHeight {
                    smallestHeight = curHeight
                    smallestColumnIndex = i
                }
            }
            
            columnss[smallestColumnIndex].gridItems.append(gridItem)
            columnsHeight[smallestColumnIndex] += gridItem.height
        }
        self.columnss = columnss
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing){
            ForEach(columnss){ column in
                LazyVStack(spacing: spacing){
                    ForEach(column.gridItems) { gridItme in
                        
                        getItemView(gridItem: gridItme)
                    }
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    func getItemView(gridItem: GridItemCustom) -> some View{
        ZStack{
            GeometryReader{ reader in
                Image(gridItem.imgString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: reader.size.width, height: reader.size.height,alignment: .center)
            }
        }
        .frame(height: gridItem.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }
}
