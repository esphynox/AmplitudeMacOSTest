//
//  TestWindow.swift
//  AmplitudeTest
//
//  Created by Sergey Bykov on 15.05.2021.
//

import AppKit

class TestWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        contentViewController = TestViewController()
    }
}
