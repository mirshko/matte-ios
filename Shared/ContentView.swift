//
//  ContentView.swift
//  Shared
//
//  Created by Jeff Reiner on 6/10/22.
//

import SwiftUI
import UIKit
import func AVFoundation.AVMakeRect

struct ContentView: View {
    @State private var image: Image?

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?

    var body: some View {
        Color.pink
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
            )
            .accentColor(Color.black)
    }
    
    func matteImage(image: UIImage) -> UIImage {
        var maxSize = max(image.size.height, image.size.width)
        
        if (maxSize >= 1000) {
            maxSize = 1000
        }
        
        let size = CGSize(width: maxSize, height: maxSize)
        
        let renderer = UIGraphicsImageRenderer(size: size)

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
            print("Success!")
        }

        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
