//
//  GJPLabTests.swift
//  GJPLabTests
//
//  Created by Gan Jianping on 16/8/26.
//

import Foundation
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

    @MainActor @Test func bundledNavigationMenuDecodes() throws {
        let menu = try NavigationMenu.load(from: .main)
        #expect(!menu.categories.isEmpty)
        #expect(Set(menu.categories.map(\.id)).count == menu.categories.count)
    }

    @MainActor @Test func everyFeatureRouteAppearsExactlyOnceInTheMenu() throws {
        let routes = try NavigationMenu.load(from: .main).categories.flatMap(\.topics).compactMap(\.route)
        #expect(routes.count == FeatureRoute.allCases.count)
        #expect(Set(routes) == Set(FeatureRoute.allCases))
    }

    @MainActor @Test func unknownRouteInNavigationJSONFailsToDecode() {
        let json = Data(#"{"categories":[{"id":"x","title":"X","summary":"","description":"","systemImage":"star","topics":[{"title":"T","description":"","route":"missing"}]}]}"#.utf8)
        #expect(throws: DecodingError.self) { try NavigationMenu.decode(json) }
    }

    @MainActor @Test func ChinaStorefrontDoesNotEnableCallMonitoring() {
        let controller = BlockAppDuringCallsController(storefrontCountryCode: "CHN")
        #expect(controller.availability == .unavailableInChina)
        #expect(!controller.isBlocking)
    }

}
