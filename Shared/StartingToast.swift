//
//  StartingToast.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct StartingToast: View {
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 10) {
        
        
        HStack(alignment: .bottom) {
          Text("Welcome to ")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.black)
          
          Image("hypercut-logo", bundle: .main)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 40)
            .offset(x: 0, y: 36)
            .padding(.bottom, 30)
        }
        Text("Watch what matters.")
          .font(.title)
          .foregroundColor(.black.opacity(0.6))
        Text("Hypercut shortens your video and audio files, so you can get the most important parts. Using Natural Language Processing, Hypercut identifies long pauses and prioritizes content. The Hypercut media re-encoder rebuilds the media with the speed parameters you choose. Select a file to get started.")
          .font(.body)
          .foregroundColor(.black.opacity(0.6))
          .padding(.top, 20)
      }
      Spacer()
    }
  }
}

struct StartingToast_Previews: PreviewProvider {
  static var previews: some View {
    StartingToast()
  }
}
