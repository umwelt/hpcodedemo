//
//  GRFriendsDataProtocol.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 03/01/16.
//  Copyright © 2016 grocerest. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol GRFriendsDataProtocol {
    func addThisFriendsToList(_ friends:[JSON], listName: String)
}
