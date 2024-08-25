import Testing
import XCTest

@testable import DITest

@Test("Check to see if dependencies can be added and read")
func canAddDependency() async throws {
    let services = Services()

    services.add(services)
    #expect(services.get(Services.self) != nil)
    #expect(services.get(String.self) == nil)
}

@Test("Check to see if dependencies can called")
func canDoParameterpacks() async throws {
    let services = Services()

    services.add("Hello world")

    let result = try services.call { (hello: String) in
        #expect(hello == "Hello world")

        return 5
    }

    #expect(result == 5)

    services.add(5)

    let otherResult = try services.call { (hello: String, num: Int) in
        return "\(hello) \(num)"
    }

    #expect(otherResult == "Hello world 5")

    let thirdResult = try services.call { (num: Int) in
        return num
    }
    #expect(thirdResult == 5)
}
