//
//  GRGetUserContacts.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 20/03/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import Contacts
import SwiftLoader

var allContacts: [String]?
let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]

var contactStore = CNContactStore()

func getUserContacts() -> [String] {
    allContacts = []
        
    let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
    request.unifyResults = true
    
    try! contactStore.enumerateContacts(with: request) { contact, stop  in
        if contact.emailAddresses.count > 0 {
            allContacts?.append(contact.emailAddresses[0].value as String)
        }
    }
    
    return allContacts!
    
}
