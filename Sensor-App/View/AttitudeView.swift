//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AttitudeView: View {
    
    // MARK: - Initialize Classes
    let locationAPI = CoreLocationAPI()
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0
    @State private var showSettings = false
    
    // Show Graph
    @State private var showRoll = false
    @State private var showPitch = false
    @State private var showYaw = false
    @State private var showHeading = false
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Initializer
    init() {
        frequency = settings.fetchUserSettings().frequencySetting
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }
    
    
    // MARK: - Methods
    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?
        
        switch button {
            case .play:
                motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                motionVM.stopMotionUpdates()
                messageType = .paused
            case .delete:
                self.motionVM.coreMotionArray.removeAll()
                self.motionVM.altitudeArray.removeAll()
                messageType = .deleted
            case .settings:
                motionVM.stopMotionUpdates()
                showSettings.toggle()
                messageType = nil
        }
        
        if messageType != nil {
            notificationAPI.toggleNotification(type: messageType!, duration: self.notificationDuration) { (message, show) in
                self.notificationMessage = message
                self.showNotification = show
            }
        }
    }
    
    func updateSensorInterval() {
        motionVM.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
    }
    
    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return ZStack {
            LinearGradient(gradient: Gradient(colors: settings.backgroundColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                VStack{
                    ScrollView(.vertical) {
                        Spacer()
                        VStack{
                            Group{
                                Text("Roll: \((self.motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                    .modifier(ButtonModifier())
                                    .overlay(Button(action: { self.showRoll.toggle() }) {
                                        Image("GraphButton")
                                            .foregroundColor(.white)
                                            .offset(x: -10)
                                    }.accessibility(identifier: "Toggle Roll Graph"), alignment: .trailing)
                                
                                if self.showRoll == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeRoll)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Pitch: \((self.motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                    .modifier(ButtonModifier())
                                    .overlay(Button(action: { self.showPitch.toggle() }) {
                                        Image("GraphButton")
                                            .foregroundColor(.white)
                                            .offset(x: -10)
                                    }.accessibility(identifier: "Toggle Pitch Graph"), alignment: .trailing)
                                
                                if self.showPitch == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudePitch)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Yaw: \((self.motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                    .modifier(ButtonModifier())
                                    .overlay(Button(action: { self.showYaw.toggle() }) {
                                        Image("GraphButton")
                                            .foregroundColor(.white)
                                            .offset(x: -10)
                                    }.accessibility(identifier: "Toggle Yaw Graph"), alignment: .trailing)
                                
                                if self.showYaw == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeYaw)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Heading: \(self.motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°")
                                    .modifier(ButtonModifier())
                                    .overlay(Button(action: { self.showHeading.toggle() }) {
                                        Image("GraphButton")
                                            .foregroundColor(.white)
                                            .offset(x: -10)
                                    }.accessibility(identifier: "Toggle Heading Graph"), alignment: .trailing)
                                
                                if self.showHeading == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeHeading)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .frame(height: 50, alignment: .center)
                            
                            
                            // MARK: - MotionListView()
                            MotionListView(type: .attitude, motionVM: self.motionVM)
                                .frame(minHeight: 250, maxHeight: .infinity)
                            
                            
                            // MARK: - RefreshRateViewModel()
                            RefreshRateView(updateSensorInterval: { self.updateSensorInterval() })
                                .frame(width: g.size.width, height: 170, alignment: .center)
                        }
                    }
                    .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                    .offset(x: 5)
                    
                    
                    // MARK: - MotionToolBarView()
                    ToolBarView(toolBarFunctionClosure: self.toolBarButtonTapped(button:))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
        .navigationBarTitle("Attitude", displayMode: .inline)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showSettings) { SettingsView() }
    }
}


// MARK: - Preview
struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AttitudeView()
                    .colorScheme(scheme)
            }
        }
    }
}
