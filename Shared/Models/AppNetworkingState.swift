//
//  AppNetworkingState.swift
//  hypercut
//
//  Created by Michael Verges on 10/26/21.
//

import Foundation
import HypercutFoundation

enum AppNetworkingState {
  case uploading
  case canceled(Date)
  case polling(FileID)
  case completed(CutResponse)
}
