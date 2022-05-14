//
//  ApolloSceneDelegate.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import UIKit

open class ApolloSceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let servicesHostProvider: (() -> ServicesHost?)

    public init(servicesHostProvider: (() -> ServicesHost?)? = nil) {
        self.servicesHostProvider = servicesHostProvider ?? { ApolloApplicationDelegate.sharedServicesHost }
    }

    open func sceneWillEnterForeground(_ scene: UIScene) {
        servicesHostProvider()?.sceneWillEnterForeground(scene)
    }

    open func sceneDidEnterBackground(_ scene: UIScene) {
        servicesHostProvider()?.sceneDidEnterBackground(scene)
    }
}

#endif
