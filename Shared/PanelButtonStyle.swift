//
//  PanelButtonStyle.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct PanelButtonStyle: ButtonStyle {
  
  var accentColor: Color = .init("AccentColor", bundle: .main)

  func makeBody(configuration: Self.Configuration) -> some View {
    return RoundedRectangle(cornerRadius: 20)
      .foregroundColor(
        configuration.isPressed
          ? Color.accentColor.opacity(0.9) 
          : Color.accentColor)
      .accentColor(accentColor)
      .frame(height: 60)
      .overlay(
        configuration.label
          .font(.headline)
          .foregroundColor(.white))
  }
}
