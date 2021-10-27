//
//  ContentView.swift
//  Shared
//
//  Created by Michael Verges on 10/23/21.
//

import SwiftUI
import Combine
import AVFoundation
import HypercutNativeUI

struct ContentView: View {
  
  @State var state: AppFlowState = .editingHypercut {
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
  @State var qualitySelection: Int = 1
  
  var highQuality: Bool {
    return qualitySelection == 1
  }
  
  var body: some View {
    HStack(alignment: .top) {
      dropColumn
      if state.isSelected {
        editColumn
      }
    }
    .animation(.spring(), value: state)
    .padding()
    .background(Color.white)
  }
  
  var dropColumn: some View {
    VStack(spacing: 40) {
      if !state.isSelected {
        StartingToast()
      }
      FileSelector(fileURL: $fileURL)
        .disabled(state.isSelected)
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
        .buttonStyle(PanelButtonStyle(.accentColor))
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
          .buttonStyle(ProgressPanelButtonStyle(state == .editingHypercut ? .accentColor : .gray, progress: exportProgress))
          .disabled((state, exportProgress).0 != .editingHypercut)
          .frame(maxWidth: 300)
          .accentColor(.init("BonusColor", bundle: .main))
        }
      }
    }
    .frame(minWidth: 300)
    .padding()
  }
  
  var editColumn: some View {
    VStack(alignment: .leading, spacing: 20) {
      
      HoverControl { 
        VStack(alignment: .leading) {
          Text("Shorten Pauses")
            .font(.headline)
          Text("Reduce the length of pauses.")
            .font(.subheadline)
        }
      } control: {
        PanelSlider(value: $pauseSpeed) { value in
          SpeedIndicator(value: pauseSpeed)
        }
      }
      .disabled(state != .editingHypercut)

      HoverControl { 
        VStack(alignment: .leading) {
          Text("Remove Phrases")
            .font(.headline)
          Text("Reduce the number of phrases.")
            .font(.subheadline)
        }
      } control: { 
        PanelSlider(value: $phraseSpeed) { value in
          SpeedIndicator(value: phraseSpeed)
        }
      }
      .disabled(state != .editingHypercut)
      
      HoverControl { 
        VStack(alignment: .leading) {
          Text("Video Playback")
            .font(.headline)
          Text("Speed up playback of the entire video by \(playbackSpeedText).")
            .font(.subheadline)
        }
      } control: { 
        PanelSlider(value: $playbackSpeed) { value in
          Text(String(format: "%.2f", value * 3 + 1))
            .font(.headline)
            .padding(.horizontal, 8)
            .foregroundColor(value > 0.08 ? .white : .gray)
        }
      }
      .disabled(state != .editingHypercut)
      
      HoverControl { 
        VStack(alignment: .leading) {
          Text("Export Quality")
            .font(.headline)
          Text("This will set the resolution of your file.")
            .font(.subheadline)
        }
      } control: {
        PanelSegmentedControl(selection: $qualitySelection) { 
          Text("Medium")
          Text("High")
        }
      }
      .disabled(state != .editingHypercut)
      
      if state.isUploaded {
        ProductToast(speed: cutSpeed)
          .disabled(state != .editingHypercut)
      }
    }
    .frame(width: 340)
    .padding()
  }
}
