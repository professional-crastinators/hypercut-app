//
//  ProgressPanelButtonStyle.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct ProgressPanelButtonStyle: ButtonStyle {
  
  var progress: CGFloat?
  
  var accentColor: Color = .init("AccentColor", bundle: .main)

  func makeBody(configuration: Self.Configuration) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(
            configuration.isPressed
              ? accentColor.opacity(0.9) 
              : accentColor)
        if let progress = progress {
          Rectangle()
            .foregroundColor(.black.opacity(0.2))
            .frame(width: geometry.size.width * progress)
        }
      }
      .animation(.easeInOut)
    }
    .cornerRadius(20)
    .overlay(
      configuration.label
        .font(.headline)
        .foregroundColor(.white))
    .frame(height: 60)
  }
}
