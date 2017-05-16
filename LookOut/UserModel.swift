//
//  UserModel.swift
//  LookOut
//
//  Created by Seema Rohilla on 5/14/17.
//  Copyright © 2017 bhakti shah. All rights reserved.
//

import Foundation
class UserModel {
    
    var username: String?
    var email: String?
    var friendlist = [String]()
    var currentLocation = [String: String]()
   
    
    init(username: String?, email: String?, friendlist: [String]? , current: [String:String]?){
        self.username = username
        self.email = email
        self.friendlist = friendlist!
        self.currentLocation = current!
    }
}
