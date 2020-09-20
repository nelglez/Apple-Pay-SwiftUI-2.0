//
//  ApplePayManager.swift
//  Apple Pay
//
//  Created by Nelson Gonzalez on 9/20/20.
//

import Foundation
import PassKit

final class ApplePayManager: NSObject {
    // MARK: - PROPERTIES - Can pass here all the values you need for payment. Amount, address, label, etc
    var countryCode: String
    var currencyCode: String
    let shippingMethod = PKShippingMethod()
    var itemCost: Int
    var shippingCost: Int
    
    private lazy var billingContact: PKContact = {
        let contact: PKContact = PKContact()
        var namecomponents = PersonNameComponents()
        namecomponents.familyName = "Nelson"
        contact.emailAddress = "basma_diaz@yahoo.com"
        contact.name = namecomponents
        contact.phoneNumber = CNPhoneNumber(stringValue: "7863184449")
        let postalAdress: CNMutablePostalAddress = CNMutablePostalAddress()
        postalAdress.postalCode = ""
        postalAdress.city = ""
        postalAdress.country = ""
        postalAdress.state = ""
        postalAdress.street = ""
        postalAdress.subAdministrativeArea = ""
        postalAdress.subLocality = ""
        
        contact.postalAddress = postalAdress
        
        return contact
    }()
    
    func makeContact() -> PKContact {
            let contact = PKContact()

            contact.emailAddress = "nelglezfl@gmail.com"
            contact.phoneNumber = CNPhoneNumber(stringValue: "7863184449")

            var name = PersonNameComponents()
            name.givenName = "Nelson"
            contact.name = name

            let address = CNMutablePostalAddress()
            address.street = "12 Samoset Rd, Rockland ME, 04841"
            contact.postalAddress = address

            return contact
        }
    
    private lazy var paymentRequest: PKPaymentRequest = {
        let request: PKPaymentRequest = PKPaymentRequest()
        let merchandId = ""; #error("Add your own merchant id here")
        //label here can be passed in as a variable like we do itemCost and shippingCost.
        let item = PKPaymentSummaryItem(label: "Piano", amount: NSDecimalNumber(integerLiteral: itemCost))
        let shippingMethod = PKShippingMethod(label: "Plane", amount: NSDecimalNumber(integerLiteral: shippingCost))
        let summary = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(integerLiteral: itemCost + shippingCost))
        
        shippingMethod.identifier = "ios App Shipping"
        request.merchantIdentifier = merchandId
        request.billingContact = billingContact
        request.countryCode = countryCode //"IN", "US"
        request.currencyCode = currencyCode //"INR", "USD"
        request.merchantCapabilities = .capability3DS//PKMerchantCapability([.capability3DS, .capabilityCredit, .capabilityDebit, .capabilityEMV])
       // request.merchantIdentifier = "ios App Transaction"
        request.paymentSummaryItems = [item, shippingMethod, summary]
        request.requiredBillingContactFields = [.emailAddress, .name, .phoneNumber, .postalAddress]
        request.requiredShippingContactFields = [.emailAddress, .name, .phoneNumber, .postalAddress]
        request.shippingContact = makeContact()
        request.shippingMethods = [shippingMethod]
        request.shippingType = .shipping
        request.supportedCountries = ["US"]
        request.supportedNetworks = [.maestro, .masterCard, .quicPay, .visa, .vPay]

        return request
    }()
    
    var btnApplePay: PKPaymentButton = {
        let btn: PKPaymentButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        btn.cornerRadius = 10
        //btn.addTarget(self, action: #selector(buyBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    func buyBtnTapped() {
        guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest),
           // let window = SwiftHelper.getSceneDelegate()?.window
              let window = UIApplication.shared.connectedScenes
                                      .filter({$0.activationState == .foregroundActive})
                                      .map({$0 as? UIWindowScene})
                                      .compactMap({$0})
                                      .first?.windows
                          .filter({$0.isKeyWindow}).first
        else {
            return
            
        }
        paymentVC.delegate = self
        window.rootViewController?.present(paymentVC, animated: true, completion: nil)
        
    }
    // MARK: - LIFE CYCLE METHODS
    init(countryCode: String, currencyCode: String, itemCost: Int, shippingCost: Int) {
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.itemCost = itemCost
        self.shippingCost = shippingCost
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate
extension ApplePayManager: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        completion(.init(status: .success, errors: nil))
    }
    //
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {

        completion(.init(paymentSummaryItems: [PKPaymentSummaryItem(label: "ios", amount: 1200)]))
    }
    
}
