class Services {
    private var services: [String: Any] = [:]

    @discardableResult
    public func add<T>(_ service: T) -> Services {
        let name = String(describing: T.self)
        services[name] = service

        return self
    }

    @discardableResult
    public func add<each D, T>(_ serviceBuilder: (repeat each D) -> T) throws -> Services {
        let name = String(describing: T.self)
        services[name] = try call(callback: serviceBuilder)

        return self
    }

    public func get<T>(_ service: T.Type) -> T? {
        let name = String(describing: service)

        let mapped = services[name].flatMap { $0 as? T }

        return mapped
    }

    public func throwingGet<T>(_ service: T.Type) throws(ServiceError) -> T {
        guard let mapped = get(service) else {
            let name = String(describing: service)
            throw ServiceError.noSuchService(name: name)
        }

        return mapped
    }

    public func call<each T, G>(callback: (repeat each T) -> G) throws(ServiceError) -> G {
        callback(repeat (try throwingGet((each T).self)))
    }
}

enum ServiceError: Error {
    case noSuchService(name: String)
}
