// AudioManager.swift
import CoreAudio
import Foundation

struct AudioDevice {
    let id: AudioDeviceID
    let name: String
}

enum AudioManager {
    static func getAllOutputDevices() -> [AudioDevice] {
        var propAddr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        var dataSize: UInt32 = 0
        AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &propAddr, 0, nil, &dataSize)

        let count = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
        var deviceIDs = [AudioDeviceID](repeating: 0, count: count)
        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &propAddr, 0, nil, &dataSize, &deviceIDs)

        var results: [AudioDevice] = []
        var seenNames = Set<String>()
        let filteredNames: Set<String> = [
            "Background Music",
            "Background Music (UI Sounds)"
        ]

        for deviceID in deviceIDs {
            var streamSize: UInt32 = 0
            var streamAddr = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyStreamConfiguration,
                mScope: kAudioDevicePropertyScopeOutput,
                mElement: kAudioObjectPropertyElementMain
            )

            guard AudioObjectHasProperty(deviceID, &streamAddr),
                  AudioObjectGetPropertyDataSize(deviceID, &streamAddr, 0, nil, &streamSize) == noErr else {
                continue
            }

            let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: Int(streamSize))
            defer { bufferList.deallocate() }

            if AudioObjectGetPropertyData(deviceID, &streamAddr, 0, nil, &streamSize, bufferList) != noErr {
                continue
            }

            let buffers = UnsafeMutableAudioBufferListPointer(bufferList)
            let totalChannels = buffers.reduce(0) { $0 + Int($1.mNumberChannels) }
            if totalChannels == 0 { continue }

            var nameRef: Unmanaged<CFString>?
            var nameSize = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
            var nameAddr = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyDeviceNameCFString,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain
            )

            guard AudioObjectGetPropertyData(deviceID, &nameAddr, 0, nil, &nameSize, &nameRef) == noErr,
                  let cfName = nameRef?.takeRetainedValue() else { continue }

            let name = cfName as String
            if filteredNames.contains(name) || seenNames.contains(name) { continue }
            seenNames.insert(name)

            results.append(AudioDevice(id: deviceID, name: name))
        }

        return results
    }

    static func getAllOutputDeviceNames() -> [String] {
        return getAllOutputDevices().map { $0.name }
    }

    static func setDefaultOutput(name: String) {
        let devices = getAllOutputDevices()
        guard let device = devices.first(where: { $0.name == name }) else { return }

        var deviceID = device.id
        var setAddr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        let result = AudioObjectSetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &setAddr,
            0,
            nil,
            UInt32(MemoryLayout<AudioDeviceID>.size),
            &deviceID
        )

        if result != noErr {
            print("❌ Failed to switch output.")
        }
    }
}
