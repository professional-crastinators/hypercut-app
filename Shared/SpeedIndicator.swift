//
//  SpeedIndicator.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct SpeedIndicator: View {
  
  @Binding var value: CGFloat
  
  let minTail: CGFloat = 4
  let maxTail: CGFloat = 50
  
  var body: some View {
    Group {
      if value < 0.10 {
        slow
      } else if value < 0.30 {
        slow
      } else {
        fast
      }
    }
    .padding(.horizontal, 8)
    .animation(.spring())
  }
  
  var slow: some View {
    Image(systemName: "tortoise.fill")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30)
  }
  
  var fast: some View {
    HStack {
      if value > 0.5 {
        tail
      }
      Image(systemName: "hare.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 30)
    }
  }
  
  var tail: some View {
    VStack(alignment: .trailing, spacing: 4) {
      RoundedRectangle(cornerRadius: 2)
        .frame(
          width: max(minTail, maxTail * (value - 0.5)), 
          height: 4)
      
      RoundedRectangle(cornerRadius: 2)
        .frame(
          width: max(minTail, maxTail * (value - 0.5)), 
          height: 4)
        .offset(x: -8, y: 0)
      
      RoundedRectangle(cornerRadius: 2)
        .frame(
          width: max(minTail, maxTail * (value - 0.5)), 
          height: 4)
    }
  }
  
}

struct SpeedIndicator_Previews: PreviewProvider {
  
  static var previews: some View {
    Group {
      SpeedIndicator(value: .constant(0.0))
      SpeedIndicator(value: .constant(0.4))
      SpeedIndicator(value: .constant(0.6))
      SpeedIndicator(value: .constant(0.8))
      SpeedIndicator(value: .constant(1.0))
    }
  }
}
