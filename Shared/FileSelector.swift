//
//  FileSelector.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI
import Combine
import HypercutFoundation
import HypercutMediaEncoder
import HypercutNetworking

struct FileSelector: View {
  
  @Binding var fileURL: URL?
  var isDisabled: Bool
  
  func showOpenPanel() -> URL? {
    let openPanel = NSOpenPanel()
    openPanel.allowedFileTypes = ["mov", "m4a"]
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
  }
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .foregroundColor(.black.opacity(0.05))
        .onDrop(of: ["public.file-url"], delegate: VideoDropDelegate(fileURL: $fileURL))
      
      RoundedRectangle(cornerRadius: 10)
        .stroke(
          Color.black.opacity(0.2), 
          style: .init(
            lineWidth: 2, 
            lineCap: .butt, 
            lineJoin: .miter, 
            miterLimit: 0, 
            dash: [6, 8], 
            dashPhase: 0))
        .padding(10)
      
      if fileURL != nil {
        VStack(spacing: 30) {
          Thumbnail(fileURL: $fileURL)
          
          if !isDisabled {
            VStack {
              Text("Drop to replace.")
                .font(.headline)
                .foregroundColor(.primary.opacity(0.8))
              HStack {
                Text("Or")
                  .font(.body)
                  .foregroundColor(.primary.opacity(0.8))
                Button { 
                  fileURL = showOpenPanel()
                } label: { 
                  Text("choose a file")
                }
              }
            }
          }
        }
      } else {
        
        VStack {
          Text("Drop media here.")
            .font(.headline)
            .foregroundColor(.primary.opacity(0.8))
          HStack {
            Text("Or")
              .font(.body)
              .foregroundColor(.primary.opacity(0.8))
            Button { 
              fileURL = showOpenPanel()
            } label: { 
              Text("choose a file")
            }
          }
        }
      }
    }
    .frame(minHeight: 250)
  }
}

//struct FileSelector_Previews: PreviewProvider {
//  static var previews: some View {
//    FileSelector()
//  }
//}
