//
//  ContentView.swift
//  Shared
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI
import Combine
import AVFoundation

struct ContentView: View {
  
  @State var state: AppFlowState = .selectingFile {
    didSet {
      if state == .uploadingFile {
        waitToastState = .waiting
      } else {
        waitToastState = .complete
      }
    }
  }
  
  @State var networkingState: AppNetworkingState?
  @State var waitToastState: WaitToastState = .waiting
  @State var pollingTimer: Timer?
  
  @State var originalRuntime: Double?
  @State var fileURL: URL?
  
  
  @State var request: AnyCancellable?
  @State var exportProgress: CGFloat?
  
  @State var pauseSpeed: CGFloat = 0.7
  @State var phraseSpeed: CGFloat = 0.0
  @State var playbackSpeed: CGFloat = 0.0
  @State var highQuality: Bool = false
  
  var body: some View {
    HStack(alignment: .top) {
      dropColumn
      if state.isSelected {
        editColumn
      }
    }
    .animation(.spring())
    .padding()
    .background(Color.white)
  }
  
  var dropColumn: some View {
    VStack(spacing: 40) {
      if !state.isSelected {
        StartingToast()
      }
      FileSelector(fileURL: $fileURL, isDisabled: state.isSelected)
      if state.isSelected {
        WaitToast(state: $waitToastState)
      }
      HStack {
        
        Button { 
          createUploadRequest()
          if state.isUploaded {
            state = .selectingFile
          } else {
            state = .uploadingFile
          }
        } label: { 
          if state.isSelected {
            Label("Cancel", systemImage: "xmark.square.fill")
          } else {
            Text("Upload")
          }
        }
        .buttonStyle(PanelButtonStyle())
        .accentColor(
          fileURL == nil ? .gray : .accentColor)
        .disabled(fileURL == nil)
        .frame(maxWidth: 300)
        if state.isSelected {
          Spacer()
          Button {
            state = .exportingHypercut
            export()
          } label: {
            Label("Export Hypercut", systemImage: "square.and.arrow.down.fill")
              .disabled(state != .editingHypercut)
          }
          .buttonStyle(ProgressPanelButtonStyle(progress: exportProgress, accentColor: state == .editingHypercut ? .accentColor : .gray))
          .disabled((state, exportProgress).0 != .editingHypercut)
          .frame(maxWidth: 300)
          .accentColor(.init("BonusColor", bundle: .main))
        }
      }
    }
    .frame(minWidth: 300)
    .animation(.spring())
    .padding()
  }
  
  var editColumn: some View {
    VStack(alignment: .leading, spacing: 20) {
      HoverControl(
        speed: $pauseSpeed,
        title: "Shorten Pauses",
        description: "Reduce the length of pauses.",
        isDisabled: state != .editingHypercut)
      
      HoverControl(
        speed: $phraseSpeed,
        title: "Remove Phrases",
        description: "Reduce the number of phrases.",
        isDisabled: state != .editingHypercut)
      
      HoverControl(
        speed: $playbackSpeed,
        title: "Video Playback",
        description: "Speed up playback of the entire video by \(playbackSpeedText).",
        isDisabled: state != .editingHypercut)
      
      QualitySelector(
        highQuality: $highQuality,
        title: "Export Quality",
        description: "This will set the resolution of your file.",
        isDisabled: state != .editingHypercut)
      
      if state.isUploaded {
        ProductToast(isDisabled: state != .editingHypercut, speed: cutSpeed)
      }
    }
    .frame(width: 340)
    .padding()
  }
}
