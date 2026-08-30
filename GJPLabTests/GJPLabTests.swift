//
//  GJPLabTests.swift
//  GJPLabTests
//
//  Created by Gan Jianping on 16/8/26.
//

import Testing
@testable import GJPLab

struct GJPLabTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Swift Testing Documentation
        // https://developer.apple.com/documentation/testing
    }

    @MainActor @Test func blocksOnlyWhenEnabledAndACallIsActive() {
        let controller = BlockAppDuringCallsController(storefrontCountryCode: "SGP")
        controller.isEnabled = true
        #expect(!controller.isBlocking)

        controller.toggleTestCall()
        #expect(controller.isBlocking)

        controller.isEnabled = false
        #expect(!controller.isBlocking)
        controller.isEnabled = true
    }

    @MainActor @Test func ChinaStorefrontDoesNotEnableCallMonitoring() {
        let controller = BlockAppDuringCallsController(storefrontCountryCode: "CHN")
        #expect(controller.availability == .unavailableInChina)
        #expect(!controller.isBlocking)
    }

}
