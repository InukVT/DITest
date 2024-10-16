class Services {
    private var services: [ObjectIdentifier: Any] = [:]

    @discardableResult
    public func add<Service>(_ service: Service) -> Services {
        let identifier = ObjectIdentifier(Service.self)
        services[identifier] = service

        return self
    }

    @discardableResult
    public func add<each Dependency, Service>(_ serviceBuilder: (repeat each Dependency) -> Service)
        throws -> Services
    {
        let identifier = ObjectIdentifier(Service.self)
        services[identifier] = try call(callback: serviceBuilder)

        return self
    }

    public func get<Service>(_ service: Service.Type) -> Service? {
        let identifier = ObjectIdentifier(Service.self)
        let mapped = services[identifier].flatMap { $0 as? Service }

        return mapped
    }

    public func throwingGet<Service>(_ service: Service.Type) throws(ServiceError) -> Service {
        guard let mapped = get(service) else {
            let name = String(describing: service)
            throw ServiceError.noSuchService(name: name)
        }

        return mapped
    }

    public func call<each Dependency, ReturnValue>(
        callback: (repeat each Dependency) -> ReturnValue
    ) throws(ServiceError) -> ReturnValue {
        callback(repeat (try throwingGet((each Dependency).self)))
    }
}

enum ServiceError: Error {
    case noSuchService(name: String)
}
