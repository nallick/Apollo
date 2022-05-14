//
//  ApolloSceneDelegateTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import BaseSwiftMocks
import XCTest

final class ApolloSceneDelegateTests: XCTestCase {

    func testSceneWillEnterForegroundIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let sceneDelegate = ApolloSceneDelegate(servicesHostProvider: { servicesHost })
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.sceneWillEnterForegroundCount, 0)

        sceneDelegate.sceneWillEnterForeground(NSObject.new(UIScene.self)!)

        XCTAssertEqual(mockService?.sceneWillEnterForegroundCount, 1)
    }

    func testSceneDidEnterBackgroundIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let sceneDelegate = ApolloSceneDelegate(servicesHostProvider: { servicesHost })
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.sceneWillEnterForegroundCount, 0)

        sceneDelegate.sceneDidEnterBackground(NSObject.new(UIScene.self)!)

        XCTAssertEqual(mockService?.sceneDidEnterBackgroundCount, 1)
    }
}
