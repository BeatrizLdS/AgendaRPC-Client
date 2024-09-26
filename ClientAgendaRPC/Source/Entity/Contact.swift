//
//  Contact.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import Foundation

struct Contact: Hashable, Codable, Equatable {
    var name: String
    var phone: String
    
    init(name: String, phone: String) {
        self.name = name
        self.phone = phone
    }
    
    static func decodeFromJaon(data: Data) throws -> Contact {
        let decoder = JSONDecoder()
        return try decoder.decode(Contact.self, from: data)
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
