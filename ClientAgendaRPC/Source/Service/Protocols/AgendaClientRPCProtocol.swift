//
//  AgendaClientRPCProtocol.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import GRPC
import Combine

protocol AgendaClientRPCProtocol: ClientProtocol where Connection == ClientConnection {
    var connectionPublisher: PassthroughSubject<Agenda?, Never> { get set }
    var responsePublisher: PassthroughSubject<Agenda_Response?, Never> { get set }
    var contactsPublisher: PassthroughSubject<Agenda_ContactsList?, Never> { get set }
    
    var client: Agenda_AgendaServiceAsyncClient? { get set }
    func connecToAvailableAgenda() async
    func getContactsList() async
    func addContact(contact: Agenda_Contact) async
    func deleteContact(contact: Agenda_Contact) async
    func updateContact(contact: Agenda_Contact) async
}

