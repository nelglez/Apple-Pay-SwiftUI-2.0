//
//  ContentView.swift
//  Apple Pay
//
//  Created by Nelson Gonzalez on 9/20/20.
//https://medium.com/appcoda-tutorials/integrating-basic-apple-pay-into-your-ios-app-71f17d48fc9b

import SwiftUI

struct ContentView: View {
    var itemCost = 10_000
    let shippingCost = 1_500
    var body: some View {
        let applePay = ApplePayManager(countryCode: "US", currencyCode: "USD", itemCost: itemCost, shippingCost: shippingCost)
        VStack {
            
            Image("applepay")
                            .onTapGesture {
                                applePay.buyBtnTapped()
                        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
