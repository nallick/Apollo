//
//  ServiceModuleTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import BaseSwiftMocks
import XCTest

protocol EmptyProtocol {}
protocol UnusedProtocol {}

final class ServiceModuleTests: XCTestCase {

    func testServiceName() {
        XCTAssertEqual(MockServiceModule.name, "MockServiceModule")
    }

    func testUserDefaultsSuiteName() {
        XCTAssertEqual(MockServiceModule.userDefaultsSuiteName, "__Service_MockServiceModule__")
    }

    func testUserDefaultsSuite() {
        let serviceUserDefaults: UserDefaults! = MockServiceModule.userDefaults
        let testUserDefaults: UserDefaults! = UserDefaults(suiteName: MockServiceModule.userDefaultsSuiteName)
        XCTAssertNotNil(serviceUserDefaults)
        XCTAssertNotNil(testUserDefaults)
        serviceUserDefaults.removeAllValues()
        testUserDefaults.removeAllValues()

        let expectedValue = 12345
        let testKey = "TestUserDefaultsKey"
        serviceUserDefaults.set(expectedValue, forKey: testKey)
        let actualValue = testUserDefaults.integer(forKey: testKey)
        serviceUserDefaults.removeAllValues()
        testUserDefaults.removeAllValues()

        XCTAssertEqual(expectedValue, actualValue)
    }

    func testApplicationSupportDirectoryReferencesService() throws {
        let applicationSupportURL = try MockServiceModule.applicationSupportDirectory(create: false)
        XCTAssertTrue(applicationSupportURL.path.hasSuffix("/Library/Application Support/Services/MockServiceModule"))
    }
}

extension ServiceModuleTests {

    final class MockServiceModule: ServiceModule, EmptyProtocol {
        var applicationDidFinishLaunchingReturnValue = false
        var applicationDidFinishLaunchingCount = 0
        var applicationWillTerminateCount = 0
        var sceneWillEnterForegroundCount = 0
        var sceneDidEnterBackgroundCount = 0

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            applicationDidFinishLaunchingCount += 1
            return applicationDidFinishLaunchingReturnValue
        }

        func applicationWillTerminate(_ application: UIApplication) {
            applicationWillTerminateCount += 1
        }

        func sceneWillEnterForeground(_ scene: UIScene) {
            sceneWillEnterForegroundCount += 1
        }

        func sceneDidEnterBackground(_ scene: UIScene) {
            sceneDidEnterBackgroundCount += 1
        }
    }

    final class EmptyServiceModule: ServiceModule {}
}
