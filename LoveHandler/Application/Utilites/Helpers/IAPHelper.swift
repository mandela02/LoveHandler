//
//  IAPHelper.swift
//  LoveHandler
//
//  Created by TriBQ on 27/11/2021.
//

import StoreKit
import Combine

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool,
                                                     _ products: [SKProduct]?) -> Void

struct IAPData {
    static let productId = "com.qtcorp.LoveHandler.ads.removal"
}

class IAPHelper: NSObject {
    
    static let shared: IAPHelper = IAPHelper()
    
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    private let productIdentifiers: Set<ProductIdentifier>
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    var productRemoveAds: SKProduct?
    private var isRestorePurchase = false
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func configure() {
        if !Settings.isPremium.value {
            SKPaymentQueue.default().add(self)
            requestProducts()
        }
    }
    
    private override init() {
        productIdentifiers = [IAPData.productId]
        super.init()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    
    func requestAdsProductInfo() -> Future<SKProduct, Never> {
        return Future { promise  in
            self.requestProducts { success, resproducts in
                if success,
                   let products = resproducts,
                   let product = products.first(where: { $0.productIdentifier == IAPData.productId }) {
                    promise(.success(product))
                }
            }
        }
    }
    
    func requestProducts(completionHandler: ProductsRequestCompletionHandler? = nil) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    func buyProduct(_ product: SKProduct) {
        print("buying...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func restorePurchases() {
        print("restore...")
        isRestorePurchase = true
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        print("Loaded list of products...")
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
        
        guard products.count != 0 else { return }
        for product in products where product.productIdentifier == IAPData.productId {
            productRemoveAds = product
            break
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
        isRestorePurchase = false
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        deliverPurchaseNotificationFor(completed: false)
    }
        
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(completed: true)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(completed: true)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription ?? "error transaction")")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        deliverPurchaseNotificationFor(completed: false)
    }
    
    private func deliverPurchaseNotificationFor(completed: Bool) {
        Settings.isPremium.value = completed
        sendNotification(completed: completed)
    }
    
    private func sendNotification(completed: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: completed)
    }
}
