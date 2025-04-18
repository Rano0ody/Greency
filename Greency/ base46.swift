//
//   base46.swift
//  Greency
//
//  Created by bayan alshammri on 16/04/2025.
//


import UIKit

extension UIImage {
    /// Convert UIImage to a Base64 string
    func toBase64() -> String? {
        return self.jpegData(compressionQuality: 0.8)?.base64EncodedString()
    }

    /// Convert a Base64 string to UIImage
    static func fromBase64(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
