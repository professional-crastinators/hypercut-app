//
//  ProductToast.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct ProductToast: View {
  
  var isDisabled: Bool
  
  var speed: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .foregroundColor(.black.opacity(0.05))
      VStack(alignment: .leading, spacing: 4) {
        Text("Export Details")
          .font(.headline)
          .foregroundColor(isDisabled ? .gray : .black)
        if isDisabled {
          disabledBody
        } else {
          HStack {
            Spacer()
            summaryBody
            Spacer()
          }
        }
        
      }
      .padding(20)
    }
    .animation(.easeInOut)
  }
  
  var disabledBody: some View {
    Text("Details will appear here after your media is processed.")
      .font(.subheadline)
      .multilineTextAlignment(.leading)
      .foregroundColor(.gray.opacity(0.6))
  }
  
  var summaryBody: some View {
    VStack {
      Spacer()
      statText("\(speed)  faster")
        .foregroundColor(.clear)
        .overlay(LinearGradient(
          gradient: .init(colors: [
            .accentColor, 
            .red, 
            .init("BonusColor", bundle: .main)
          ]), startPoint: .bottomLeading, endPoint: .topTrailing)
                  .mask(statText("\(speed)  faster")))
      Text("with hypercut")
        .font(.title2)
        .fontWeight(.black)
        .multilineTextAlignment(.leading)
      Spacer()
    }
  }
  
  func statText(_ string: String) -> some View {
    Text(string)
      .font(.largeTitle)
      .fontWeight(.black)
      .multilineTextAlignment(.leading)
  }
}

struct ProductToast_Previews: PreviewProvider {
  static var previews: some View {
    ProductToast(isDisabled: false, speed: "2.3x")
  }
}
