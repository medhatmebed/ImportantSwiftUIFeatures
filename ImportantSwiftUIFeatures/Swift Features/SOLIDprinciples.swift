//
//  SOLIDprinciples.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/30/24.
//

import Foundation

// MARK: - Single Responsibility Principle (SRP)

/*
 A class should only be responsible for one thing
 */


struct Product {
    let price: Double
}
/// here in the Invoice we make it only responsible for the Invoice type and for the printing functionality and saving to the database we created two different classes
struct Invoice {
    var products: [Product]
    let id = UUID().uuidString
    var discountPercentage: Double = 0
    
    var total: Double {
        let total = products.map({ $0.price}).reduce(0, { $0 + $1 })
        let discountAmount = total * (discountPercentage / 100)
        return total - discountAmount
    }
    /// this will fix creating InvoicePrinter instance for each Invoice so we can add the printInvoice but not the implementation
    func printInvoice() {
        let printer = InvoicePrinter(invoice: self)
        printer.printInvoice()
    }
    
    func saveInvoice() {
        // save invoice data locally or to database
        let persistence = InvoicePersistence(invoice: self)
        persistence.saveInvoice()
    }
}

struct InvoicePrinter {
    let invoice: Invoice
    
    func printInvoice() {
        print("___________________")
        print("Invoice id: \(invoice.id)")
        print("Total cost $\(invoice.total)")
        print("Discounts: \(invoice.discountPercentage)")
        print("___________________")
    }
}

struct InvoicePersistence {
    let invoice: Invoice
    
    func saveInvoice() {
        // save invoice data locally or to database
    }
}

let products: [Product] = [
    .init(price: 99.99),
    .init(price: 91.99),
    .init(price: 45.99),
    .init(price: 53.99)
]

let invoice = Invoice(products: products, discountPercentage: 20)
let printer = InvoicePrinter(invoice: invoice)
let persistence = InvoicePersistence(invoice: invoice)
//printer.printInvoice()

let invoice2 = Invoice(products: products)
/// because we added the printInvoice now we can use it instead of creating InvoicePrinter instance for each Invoice
//invoice2.printInvoice()

// MARK: - Open/Closed Principle

/*
 Notes:
    Software entities (classes, modules, functions, etc.) should be open for extensions but closed for modifications
    in other words, we can add additional functionality (extension) without touching the existing code (modification) of an object
 */

/// for example we can extend Int and add squared function. we can see that we added a new function but we couldn't touch the existing code of the type Int

extension Int {
    func squared() -> Int {
        return self * self
    }
}
//var num = 2
//num.squared()
/// we could achieve OCP by just creating extension to InvoicePersistenceOCP and add the new functions but this is not the best war
/// we created a protocol InvoicePersistable and two separate type of persistables CoreDataPersistence and DatabasePersistence
/// and in the implementation we can inject the persistable service we need ( i.e coredata or database )
struct InvoicePersistenceOCP {
    let persistence: InvoicePersistable
    
    func save(invoice: Invoice) {
        persistence.save(invoice: invoice)
    }
}

protocol InvoicePersistable {
    func save(invoice: Invoice)
}

struct CoreDataPersistence: InvoicePersistable {
    func save(invoice: Invoice) {
        print("save invoice to Core Data \(invoice.id)")
    }
}

struct DatabasePersistence: InvoicePersistable {
    func save(invoice: Invoice) {
        print("save invoice to Database \(invoice.id)")
    }
}

let coreDataPersistence = CoreDataPersistence()
let persistenceOCP = InvoicePersistenceOCP(persistence: coreDataPersistence)


// MARK: - Liskov Substitution Principle (LSP) "is A principle"
/*
 Notes:
     Derived or child classes/structures must be substitutable for their base of parent classes
 */
/// in this example we can see that APIError is A Error so that in the function fetchUser we can throw APIError because it's substitutable  with the type Error
enum APIError: Error {
    case invalidUrl, invalidResponse, invalidStatusCode
}

struct MockUserServiceLSP {
    func fetchUser() async throws {
        do {
            throw APIError.invalidUrl
        } catch {
            print("error is \(error)")
        }
    }
}

let mockUserServiceLSP = MockUserServiceLSP()
//Task { try await mockUserServiceLSP.fetchUser() }


// MARK: - Interface Segregation Principle (ISP)

/*
 Notes:
     Do not force any client to implement an interface which is irrelevant to them
 */
/// in this example we can achieve the interface segregation by marking its functions as optional but the caveat is @objc protocols can only be used by classes not structs so if we have structs should split the giant protocol into smaller ones
@objc protocol GestureProtocol {
    func didTap()
    @objc optional func didDoubleTap()
    @objc optional  func didLongPress()
}

class SuperButton: GestureProtocol {
    func didTap() {
        
    }
    
    func didDoubleTap() {
        
    }
    
    func didLongPress() {
        
    }
}

class DoubleTapButton: GestureProtocol {
    func didTap() {

    }
    
}


// MARK: - Dependency Inversion Principle (DIP)

/*
 Notes:
    - High-level modules should not depend on low-level modules, but should depend on abstraction
    - If a high-level module imports any low-level module then the code becomes tightly coupled
    - Change in one class could break another class
 */

protocol PaymentMethod {
    func execute(amount: Double)
}

struct DebitCardPayment: PaymentMethod {
    func execute(amount: Double) {
        print("Debit card payment success for \(amount)")
    }
}
struct StripePayment: PaymentMethod {
    func execute(amount: Double) {
        print("Stripe payment success for \(amount)")
    }
}
struct ApplePayPayment: PaymentMethod {
    func execute(amount: Double) {
        print("ApplePay payment success for \(amount)")
    }
}
/// now Payment as a high-level module is depending on payment method which is low-level module
struct Payment {
    var debitCardPayment: DebitCardPayment?
    var stripePayment: StripePayment?
    var applePayment: ApplePayPayment?
}
/// we can see here in the implementation we initialized the payment with DebitCardPayment
let paymentMethod = DebitCardPayment()
let payment = Payment(debitCardPayment: paymentMethod)

/// but the problem here is when we use payment we don't know which payment method is in
//payment.debitCardPayment?.execute(amount: 100)

/// so the solution is to create an abstraction level "PaymentMethod" 
struct PaymentDIP {
    let payment: PaymentMethod
    
    func makePayment(amount: Double) {
        payment.execute(amount: amount)
    }
}

let stripe = StripePayment()
let paymentDIP = PaymentDIP(payment: stripe)

///paymentDIP.makePayment(amount: 200)
