//
//  FPSMonitor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 10.12.2024.
//

import Foundation
import Observation
import QuartzCore

@Observable
final class FPSMonitor {
    private(set) var fps = 0

    @ObservationIgnored
    private var displayLink: CADisplayLink?
    @ObservationIgnored
    private var lastTimestamp: TimeInterval = 0
    @ObservationIgnored
    private var frameCount = 0

    init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }
}

private extension FPSMonitor {

    func startMonitoring() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFPS))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stopMonitoring() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc
    func updateFPS(link: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }

        frameCount += 1
        let delta = link.timestamp - lastTimestamp
        if delta >= 1 {
            fps = frameCount
            frameCount = 0
            lastTimestamp = link.timestamp
        }
    }
}
