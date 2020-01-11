//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AltitudeView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency: Float = SettingsAPI.shared.fetchFrequency() // Default Frequency
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.altitudeUpdateStart()
    }
    
    func onDisappear() {
        CoreMotionAPI.shared.motionUpdateStart()
        motionVM.coreMotionArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return List {
            Text("Pressure: \(CalculationAPI.shared.calculatePressure(pressure: self.motionVM.altitudeArray.last?.pressureValue ?? 0.0, to: SettingsAPI.shared.fetchPressureSetting()), specifier: "%.5f") \(SettingsAPI.shared.fetchPressureSetting())")
            Text("Altitude change: \(CalculationAPI.shared.calculateHeight(height: self.motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0, to: SettingsAPI.shared.fetchHeightSetting()), specifier: "%.5f") \(SettingsAPI.shared.fetchHeightSetting())")
        }
        .navigationBarTitle("Altitude")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}


// MARK: - Preview
struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AltitudeView().previewDevice("Apple Watch Series 3 - 38mm")
            AltitudeView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}