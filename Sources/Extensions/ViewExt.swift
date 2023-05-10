//
//  ViewExt.swift
//
//
//  Created by Mercen on 2023/04/12.
//

import SwiftUI

extension View {
    @ViewBuilder func elevation() -> some View {
        self
            .shadow(color: Color.black.opacity(0.08), radius: 2, y: 1)
            .shadow(color: Color.black.opacity(0.08), radius: 5, y: 4)
    }
    
    @ViewBuilder func smoothAnimation(_ edge: Edge) -> some View {
        self
            .transition(.move(edge: edge).combined(with: .opacity))
    }
    
    @ViewBuilder func fader() -> some View {
        self
            .mask(
                HStack(spacing: 0) {
                    ForEach(0..<2) { idx in
                        LinearGradient(gradient:
                                        Gradient(
                                            colors: idx == 0 ? [.clear, .black]
                                            : [.black, .clear]),
                                       startPoint: .leading,
                                       endPoint: .trailing
                        )
                        .frame(width: 20)
                        if idx == 0 {
                            Rectangle().fill(Color.black)
                        }
                    }
                }
            )
    }
    
    @ViewBuilder func dismissButton() -> some View {
        self
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                        to: nil, from: nil, for: nil)
                    }
                    .foregroundColor(.accentColor)
                }
            }
    }
}
