//
//  ServicesHostTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import XCTest

final class ServicesHostTests: XCTestCase {

    func testAllServicesAreInstantiated() {
        let servicesHost = ServicesHost()

        XCTAssertGreaterThanOrEqual(servicesHost.services.count, 2)
        XCTAssertTrue(servicesHost.services.contains { ObjectIdentifier(type(of: $0)) == ObjectIdentifier(ServiceModuleTests.MockServiceModule.self) })
        XCTAssertTrue(servicesHost.services.contains { ObjectIdentifier(type(of: $0)) == ObjectIdentifier(ServiceModuleTests.EmptyServiceModule.self) })
    }

    func testCanGetServicesConformingToType() {
        let servicesHost = ServicesHost()

        let emptyProtocolServices = servicesHost.services(conformingTo: EmptyProtocol.self)
        XCTAssertEqual(emptyProtocolServices.count, 1)
        XCTAssertTrue(emptyProtocolServices.contains { ObjectIdentifier(type(of: $0)) == ObjectIdentifier(ServiceModuleTests.MockServiceModule.self) })

        let unusedProtocolServices = servicesHost.services(conformingTo: UnusedProtocol.self)
        XCTAssertEqual(unusedProtocolServices.count, 0)

        let emptyServiceServices = servicesHost.services(conformingTo: ServiceModuleTests.EmptyServiceModule.self)
        XCTAssertEqual(emptyServiceServices.count, 1)
        XCTAssertTrue(emptyServiceServices.contains { ObjectIdentifier(type(of: $0)) == ObjectIdentifier(ServiceModuleTests.EmptyServiceModule.self) })
    }

    func testApplicationDidFinishLaunchingIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.applicationDidFinishLaunchingCount, 0)

        let returnedValue1 = servicesHost.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        mockService?.applicationDidFinishLaunchingReturnValue = true
        let returnedValue2 = servicesHost.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

        XCTAssertFalse(returnedValue1)
        XCTAssertTrue(returnedValue2)
        XCTAssertEqual(mockService?.applicationDidFinishLaunchingCount, 2)
    }

    func testApplicationWillTerminateIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.applicationWillTerminateCount, 0)

        servicesHost.applicationWillTerminate(UIApplication.shared)

        XCTAssertEqual(mockService?.applicationWillTerminateCount, 1)
    }

    func testSceneWillEnterForegroundIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.sceneWillEnterForegroundCount, 0)

        servicesHost.sceneWillEnterForeground(NSObject.new(UIScene.self)!)

        XCTAssertEqual(mockService?.sceneWillEnterForegroundCount, 1)
    }

    func testSceneDidEnterBackgroundIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.sceneWillEnterForegroundCount, 0)

        servicesHost.sceneDidEnterBackground(NSObject.new(UIScene.self)!)

        XCTAssertEqual(mockService?.sceneDidEnterBackgroundCount, 1)
    }
}
