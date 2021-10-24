//
//  QualitySelector.swift
//  hypercut
//
//  Created by Michael Verges on 10/24/21.
//

import SwiftUI

struct QualitySelector: View {
  
  @Binding var highQuality: Bool
  
  var title: String
  var description: String
  var isDisabled: Bool
  
  var isShadowing: Bool {
    return isHovered || dragDiffLeft != .zero || dragDiffRight != .zero
  }
  
  @State var isHovered: Bool = false
  
  @State var isHoveredLeft: Bool = false
  @State var isHoveredRight: Bool = false
  @State var dragDiffLeft: CGSize = .zero
  @State var dragDiffRight: CGSize = .zero

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
        .foregroundColor(isDisabled ? .gray : .black)
      Text(description)
        .foregroundColor(isDisabled ? .gray : .primary)
        .opacity(0.8)
        .font(.subheadline)
      HStack {
        left
        right
      }
    }
    .onHover { isHovered in
      self.isHovered = isHovered && !isDisabled
    }
    .padding()
    .background(hoverPanel)
    .offset(x: dragDiffRight.width / 2, y: dragDiffRight.height / 2)
    .offset(x: dragDiffLeft.width / 2, y: dragDiffLeft.height / 2)
    .animation(.easeInOut)
  }
  
  var left: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundColor(
        highQuality || isDisabled
          ? Color.black.opacity(0.05) 
          : Color.accentColor)
      .frame(height: 40)
      .overlay(
        Text("Medium")
          .font(.headline)
          .foregroundColor(
            highQuality || isDisabled
              ? Color.gray
              : Color.white))
      .onHover { isHovered in
        self.isHoveredLeft = isHovered && !isDisabled && dragDiffRight == .zero
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            highQuality = false
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
            dragDiffLeft = diff
          }.onEnded { _ in
            dragDiffLeft = .zero
          }
      )
      .disabled(isDisabled)
      .scaleEffect(isHoveredLeft ? 1.02 : 1.0)
      .offset(x: dragDiffLeft.width / 2, y: dragDiffLeft.height / 2)
  }
  
  var right: some View {
    RoundedRectangle(cornerRadius: 10)
      .foregroundColor(
        highQuality && !isDisabled
          ? Color.accentColor
          : Color.black.opacity(0.05))
      .frame(height: 40)
      .overlay(
        Text("High")
          .font(.headline)
          .foregroundColor(
            highQuality && !isDisabled
              ? Color.white
              : Color.gray))
      .onHover { isHovered in
        self.isHoveredRight = isHovered && !isDisabled && dragDiffLeft == .zero
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            highQuality = true
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
            dragDiffRight = diff
          }.onEnded { _ in
            dragDiffRight = .zero
          }
      )
      .disabled(isDisabled)
      .scaleEffect(isHoveredRight ? 1.02 : 1.0)
      .offset(x: dragDiffRight.width / 2, y: dragDiffRight.height / 2)
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
