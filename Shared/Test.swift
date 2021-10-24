//
//  Test.swift
//  hypercut-native
//
//  Created by Michael Verges on 10/23/21.
//

import Foundation
import Combine
import HypercutFoundation
import HypercutMediaEncoder
import HypercutNetworking
let network = NetworkingService(baseURL: "http://128.61.11.60:5000")

var cancellable: AnyCancellable?

public func testNetwork(success: @escaping () -> ()) {
  let encoder = MediaConverter(filepath: URL.init(fileURLWithPath: "/Users/michaelverges/Downloads/test.mov"))
  
  encoder.getAudio { data in
    print("success")
    
    cancellable = UploadAudioRequest(data)
      .publisher(for: network.baseURL)
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          fatalError(error.localizedDescription)
        }
        print("completion")
        success()
      } receiveValue: { value in
        print(value)
        success()
      }
    
  }
}
