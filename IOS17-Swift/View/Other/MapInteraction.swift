//
//  MapInteraction.swift
//  IOS17-Swift
//
//  Created by iamblue on 20/02/2024.
//

import SwiftUI
import MapKit

struct MapInteraction: View {
    //View props
    @State private var camera: MapCameraPosition = .region(.init(center: .applePark, span: .initialSpan))
    @State private var coordinate: CLLocationCoordinate2D = .applePark
    @State private var mapSpan: MKCoordinateSpan = .initialSpan
    @State private var annotationTitle: String = ""
    //View props
    @State private var updatesCamera: Bool = false
    @State private var displayTitle: Bool = false
    @State private var tfLocation: String = ""
    @State private var searchingLocation: Bool = false
    
    var body: some View {
        MapReader{ proxy in //ios 17
            Map(position: $camera){
                //Custom anotation view
                Annotation(displayTitle ? annotationTitle : "", coordinate: coordinate){
                    DraggblePin(proxy: proxy, coordinate: $coordinate){ coordinate in
                        findCoordinateName()
                        guard updatesCamera else { return }
                        //Optional updating camera position, when coordinate changes
                        let newRegion = MKCoordinateRegion(
                            center: coordinate, span: mapSpan
                        )
                        
                        withAnimation(.smooth) {
                            camera = .region(newRegion)
                        }
                    }
                }
            }
            .onMapCameraChange(frequency: .continuous) { ctx in
                mapSpan = ctx.region.span
            }
            .safeAreaInset(edge: .bottom){
                VStack{
                    HStack{
                        TextField("Paste the location here", text: $tfLocation)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Search") {
                            findCoordinateForAddress()
                        }
                    }
                    
                    HStack(spacing: 0){
                        Toggle("Update Camera", isOn: $updatesCamera)
                            .frame(width: 180)
                        Spacer()
                        Toggle("Display Title", isOn: $displayTitle)
                            .frame(width: 180)
                    }
                }
                .textScale(.secondary)
                .padding(15)
                .background(.ultraThinMaterial)
            }
            .onAppear(perform: findCoordinateName)
        }
    }
    
    /// Finds Name for Current Location Coordinates
    func findCoordinateName() {
        annotationTitle = ""
        Task {
            let location = CLLocation (latitude: coordinate.latitude, longitude:
                                        coordinate.longitude)
            let geoDecoder = CLGeocoder ()
            if let name=try? await
                geoDecoder.reverseGeocodeLocation (location).first?.name {
                annotationTitle = name
            }
        }
    }
    
    func findCoordinateForAddress() {
        searchingLocation = true
        annotationTitle = ""
        
        let geoDecoder = CLGeocoder()
        geoDecoder.geocodeAddressString(tfLocation) { placemarks, error in
            searchingLocation = false
            guard let placemark = placemarks?.first, let location = placemark.location else {
                // Handle error or display message that location not found
                return
            }
            
            coordinate = location.coordinate
            withAnimation {
                camera = .region(MKCoordinateRegion(center: coordinate, span: mapSpan))
            }
            findCoordinateName()
        }
    }
}

#Preview {
    MapInteraction()
}

// custom draggble pin anotation
struct DraggblePin: View {
    var tint: Color = .red
    var proxy: MapProxy
    @Binding var coordinate: CLLocationCoordinate2D
    var onCoordinateChange: (CLLocationCoordinate2D) -> ()
    //View props
    @State private var isActive: Bool = false
    @State private var translation: CGSize = .zero
    
    var body: some View {
        GeometryReader{
            let frame = $0.frame(in: .global)
            
            Image(systemName: "mappin")
                .font(.title)
                .foregroundStyle(tint.gradient)
                .animation(.snappy, body: { content in
                    content
                    //Scaling on active
                        .scaleEffect(isActive ? 1.3 : 1, anchor: .bottom)
                })
                .frame(width: frame.width, height: frame.height)
                .onChange(of: isActive, initial: false) { oldValue, newValue in
                    let position = CGPoint(x: frame.midX, y: frame.midY)
                    //Converting position into location coordinate using map proxy
                    if let coordinate = proxy.convert(position, from: .global), !newValue{
                        //updating coordinate based on translation and resetting translation to zero
                        self.coordinate = coordinate
                        translation = .zero
                        onCoordinateChange(coordinate)
                    }
                }
        }
        .frame(width: 30, height: 30)
        .contentShape(.rect)
        .offset(translation)
        .gesture(
            LongPressGesture(minimumDuration: 0.15)
                .onEnded {
                    isActive = $0
                }
                .simultaneously(with: DragGesture(minimumDistance: 0)
                    .onChanged{ value in
                        if isActive { translation = value.translation }
                    }
                    .onEnded { value in
                        if isActive { isActive = false }
                    }
                )
        )
    }
}

//Static value
extension MKCoordinateSpan{
    static var initialSpan: MKCoordinateSpan{
        return .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
}

extension CLLocationCoordinate2D{
    static var applePark: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: 37.334606, longitude: -122.009102)
    }
}
