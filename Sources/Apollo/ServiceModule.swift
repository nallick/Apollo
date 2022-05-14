//
//  ServiceModule.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import Foundation
import UIKit

@objc public protocol ServiceModule {

    init()

    @objc optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    @objc optional func applicationWillTerminate(_ application: UIApplication)

    @objc optional func sceneWillEnterForeground(_ scene: UIScene)
    @objc optional func sceneDidEnterBackground(_ scene: UIScene)
}

extension ServiceModule {

    public static var name: String { String(describing: self) }

    public static var userDefaults: UserDefaults? { UserDefaults(suiteName: userDefaultsSuiteName) }
    public static var userDefaultsSuiteName: String { "__Service_" + name + "__" }

    public static func applicationSupportDirectory(for serviceName: String = name, create: Bool = true, attributes: [FileAttributeKey: Any]? = nil, fileManager: FileManager = FileManager.default) throws -> URL {
        guard let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            else { throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError) }
        let servicesDirectory = applicationSupportDirectory.appendingPathComponent("Services", isDirectory: true)
        let resultDirectory = servicesDirectory.appendingPathComponent(serviceName, isDirectory: true)
        if create { try fileManager.createDirectory(at: resultDirectory, withIntermediateDirectories: true, attributes: attributes) }

        return resultDirectory
    }
}

#endif
