//
//  InfoTextField.swift
//  AmityUIKit4
//
//  Created by Zay Yar Htun on 1/23/24.
//

import SwiftUI

struct InfoTextFieldModel {
    var title: String
    var placeholder: String
    var isMandatory: Bool
    var infoMessage: String?
    var errorMessage: String?
    var maxCharCount: Int?
}

extension InfoTextField: AmityViewBuildable {
    public func alertColor(_ value: UIColor) -> Self {
        mutating(keyPath: \.alertColor, value: value)
    }
    
    public func dividerColor(_ value: UIColor) -> Self {
        mutating(keyPath: \.dividerColor, value: value)
    }
    
    public func infoTextColor(_ value: UIColor) -> Self {
        mutating(keyPath: \.infoTextColor, value: value)
    }
    
    public func textFieldTextColor(_ value: UIColor) -> Self {
        mutating(keyPath: \.textFieldTextColor, value: value)
    }
}

struct InfoTextField: View {
    @Binding var data: InfoTextFieldModel
    @Binding var text: String
    @Binding var isValid: Bool
    
    @State private var charCount: Int = 0
    
    private let titleTextAccessibilityId: String?
    private let textFieldAccessibilityId: String?
    private let descriptionTextAccessibilityId: String?
    private let charCountTextAccessibilityId: String?
    
    private var alertColor: UIColor = UIColor(hex: "#FA4D30")
    private var dividerColor: UIColor = UIColor(hex: "#EBECEF")
    private var infoTextColor: UIColor = UIColor(hex: "#898E9E")
    private var textFieldTextColor: UIColor = UIColor(hex: "#000000")
    
    init(data: Binding<InfoTextFieldModel>,
         text: Binding<String>,
         isValid: Binding<Bool>,
         titleTextAccessibilityId: String? = nil,
         textFieldAccessibilityId: String? = nil,
         descriptionTextAccessibilityId: String? = nil,
         errorTextAccessibilityId: String? = nil,
         charCountTextAccessibilityId: String? = nil) {
        self._data = data
        self._text = text
        self._isValid = isValid
        
        self.titleTextAccessibilityId = titleTextAccessibilityId
        self.textFieldAccessibilityId = textFieldAccessibilityId
        self.descriptionTextAccessibilityId = descriptionTextAccessibilityId
        self.charCountTextAccessibilityId = charCountTextAccessibilityId
    }

    
    var body: some View {
        var textFieldLineColor = isValid ? dividerColor : alertColor
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(data.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(textFieldTextColor))
                    .accessibilityIdentifier(titleTextAccessibilityId ?? "titleTextAccessibilityId")
                
                if data.isMandatory {
                    Text(" *")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(alertColor))
                }
                
                Spacer()
                if let limitedCharCount = data.maxCharCount {
                    Text("\(charCount)/\(limitedCharCount)")
                        .font(.system(size: 13))
                        .foregroundColor(Color(infoTextColor))
                        .accessibilityIdentifier(charCountTextAccessibilityId ?? "charCountTextAccessibilityId")
                }
            }
            .padding(.bottom, 20)
            
            TextField(data.placeholder, text: $text)
                .font(.system(size: 15))
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: text) { newText in
                    guard let limitedCharCount = data.maxCharCount else { return }
                    charCount = newText.count
                    if charCount >= limitedCharCount {
                        text = String(newText.prefix(limitedCharCount))
                    }
                }
                .foregroundColor(Color(textFieldTextColor))
                .accessibilityIdentifier(textFieldAccessibilityId ?? "textFieldAccessibilityId")
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(textFieldLineColor))
                .padding(.top, 16)
            
            if !(data.infoMessage ?? "").isEmpty || !(data.errorMessage ?? "").isEmpty && !isValid {
                Text(isValid ? (data.infoMessage ?? "") : (data.errorMessage ?? data.infoMessage ?? ""))
                    .foregroundColor(isValid ? Color(infoTextColor) : Color(alertColor))
                    .font(.system(size: 13))
                    .padding(.top, 8)
                    .accessibilityIdentifier(descriptionTextAccessibilityId ?? "descriptionTextAccessibilityId")
            }
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
    }
}
