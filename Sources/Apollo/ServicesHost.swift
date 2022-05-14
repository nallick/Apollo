//
//  ServicesHost.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import Foundation
import Reflection
import UIKit

public struct ServicesHost {

    public let services: [ServiceModule]

    public init() {
        services = Reflection.allClasses.compactMap { Self.instantiateAnyServiceModule(type: $0) }
    }

    public func services<T>(conformingTo type: T.Type) -> [T] {
        services.compactMap { $0 as? T }
    }

    private static func conformingServiceModuleType(_ type: AnyClass) -> ServiceModule.Type? {
        Reflection.class(type, conformsTo: ServiceModule.self) ? (type as? ServiceModule.Type) : nil
    }

    private static func instantiateAnyServiceModule(type: AnyClass) -> ServiceModule? {
        guard let serviceModuleType = conformingServiceModuleType(type) else { return nil }
        return serviceModuleType.init()
    }
}

extension ServicesHost {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        services
            .map { $0.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true }
            .allSatisfy({ $0 })
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        services
            .forEach { $0.applicationWillTerminate?(application) }
    }

    public func sceneWillEnterForeground(_ scene: UIScene) {
        services
            .forEach { $0.sceneWillEnterForeground?(scene) }
    }

    public func sceneDidEnterBackground(_ scene: UIScene) {
        services
            .forEach { $0.sceneDidEnterBackground?(scene) }
    }
}

#endif
