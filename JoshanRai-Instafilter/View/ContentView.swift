//
//  ContentView.swift
//  JoshanRai-Instafilter
//
//  Created by Joshan Rai on 4/11/22.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    //  MARK: Variables and constants for the application
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 5.0
    @State private var filterScale = 5.0
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    @State private var showingSaveError = false
    @State private var showingSettingsScreen = false
    
    //  MARK: Body of ContentView. Displays UI elements.
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity) { _ in applyProcessing()}
                    }
                    .padding(.vertical)
                }
                
                if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius, in: 0...200)
                            .onChange(of: filterRadius) { _ in applyProcessing()}
                    }
                    .padding(.vertical)
                }
                
                if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                    HStack {
                        Text("Scale")
                        Slider(value: $filterScale, in: 0...20)
                            .onChange(of: filterScale) { _ in applyProcessing()}
                    }
                    .padding(.vertical)
                }
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(inputImage == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                //  Filters
                Group {
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                    Button("Edges") { setFilter(CIFilter.edges()) }
                    Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                    Button("Bloom") { setFilter(CIFilter.bloom()) }
                }
                
                //  Blurs
                Group {
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    Button("Disc Blur") { setFilter(CIFilter.discBlur()) }
                    Button("Bokeh Blur") { setFilter(CIFilter.bokehBlur()) }
                }
                
                //  Effects
                Group {
                    Button("Noir") { setFilter(CIFilter.photoEffectNoir()) }
                    Button("Fade") { setFilter(CIFilter.photoEffectFade()) }
                    Button("Mono") { setFilter(CIFilter.photoEffectMono()) }
                }
                
                //  Cancel Button
                Group {
                    Button("Cancel", role: .cancel) { }
                }
            }
            .alert("Oops!", isPresented: $showingSaveError) {
                Button("OK") {}
            } message: {
                Text("Something went wrong when saving your photo - please check if you have allowed this app to save photos to your device.")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettingsScreen.toggle()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettingsScreen) {
                SettingsView()
            }
        }
    }
    
    // MARK: Functions for loading, saving, and filters
    func loadImage() {
        guard let inputImage = inputImage else { return }
       
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
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
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
