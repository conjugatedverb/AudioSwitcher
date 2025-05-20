// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AudioSwitcher",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "AudioSwitcher", targets: ["AudioSwitcher"])
    ],
    targets: [
        .executableTarget(
            name: "AudioSwitcher",
            dependencies: [],
            path: "Sources/AudioSwitcher",
            linkerSettings: [
                .linkedFramework("CoreAudio"),
                .linkedFramework("AudioToolbox"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("AppKit"),
                .linkedFramework("SwiftUI")
            ]
        )
    ]
)
