//
//  VideoDropDelegate.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI

struct VideoDropDelegate: DropDelegate {
  
  @Binding var fileURL: URL?
  
  func validateDrop(info: DropInfo) -> Bool {
    return info.hasItemsConforming(to: ["public.file-url"])
  }
  
  func performDrop(info: DropInfo) -> Bool {
    guard let item = info.itemProviders(for: ["public.file-url"]).first else {
      return false
    }
    
    item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
      DispatchQueue.main.async {
        if let urlData = urlData as? Data {
          self.fileURL = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
          print(self.fileURL!)
        }
      }
    }
    
    return true
  }
}
