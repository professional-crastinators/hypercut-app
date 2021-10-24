//
//  SpeedSlider.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct SpeedSlider: View {
  
  @Binding var value: CGFloat
  
  @Binding var dragDiff: CGSize
  
  var isDisabled: Bool
  
  init(
    value: Binding<CGFloat>, 
    dragDiff: Binding<CGSize> = .constant(.zero),
    isDisabled: Bool = false
  ) {
    self._value = value
    self._dragDiff = dragDiff
    self.isDisabled = isDisabled
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        
        Rectangle()
          .foregroundColor(.white.opacity(0.6))
        
        Rectangle()
          .foregroundColor(isDisabled ? .gray : .accentColor)
          .frame(width: geometry.size.width * value)
          .animation(.spring())
        if !isDisabled {
          HStack(spacing: 0) { 
            if value > 0.25 {
              Spacer()
            }
            SpeedIndicator(value: $value)
              .foregroundColor(value > 0.08 ? .white : .gray)
          }
          .frame(width: max(geometry.size.width * value, 50))
          .animation(.spring())
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            self.value = min(max(0, value.location.x / geometry.size.width), 1)
            var diff = CGSize.zero
            if value.translation.width < 0 {
              diff.width = -sqrt(-value.translation.width) / 2
            } else {
              diff.width = sqrt(value.translation.width) / 2
            }
            
            if value.translation.height < 0 {
              diff.height = -sqrt(-value.translation.height) / 2
            } else {
              diff.height = sqrt(value.translation.height) / 2
            }
            dragDiff = diff
          }.onEnded { _ in
            dragDiff = .zero
          })
      .disabled(isDisabled)
    }
    .frame(height: isDisabled ? 10 : 40)
    .shadow(
      color: isDisabled ? .clear : .accentColor.opacity(0.8 * value),
      radius: 10, 
      x: 0, y: 0)
    .shadow(
      color: .black.opacity(0.2),
      radius: 10, 
      x: 0, y: 0)
    .mask(RoundedRectangle(cornerRadius: isDisabled ? 3 : 10))
  }
}
