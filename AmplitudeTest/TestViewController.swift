//
//  TestViewController.swift
//  AmplitudeTest
//
//  Created by Serhii Bykov on 15.05.2021.
//

import AppKit

class TestViewController: NSViewController { }

// MARK: - Lifecycle
extension TestViewController {
    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        setup()
    }
}

// MARK: - Setups
private extension TestViewController {
    func setup() {
        setupAmplitude()
    }

    func setupAmplitude() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }

        if bundleIdentifier.contains("AmplitudeTest1") {
            setupAmplitudeForApp1()
        } else if bundleIdentifier.contains("AmplitudeTest2") {
            setupAmplitudeForApp2()
        }

        sendLaunchEvent()
    }

    func setupAmplitudeForApp1() {
        Amplitude.instance().initializeApiKey("API_KEY_1")
    }

    func setupAmplitudeForApp2() {
        Amplitude.instance().initializeApiKey("API_KEY_2")
    }

    func sendLaunchEvent() {
        Amplitude.instance().logEvent("\(Bundle.main.bundleIdentifier!) - Launch")
    }
}
