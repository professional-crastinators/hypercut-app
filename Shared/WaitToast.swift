//
//  WaitToast.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI
import HypercutNativeUI

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
  
  @State var timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
  
  var foregroundColor: Color {
    state == .waiting ? .accentColor : .black.opacity(0.05)
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
    .frame(height: 80)
    .animation(.easeInOut, value: state)
  }
  
  var loadingBody: some View {
    HStack {
      loadingIndicator
        .padding(10)
      animatedText
      Spacer()
    }
    .padding(10)
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
    LoadingIndicator()
      .foregroundColor(.white)
      .frame(width: 10, height: 10)
  }
  
  var animatedText: some View {
    VStack(spacing: 4) {
      Text(textOption)
        .font(.headline)
        .foregroundColor(.white)
        .opacity(cycles == 4 ? 0 : 1)
        .offset(x: 0, y: -4 * leftOffset)
      
      Text("This may take a few minutes")
        .font(.subheadline)
        .foregroundColor(.white.opacity(0.6))
        .offset(x: 0, y: -2 * leftOffset)
    }
    .animation(.easeInOut(duration: 1.6), value: leftOffset)
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
