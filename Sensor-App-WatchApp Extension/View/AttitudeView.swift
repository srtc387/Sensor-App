//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct
struct AttitudeView: View {

    // MARK: - Initialize Classes
    let settings = SettingsAPI()

    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0 // Default Frequency

    // MARK: - Define Constants / Variables

    // MARK: - Initializer
    init() {
        frequency = settings.fetchUserSettings().frequencySetting
    }

    // MARK: - Methods

    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
        motionVM.sensorUpdateInterval = frequency
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
    }

    // MARK: - Body - View
    var body: some View {

        // MARK: - Return View
        return List {
            //swiftlint:disable line_length
            Text("Roll: \((motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Roll (watchOS)")
            Text("Pitch: \((motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Pitch (watchOS)")
            Text("Yaw: \((motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Yaw (watchOS)")
            Text("Heading: \(motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°", comment: "AttitudeView - Heading (watchOS)")
            //swiftlint:enable line_length
        }
        .navigationBarTitle("\(NSLocalizedString("Attitude", comment: "AttitudeView - NavigationBar Title (watchOS)"))")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}

// MARK: - Preview
struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AttitudeView().previewDevice("Apple Watch Series 3 - 38mm")
            AttitudeView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}
