import Foundation

/// Samples for the Memory management topic. The classes log from `deinit`, which shows when ARC frees them.
/// They are `nonisolated` because `deinit` does not run on the main actor; each one keeps the `SampleLog`
/// of the run that created it.
enum MemorySamples {
    static let all: [CodeSample] = [
        CodeSample(
            "Object lifetime",
            explanation: "ARC counts strong references. When the last one goes away, the object is freed and deinit runs.",
            code: #"""
            final class Person {
                let name: String
                let log: SampleLog
                init(name: String, log: SampleLog) { self.name = name; self.log = log }
                deinit { log("deinit \(name)") }
            }

            do {
                let ada = Person(name: "Ada", log: log)
                log("\(ada.name) is in scope")
            }
            log("scope ended")

            var first: Person? = Person(name: "Grace", log: log)
            var second = first
            first = nil
            log("first = nil, second still holds \(second?.name ?? "nobody")")
            second = nil
            log("second = nil")
            """#,
            run: { objectLifetime($0) }
        ),
        CodeSample(
            "Retain cycles and weak",
            explanation: "Two objects that hold each other strongly are never freed. A weak back-reference breaks the cycle.",
            code: #"""
            final class Owner {
                let name: String
                let log: SampleLog
                var pet: AnyObject?
                init(name: String, log: SampleLog) { self.name = name; self.log = log }
                deinit { log("deinit owner \(name)") }
            }
            final class Pet {
                let name: String
                let log: SampleLog
                var owner: Owner?  // strong
                init(name: String, log: SampleLog) { self.name = name; self.log = log }
                deinit { log("deinit pet \(name)") }
            }
            final class WeakPet {
                let name: String
                let log: SampleLog
                weak var owner: Owner?  // weak: does not keep the owner alive
                init(name: String, log: SampleLog) { self.name = name; self.log = log }
                deinit { log("deinit pet \(name)") }
            }

            do {
                let owner = Owner(name: "Sam", log: log)
                let pet = Pet(name: "Rex", log: log)
                owner.pet = pet
                pet.owner = owner
            }
            log("strong cycle: scope ended, nothing was freed")
            do {
                let owner = Owner(name: "Kim", log: log)
                let pet = WeakPet(name: "Tom", log: log)
                owner.pet = pet
                pet.owner = owner
            }
            log("weak reference: both were freed")
            """#,
            run: { retainCycles($0) }
        ),
        CodeSample(
            "Capturing self in closures",
            explanation: "A stored closure that uses self keeps self alive. [weak self] avoids the cycle.",
            code: #"""
            final class Downloader {
                let name: String
                let log: SampleLog
                var onFinish: (() -> Void)?
                init(name: String, log: SampleLog) { self.name = name; self.log = log }
                func prepareStrong() { onFinish = { self.report() } }
                func prepareWeak() { onFinish = { [weak self] in self?.report() } }
                func report() { log("\(name) finished") }
                deinit { log("deinit \(name)") }
            }

            do {
                let downloader = Downloader(name: "strong capture", log: log)
                downloader.prepareStrong()
                downloader.onFinish?()
            }
            do {
                let downloader = Downloader(name: "weak capture", log: log)
                downloader.prepareWeak()
                downloader.onFinish?()
            }
            log("only the [weak self] downloader was freed")
            """#,
            run: { capturingSelf($0) }
        ),
        CodeSample(
            "unowned",
            explanation: "unowned, like weak, does not keep an object alive, but it is not optional. Use it only when the other object always lives longer.",
            code: #"""
            final class Customer {
                let name: String
                let log: SampleLog
                var card: CreditCard?
                init(name: String, log: SampleLog) { self.name = name; self.log = log }
                deinit { log("deinit customer \(name)") }
            }
            final class CreditCard {
                let number: String
                let log: SampleLog
                unowned let customer: Customer  // a card never outlives its customer
                init(number: String, customer: Customer, log: SampleLog) {
                    self.number = number; self.customer = customer; self.log = log
                }
                deinit { log("deinit card \(number)") }
            }

            do {
                let customer = Customer(name: "Lee", log: log)
                customer.card = CreditCard(number: "1234", customer: customer, log: log)
                log("card 1234 belongs to \(customer.card?.customer.name ?? "nobody")")
            }
            log("both were freed: unowned did not keep the customer alive")
            // Reading card.customer after the customer is freed stops the app.
            """#,
            run: { unownedReferences($0) }
        ),
    ]

    static func objectLifetime(_ log: SampleLog) {
        do {
            let ada = Person(name: "Ada", log: log)
            log("\(ada.name) is in scope")
        }
        log("scope ended")

        var first: Person? = Person(name: "Grace", log: log)
        var second = first
        first = nil
        log("first = nil, second still holds \(second?.name ?? "nobody")")
        second = nil
        log("second = nil")
    }

    static func retainCycles(_ log: SampleLog) {
        do {
            let owner = Owner(name: "Sam", log: log)
            let pet = Pet(name: "Rex", log: log)
            owner.pet = pet
            pet.owner = owner
        }
        log("strong cycle: scope ended, nothing was freed")
        do {
            let owner = Owner(name: "Kim", log: log)
            let pet = WeakPet(name: "Tom", log: log)
            owner.pet = pet
            pet.owner = owner
        }
        log("weak reference: both were freed")
    }

    static func capturingSelf(_ log: SampleLog) {
        do {
            let downloader = Downloader(name: "strong capture", log: log)
            downloader.prepareStrong()
            downloader.onFinish?()
        }
        do {
            let downloader = Downloader(name: "weak capture", log: log)
            downloader.prepareWeak()
            downloader.onFinish?()
        }
        log("only the [weak self] downloader was freed")
    }

    static func unownedReferences(_ log: SampleLog) {
        do {
            let customer = Customer(name: "Lee", log: log)
            customer.card = CreditCard(number: "1234", customer: customer, log: log)
            log("card 1234 belongs to \(customer.card?.customer.name ?? "nobody")")
        }
        log("both were freed: unowned did not keep the customer alive")
        // Reading card.customer after the customer is freed stops the app.
    }
}

// MARK: - Classes used by the samples

nonisolated fileprivate final class Person {
    let name: String
    let log: SampleLog
    init(name: String, log: SampleLog) { self.name = name; self.log = log }
    deinit { log("deinit \(name)") }
}

nonisolated fileprivate final class Owner {
    let name: String
    let log: SampleLog
    var pet: AnyObject?
    init(name: String, log: SampleLog) { self.name = name; self.log = log }
    deinit { log("deinit owner \(name)") }
}

nonisolated fileprivate final class Pet {
    let name: String
    let log: SampleLog
    var owner: Owner?  // strong
    init(name: String, log: SampleLog) { self.name = name; self.log = log }
    deinit { log("deinit pet \(name)") }
}

nonisolated fileprivate final class WeakPet {
    let name: String
    let log: SampleLog
    weak var owner: Owner?  // weak: does not keep the owner alive
    init(name: String, log: SampleLog) { self.name = name; self.log = log }
    deinit { log("deinit pet \(name)") }
}

nonisolated fileprivate final class Downloader {
    let name: String
    let log: SampleLog
    var onFinish: (() -> Void)?
    init(name: String, log: SampleLog) { self.name = name; self.log = log }
    func prepareStrong() { onFinish = { self.report() } }
    func prepareWeak() { onFinish = { [weak self] in self?.report() } }
    func report() { log("\(name) finished") }
    deinit { log("deinit \(name)") }
}

nonisolated fileprivate final class Customer {
    let name: String
    let log: SampleLog
    var card: CreditCard?
    init(name: String, log: SampleLog) { self.name = name; self.log = log }
    deinit { log("deinit customer \(name)") }
}

nonisolated fileprivate final class CreditCard {
    let number: String
    let log: SampleLog
    unowned let customer: Customer  // a card never outlives its customer
    init(number: String, customer: Customer, log: SampleLog) {
        self.number = number; self.customer = customer; self.log = log
    }
    deinit { log("deinit card \(number)") }
}
