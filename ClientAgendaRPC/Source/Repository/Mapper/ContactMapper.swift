//
//  ContactMapper.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import Foundation
import GRPC

protocol ContactMapperProtocol: DomainEntityMapperProtocol where DTO == Agenda_ContactsList, DomainEntity == [Contact] {}

class ContactMapper: ContactMapperProtocol {
    func mapToDomain(_ dto: Agenda_ContactsList) -> [Contact] {
        var list: [Contact] = dto.contacts.map { agenda_contact in
            return Contact(name: agenda_contact.name, phone: agenda_contact.phone)
        }
        return list
    }
}
