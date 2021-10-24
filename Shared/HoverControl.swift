//
//  HoverControl.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct HoverControl: View {
  
  @Binding var speed: CGFloat
  
  var title: String
  var description: String
  
  @State var isHovered: Bool = false
  @State var dragDiff: CGSize = .zero
  var isDisabled: Bool
  
  var isShadowing: Bool {
    return isHovered || dragDiff != .zero
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
        .foregroundColor(isDisabled ? .gray : .black)
      Text(description)
        .foregroundColor(isDisabled ? .gray : .primary)
        .opacity(0.8)
        .font(.subheadline)
      SpeedSlider(value: $speed, dragDiff: $dragDiff, isDisabled: isDisabled)
    }
    .padding()
    .offset(x: dragDiff.width / 2, y: dragDiff.height / 2)
    .background(hoverPanel)
    .offset(x: dragDiff.width / 2, y: dragDiff.height / 2)
    .onHover { isHovered in
      self.isHovered = isHovered && !isDisabled
    }
    .gesture(
      DragGesture(minimumDistance: 0)
        .onChanged { value in
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
        }
    )
    .disabled(isDisabled)
    .scaleEffect(isShadowing ? 1.05 : 1.0)
    .animation(.easeInOut)
  }
  
  var hoverPanel: some View {
    RoundedRectangle(cornerRadius: 20)
      .foregroundColor(.white.opacity(0.8))
      .shadow(
        color: isShadowing ? .black.opacity(0.2) : .white,
        radius: isShadowing ? 20 : 0, 
        x: 0, y: 0)
  }
}

//struct HoverControl_Previews: PreviewProvider {
//  static var previews: some View {
//    HoverControl()
//  }
//}
