//
//  Thumbnail.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI
import AVFoundation

struct Thumbnail: View {
  
  @Binding var fileURL: URL?
  
  var thumbnail: CGImage? {
    guard let fileURL = fileURL else {
      return nil
    }

    do {
      let asset = AVURLAsset(url: fileURL)
      let imageGenerator = AVAssetImageGenerator(asset: asset)
      imageGenerator.appliesPreferredTrackTransform = true
      
      // Swift 5.3
      let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                   actualTime: nil)
      
      return cgImage
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  var filename: String? {
    return fileURL?.path.components(separatedBy: "/").last
  }
  
  var body: some View {
    VStack(alignment: .center) {
      if let filename = filename {
        
        Group {
          if let thumbnail = thumbnail {
            Image(thumbnail, scale: 1, label: Text(filename))
              .resizable()
              .aspectRatio(contentMode: .fit)
          } else {
            Rectangle()
          }
        }
        .frame(height: 80)
        .cornerRadius(6)
        
        Text(filename)
          .font(.headline)
          .foregroundColor(.primary.opacity(0.8))
      }
    }
  }
}

//struct Thumbnail_Previews: PreviewProvider {
//  static var previews: some View {
//    Thumbnail()
//  }
//}
