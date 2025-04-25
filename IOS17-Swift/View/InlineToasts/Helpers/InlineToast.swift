//
//  InlineToast.swift
//  IOS17-Swift
//
//  Created by xqsadness on 25/4/25.
//

import SwiftUI

import SwiftUI

extension View {
    func inlineToast(config: InlineToastConfig, isPresented: Bool, alignment: Alignment) -> some View {
        VStack(spacing: 10) {
            if config.anchor == .bottom {
                self
                    .compositingGroup()
                    .frame(maxWidth: .infinity, alignment: alignment)
            }

            if isPresented{
                InlineToastView(config: config)
                    .transition(CustomTransitionInlineToast(anchor: config.animationAnchor))
            }
            
            //Inline Toast View

            if config.anchor == .top{
                self
                    .compositingGroup()
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
        .clipped()
    }
}

fileprivate struct CustomTransitionInlineToast: Transition {
    var anchor: InlineToastConfig.InlineToastAnchor
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .visualEffect { [phase] content, proxy in
                content
                    .offset(y: offset(proxy, phase: phase))
            }
            // Clipping the view so that it won't appear on top of other views
            .clipped()
    }

    nonisolated func offset(_ proxy: GeometryProxy, phase: TransitionPhase) -> CGFloat {
        let height = proxy.size.height + 10
        return anchor == .top ? (phase.isIdentity ? 0 : -height) : (phase.isIdentity ? 0 : height)
    }
}

struct InlineToastConfig {
    var icon: String
    var title: String
    var subTitle: String
    var tint: Color
    var anchor: InlineToastAnchor = .top
    var animationAnchor: InlineToastAnchor = .top
    var actionIcon: String
    var actionHandler: () -> () = { }
    
    enum InlineToastAnchor {
        case top
        case bottom
    }
}

/// Custom Inline Toast View
struct InlineToastView: View {
    var config: InlineToastConfig
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: config.icon)
                .font(.title2)
                .foregroundStyle(config.tint)

            VStack(alignment: .leading, spacing: 5) {
                Text(config.title)
                    .font(.callout)
                    .fontWeight(.semibold)

                if !config.subTitle.isEmpty {
                    Text(config.subTitle)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }

            Spacer(minLength: 0)

            /// Action Button
            Button(action: config.actionHandler) {
                Image(systemName: config.actionIcon)
                    .foregroundStyle(.gray)
                    .contentShape(.rect)
            }
        }
        .padding()
        .background{
            ZStack{
                Rectangle()
                    .fill(.background)
                
                HStack(spacing: 0){
                    Rectangle()
                        .fill(config.tint)
                        .frame(width: 5)
                    
                    Rectangle()
                        .fill(config.tint.opacity(0.15))
                }
            }
        }
        .contentShape(.rect)
    }
}
