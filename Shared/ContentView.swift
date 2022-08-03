//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Reiner on 6/10/22.
//

import SwiftUI
import UIKit
import func AVFoundation.AVMakeRect

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

struct ContentView: View {
    @State private var image: Image?

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showSavedAlert = false
    @State private var showErrorAlert = false

    var body: some View {
        Color("BrandColor")
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    
                    image?
                       .resizable()
                       .scaledToFit()
                    
                    Spacer()

                    HStack {
                        PillButton(text: "Browse", onClick: { showingImagePicker = true })
                        
                        Spacer()
                        
                        if image != nil {
                            PillButton(text: "Save", onClick: save)
                            
                            PillButton(text: "New", onClick: { image = nil })
                        }
                    }
                }
                    .padding([.horizontal, .bottom])
                .onChange(of: inputImage) { _ in loadImage() }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .alert("Saved image", isPresented: $showSavedAlert) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Error saving image", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) { }
                }
            )
            .accentColor(Color.black)
    }
    
    func matteImage(image: UIImage) -> UIImage {
        let maxSize = max(image.size.height, image.size.width)
        
        let size = CGSize(width: maxSize, height: maxSize)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { ctx in
            // @todo Make this dynamic
            UIColor.white.setFill()
            
            ctx.fill(CGRect(origin: .zero, size: size))
            
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: size))

            ctx.cgContext.setFillColor(UIColor.white.cgColor)

            image.draw(in: rect)
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }

        processedImage = matteImage(image: inputImage)
        
        guard let processedImage = processedImage else { return }
                        
        image = Image(uiImage: processedImage)
    }

    func save() {
        guard let processedImage = processedImage else { return }

        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            showSavedAlert = true
        }

        imageSaver.errorHandler = {
            print($0.localizedDescription)
            
            showErrorAlert = true
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
