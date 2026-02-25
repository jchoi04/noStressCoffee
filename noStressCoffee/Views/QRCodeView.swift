//
//  QRCodeView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/25/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let customerId: String
    
    var body: some View {
        Image(uiImage: generateQRCode(from: customerId))
            .resizable()
            .interpolation(.none)
            .scaledToFit()
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            // scale image
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
#Preview {
    QRCodeView(customerId: "James")
}
