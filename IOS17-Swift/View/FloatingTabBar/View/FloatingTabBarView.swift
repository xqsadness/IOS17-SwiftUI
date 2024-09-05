//
//  FloatingTabBarView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 29/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 12){
                    ForEach(1...50, id: \.self){ _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.background)
                            .frame(height: 55)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Floating tabbar")
            .background(Color.primary.opacity(0.07))
            .safeAreaPadding(.bottom, 60)
        }
    }
}

struct FloatingTabBarView: View {
    // view props
    @State private var activeTab: TabFloating = .home
    @State private var isTabbarHidden: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                HomeView()
                    .tag(TabFloating.home)
                    .background{
                        if !isTabbarHidden{
                            HideTabBar{
                                isTabbarHidden = true
                            }
                        }
                    }
                
                Text("Search")
                    .tag(TabFloating.search)
                
                Text("Notifications")
                    .tag(TabFloating.notifications)
                
                Text("Settings")
                    .tag(TabFloating.settings)
            }
            
            //MARK: Available in xcode 16
//            CustomTabbar(activeTab: $activeTab)
        }
    }
}

struct HideTabBar: UIViewRepresentable {
    init(result: @escaping () -> Void) {
        UITabBar.appearance().isHidden = true
        self.result = result
    }
    
    var result: () -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                UITabBar.appearance().isHidden = false
                tabController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence (first: self, next: {
            $0.next
        }).first (where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        return nil
    }
}

#Preview {
    FloatingTabBarView()
}
