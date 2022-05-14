//
//  ServiceCoreDataContext.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

#if !os(macOS)

import CoreData
import Foundation

public struct ServiceCoreDataContext<Service: ServiceModule> {
    public let persistentContainer: NSPersistentContainer
    public let managedObjectContext: NSManagedObjectContext

    public init(bundle: Bundle = Bundle.main, containerName: String = Service.name, modelName: String? = nil, persistentContainer: NSPersistentContainer? = nil) {
        self.persistentContainer = persistentContainer ?? PersistentContainer(bundle: bundle, containerName: containerName, modelName: modelName ?? containerName)
        self.managedObjectContext = self.persistentContainer.viewContext
    }

    public func loadPersistentStores(completion: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        persistentContainer.loadPersistentStores(completionHandler: completion)
    }

    public func saveDatabaseContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}

extension ServiceCoreDataContext {

    public class PersistentContainer: NSPersistentContainer {

        public convenience init(bundle: Bundle, containerName: String, modelName: String) {
            guard let modelURL = bundle.url(forResource: modelName, withExtension: "momd"),
                  let model = NSManagedObjectModel(contentsOf: modelURL) else {
                self.init(name: containerName)
                return
            }

            self.init(name: containerName, managedObjectModel: model)
        }

        public override class func defaultDirectoryURL() -> URL {
            let applicationSupportDirectory = try? Service.applicationSupportDirectory()
            return applicationSupportDirectory ?? super.defaultDirectoryURL()
        }
    }
}

#endif
