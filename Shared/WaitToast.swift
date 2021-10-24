//
//  WaitToast.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct WaitToast: View {
  
  @Binding var state: WaitToastState {
    didSet {
      if state == .waiting {
        timer = Timer
          .publish(every: 1.6, on: .main, in: .common).autoconnect()
      } else {
        timer.upstream.connect().cancel()
      }
    }
  }
  
  @State var leftOffset: CGFloat = 0
  @State var rightOffset: CGFloat = 1
  
  
  @State var cycles: Int = 0
  @State var textOptionIndex: Int = 0
  @State var textOption: String = "Analyzing your media"
  
  var diameter: CGFloat = 8
  
  var animation: Animation? {
    state == .waiting ? .easeInOut(duration: 1) : .none
  }
  
  @State var timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
  
  var foregroundColor: Color {
    state == .waiting ? .accentColor : .black.opacity(0.05)
  }
  
  var height: CGFloat {
    state == .waiting ? 120 : 80
  }
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .foregroundColor(foregroundColor)
      if state == .waiting {
        loadingBody
      } else {
        completedBody
      }
    }
    .frame(height: height)
    .animation(.easeInOut)
  }
  
  var loadingBody: some View {
    VStack {
      Spacer()
      animatedText
      Spacer()
      loadingIndicator
    }
    .padding(40)
  }
  
  var completedBody: some View {
    HStack(alignment: .top) {
      Image(systemName: "checkmark.circle.fill")
        .font(.headline)
        .foregroundColor(.black)
      VStack(alignment: .leading, spacing: 4) {
        Text("Media Processed")
          .font(.headline)
          .foregroundColor(.black)
        Text("Drag the sliders below to make your hypercut")
          .font(.subheadline)
          .multilineTextAlignment(.leading)
          .foregroundColor(.black.opacity(0.6))
      }
      Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
  }
  
  var loadingIndicator: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        Circle()
          .fill(Color.white.opacity(0.9))
          .frame(width: diameter, height: diameter)
          .offset(x: (geometry.size.width - diameter / 2) * leftOffset)
          .animation(animation)
        Circle()
          .fill(Color.white)
          .frame(width: diameter, height: diameter)
          .offset(x: (geometry.size.width - diameter / 2) * leftOffset)
          .animation(animation?.delay(0.2))
        Circle()
          .fill(Color.white.opacity(0.9))
          .frame(width: diameter, height: diameter)
          .offset(x: (geometry.size.width - diameter / 2) * leftOffset)
          .animation(animation?.delay(0.4))
      }
    }
    .frame(height: diameter)
    .opacity(state == .waiting ? 1 : 0)
    .onReceive(timer) { (_) in
      swap(&self.leftOffset, &self.rightOffset)
    }
  }
  
  var animatedText: some View {
    VStack(spacing: 4) {
      Text(textOption)
        .font(.headline)
        .foregroundColor(.white)
        .opacity(cycles == 4 ? 0 : 1)
        .offset(x: 0, y: -4 * leftOffset)
        .animation(.easeInOut(duration: 1.6))
      
      Text("This may take a few minutes")
        .font(.subheadline)
        .foregroundColor(.white.opacity(0.6))
        .offset(x: 0, y: -2 * leftOffset)
        .animation(.easeInOut(duration: 1.6))
    }
    .onReceive(timer) { (_) in
      cycles += 1
      if cycles < 5 { return }
      cycles = 0
      
      let options = [
        "Uploading your media",
        "Analyzing audio",
        "Detecting pauses",
        "Building transcript",
        "Prioritizing phrases",
        "Optimizing time",
        "Extracting Features"
      ]
      
      textOptionIndex += 1
      if textOptionIndex == options.count { textOptionIndex = 0 }
      
      textOption = options[textOptionIndex]
    }
  }
  
}

enum WaitToastState {
  case noFile
  case waiting
  case complete
}

//struct WaitToast_Previews: PreviewProvider {
//  static var previews: some View {
//    WaitToast()
//  }
//}
