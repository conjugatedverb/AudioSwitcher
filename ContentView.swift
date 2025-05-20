// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var devices: [String] = []
    @State private var selected: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Audio Output Switcher")
                .font(.title2)
                .padding(.top)

            Picker("Select Output Device", selection: $selected) {
                ForEach(devices, id: \ .self) { device in
                    Text(device).tag(device)
                }
            }
            .pickerStyle(RadioGroupPickerStyle())
            .padding()

            Button("Transfer") {
                if let selected = selected {
                    print("Attempting to switch to: \(selected)")
                    AudioManager.setDefaultOutput(name: selected)
                }
            }
            .disabled(selected == nil)

            Spacer()
        }
        .padding()
        .frame(width: 350, height: 300)
        .onAppear {
            devices = AudioManager.getAllOutputDeviceNames()
        }
    }
}
