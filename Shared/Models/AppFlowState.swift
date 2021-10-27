//
//  AppFlowState.swift
//  hypercut
//
//  Created by Michael Verges on 10/23/21.
//

import Foundation

enum AppFlowState {
  case selectingFile
  case uploadingFile
  case editingHypercut
  case exportingHypercut
  
  var isSelected: Bool {
    return self != .selectingFile
  }
  
  var isUploaded: Bool {
    if self == .editingHypercut { return true }
    if self == .exportingHypercut { return true }
    return false
  }
}
