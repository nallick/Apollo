//
//  ApolloSceneDelegate.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import UIKit

open class ApolloSceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let servicesHostProvider: (() -> ServicesHost?)

    public override convenience init() {
        self.init(servicesHostProvider: nil)
    }

    public init(servicesHostProvider: (() -> ServicesHost?)?) {
        self.servicesHostProvider = servicesHostProvider ?? { ApolloApplicationDelegate.sharedServicesHost }
    }

    @objc open func sceneWillEnterForeground(_ scene: UIScene) {
        servicesHostProvider()?.sceneWillEnterForeground(scene)
    }

    @objc open func sceneDidEnterBackground(_ scene: UIScene) {
        servicesHostProvider()?.sceneDidEnterBackground(scene)
    }
}

#endif
