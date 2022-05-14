//
//  ServiceCoreDataTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import BaseSwiftMocks
import CoreData
import XCTest

final class ServiceCoreDataTests: XCTestCase {

    func testServiceBasedCoreDataContext() throws {
        let service = makeCoreDataTestService()

        let testEntity1 = service.fetchTestEntity()
        XCTAssertEqual(testEntity1.value, 0)

        let expectedValue: Int64 = 123
        testEntity1.value = expectedValue
        try service.coreDataContext.saveDatabaseContext()

        let testEntity2 = service.fetchTestEntity()
        XCTAssertEqual(testEntity2.value, expectedValue)
    }
}

extension ServiceCoreDataTests {

    func makeCoreDataTestService() -> CoreDataTestService {
        let result = CoreDataTestService(persistentContainer: Self.memoryResidentPersistentContainer(containerName: "ApolloTestDataModel", bundle: Bundle.module))

        let expectation = expectation(description: "Awaiting CoreData")
        var dataLoaded = false
        result.loadPersistentStores { success in
            dataLoaded = success
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(dataLoaded)

        return result
    }

    final class CoreDataTestService: Apollo.ServiceModule {
        let coreDataContext: ServiceCoreDataContext<CoreDataTestService>
        var coreDataContextLoaded = false

        convenience public init() {
            self.init(persistentContainer: nil)
        }

        public init(persistentContainer: NSPersistentContainer?) {
            coreDataContext = ServiceCoreDataContext(bundle: Bundle.module, persistentContainer: persistentContainer)
        }

        func fetchTestEntity() -> CoreDataTestEntity {
            if !coreDataContextLoaded { XCTFail("CoreData not loaded: \(Self.name)") }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CoreDataTestEntity.self))
            fetchRequest.fetchLimit = 1

            let fetchedTestEntity = try? coreDataContext.managedObjectContext.fetch(fetchRequest) as? [CoreDataTestEntity]
            return fetchedTestEntity?.first ?? CoreDataTestEntity(context: coreDataContext.managedObjectContext)
        }

        func loadPersistentStores(completion: @escaping (Bool) -> Void) {
            if coreDataContextLoaded { completion(true); return }

            coreDataContext.loadPersistentStores { [weak self] _, error in
                let success = error == nil
                self?.coreDataContextLoaded = success
                completion(success)
            }
        }
    }
}
