//
//  ApolloApplicationDelegate.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import UIKit

open class ApolloApplicationDelegate: UIResponder, UIApplicationDelegate {
    public let servicesHost: ServicesHost

    open class var shared: ApolloApplicationDelegate? { UIApplication.shared.delegate as? ApolloApplicationDelegate }
    open class var sharedServicesHost: ServicesHost? { Self.shared?.servicesHost }

    public init(servicesHost: ServicesHost = ServicesHost()) {
        self.servicesHost = servicesHost
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        servicesHost.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    open func applicationWillTerminate(_ application: UIApplication) {
        servicesHost.applicationWillTerminate(application)
    }
}

#endif
