//
//  AmityViewConfigController.swift
//  AmityUIKit4
//
//  Created by Zay Yar Htun on 11/28/23.
//

import SwiftUI
import UIKit
import Combine

class AmityViewConfigController: NSObject, ObservableObject {
    @Published var theme: AmityThemeColor
    let defaultLightTheme: AmityThemeColor
    
    let pageId: PageId?
    let componentId: ComponentId?
    
    init(pageId: PageId?, componentId: ComponentId? = nil) {
        self.pageId = pageId
        self.componentId = componentId
        let configId = "\(pageId?.rawValue ?? "*")/\(componentId?.rawValue ?? "*")/*"
        
        self.theme = AmityUIKitConfigController.shared.getTheme(configId: configId)
        
        self.defaultLightTheme = AmityThemeColor(primaryColor: lightTheme.primaryColor!, secondaryColor: lightTheme.secondaryColor!, baseColor: lightTheme.baseColor!, baseColorShade1: lightTheme.baseColorShade1!, baseColorShade2: lightTheme.baseColorShade2!, baseColorShade3: lightTheme.baseColorShade3!, baseColorShade4: lightTheme.baseColorShade4!, alertColor: lightTheme.alertColor!, backgroundColor: lightTheme.backgroundColor!)
    }
    
    public func updateTheme() {
        let configId = "\(pageId?.rawValue ?? "*")/\(componentId?.rawValue ?? "*")/*"
        self.theme = AmityUIKitConfigController.shared.getTheme(configId: configId)
    }
    
    public func getConfig<T>(elementId: ElementId? = nil,
                             key: String,
                             of type: T.Type) -> T? {
        let pageId = pageId?.rawValue ?? "*"
        let componentId = componentId?.rawValue ?? "*"
        let elementId = elementId?.rawValue ?? "*"
        let configId = "\(pageId)/\(componentId)/\(elementId)"
        
        let config = AmityUIKitConfigController.shared.getConfig(configId: configId)
        
        return config[key] as? T
    }
}
