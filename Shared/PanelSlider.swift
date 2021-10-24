//
//  PanelSlider.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI
struct PanelSlider: View {
  
  @Binding var value: Float
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(.gray)
        Rectangle()
          .foregroundColor(.accentColor)
          .frame(width: geometry.size.width * CGFloat(self.value / 100))
          .animation(.spring())
      }
      .cornerRadius(12)
      .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
        self.value = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
      }))
    }.frame(height: 40)
  }
}

struct PanelSlider_Previews: PreviewProvider {
  
  @State static var slide: Float = 0.0
  
  static var previews: some View {
    PanelSlider(value: $slide)
  }
}
