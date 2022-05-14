//
//  ApolloApplicationDelegate.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import UIKit

open class ApolloApplicationDelegate: UIResponder, UIApplicationDelegate {
    public let servicesHost: ServicesHost

    open class var sharedServicesHost: ServicesHost? { (UIApplication.shared.delegate as? ApolloApplicationDelegate)?.servicesHost
    }

    public override convenience init() {
        self.init(servicesHost: ServicesHost())
    }

    public init(servicesHost: ServicesHost) {
        self.servicesHost = servicesHost
        super.init()
    }

    @objc open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        servicesHost.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @objc open func applicationWillTerminate(_ application: UIApplication) {
        servicesHost.applicationWillTerminate(application)
    }
}

#endif
