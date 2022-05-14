//
//  ApolloApplicationDelegateTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import BaseSwiftMocks
import XCTest

final class ApolloApplicationDelegateTests: XCTestCase {

    func testApplicationDidFinishLaunchingIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let applicationDelegate = ApolloApplicationDelegate(servicesHost: servicesHost)
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.applicationDidFinishLaunchingCount, 0)

        let returnedValue1 = applicationDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        mockService?.applicationDidFinishLaunchingReturnValue = true
        let returnedValue2 = servicesHost.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

        XCTAssertFalse(returnedValue1)
        XCTAssertTrue(returnedValue2)
        XCTAssertEqual(mockService?.applicationDidFinishLaunchingCount, 2)
    }

    func testApplicationWillTerminateIsCalledOnServices() {
        let servicesHost = ServicesHost()
        let applicationDelegate = ApolloApplicationDelegate(servicesHost: servicesHost)
        let mockService = servicesHost.services(conformingTo: ServiceModuleTests.MockServiceModule.self).first
        XCTAssertNotNil(mockService)
        XCTAssertEqual(mockService?.applicationWillTerminateCount, 0)

        applicationDelegate.applicationWillTerminate(UIApplication.shared)

        XCTAssertEqual(mockService?.applicationWillTerminateCount, 1)
    }
}
