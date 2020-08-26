//
//  GravityList.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct GravityList: View {
    
    // MARK: - Initialize Classes
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM: CoreMotionViewModel
    
    
    // MARK: - Define Constants / Variables
    
    // MARK: - Methods
    
    // MARK: - Body - View
    var body: some View {
        
        // MARK: - Return View
        List(motionVM.coreMotionArray.reversed(), id: \.counter) { index in
            HStack{
                Text("ID:\(motionVM.coreMotionArray[index.counter - 1].counter)", comment: "MotionListView - ID")
                Spacer()
                Text("X:\(motionVM.coreMotionArray[index.counter - 1].gravityXAxis, specifier: "%.5f")", comment: "MotionListView - X")
                Spacer()
                Text("Y:\(motionVM.coreMotionArray[index.counter - 1].gravityYAxis, specifier: "%.5f")", comment: "MotionListView - Y")
                Spacer()
                Text("Z:\(motionVM.coreMotionArray[index.counter - 1].gravityZAxis, specifier: "%.5f")", comment: "MotionListView - Z")
            }
            .font(.footnote)
        }
        .listStyle(PlainListStyle())
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 250, maxHeight: 250, alignment: .center)
    }
}


// MARK: - Preview
struct GravityList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            GravityList(motionVM: CoreMotionViewModel())
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
    }
}
