//
//  ContentView+Network.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import Foundation
import Combine
import HypercutFoundation
import HypercutMediaEncoder
import HypercutNetworking
import AVFoundation
import AppKit

extension ContentView {
  
  func cancelRequest() {
    self.networkingState = .canceled(Date())
  }
  
  func createUploadRequest() {
    
    self.networkingState = .uploading
    guard let fileURL = fileURL else {
      return
    }
    
    originalRuntime = AVAsset(url: fileURL).duration.seconds

    let encoder = MediaConverter(filepath: fileURL)
    
    encoder.getAudio { data in
      request = UploadAudioRequest(data)
        .publisher(for: network.baseURL)
        .sink { completion in
          switch completion {
          case .finished:
            break
          case .failure(let error):
            fatalError(error.localizedDescription)
          }
        } receiveValue: { value in
          let fileID = (value as! FileID)
          self.networkingState = .polling(fileID)
          self.createPollingRequest()
        }
    }
  }
  
  func createPollingRequest() {
    print("poll")
    guard case .polling(let fileID) = networkingState else {
      return
    }
    
    request = CutAudioRequest(fileID)
      .publisher(for: network.baseURL)
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          print(error.localizedDescription)
        }
      } receiveValue: { value in
        let response = (value as! CutResponse)
        if response.completed {
          self.networkingState = .completed(response)
          self.state = .editingHypercut
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { 
            self.createPollingRequest()
          }
        }
      }
  }
  
  var exportConfiguration: HypercutExportConfiguration {
    .init(
      pauseSpeed: pauseSpeed, 
      phraseSpeed: phraseSpeed, 
      playbackSpeed: playbackSpeed,
      highQuality: highQuality)
  }
  
  var exportPlan: HypercutExportPlan? {
    guard case .completed(let response) = networkingState else {
      return nil
    }
    
    return HypercutExportSession(
      phrases: response.phrases, 
      spaces: response.spaces)
      .createExportPlan(for: exportConfiguration)
  }
  
  var playbackSpeedText: String {
    String.init(format: "%.1f×", (playbackSpeed * 3 + 1))
  }
  
  var cutSpeed: String {
    guard
      let originalRuntime = originalRuntime,
      let exportPlan = exportPlan 
    else {
      return "nil"
    }
    
    return String.init(format: "%.1f×", (originalRuntime / exportPlan.runtime))
  }
  
  func export() {
    print("export")
    state = .exportingHypercut
    guard let fileURL = fileURL, let exportPlan = exportPlan else {
      return
    }
    
    MediaRecoder(filepath: fileURL)
      .getCut(timecodes: exportPlan) { error in
        print(error.localizedDescription)
        self.state = .editingHypercut
      } progress: { progress in
        self.exportProgress = CGFloat(progress)
      } completion: { outputURL in
        self.exportProgress = nil
        state = .editingHypercut
        NSWorkspace.shared.selectFile(outputURL.absoluteString, inFileViewerRootedAtPath: "")
        print(outputURL)
      }
  }
}
