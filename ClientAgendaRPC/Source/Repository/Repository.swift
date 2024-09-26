//
//  Repository.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import Combine

protocol NetworkRepositoryProtocol {
    var connectionPublisher: PassthroughSubject<Agenda?, Never> { get set }
    var responsePublisher: PassthroughSubject<Bool, Never> { get set }
    var contactsPublisher: PassthroughSubject<[Contact], Never> { get set }
    
    func startConnection() async
    func getContactsList() async
    func addContact(contact: Contact) async
    func removeContact(contact: Contact) async
    func updateContact(contact: Contact) async
}

class NetworkRepository: NetworkRepositoryProtocol {
    private var agendaClient: any AgendaClientRPCProtocol
    
    private var responseMapper: any ResponseMapperProtocol
    private var contactsMapper: any ContactMapperProtocol
    
    var responsePublisher = PassthroughSubject<Bool, Never>()
    var connectionPublisher = PassthroughSubject<Agenda?, Never>()
    var contactsPublisher = PassthroughSubject<[Contact], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    required init (
        clientService: any AgendaClientRPCProtocol,
        responseMapper: any ResponseMapperProtocol
    ) {
        self.agendaClient = clientService
        self.responseMapper = responseMapper
        self.contactsMapper = ContactMapper()
        setSubscriptions()
    }
    
    func startConnection() async {
        await agendaClient.connecToAvailableAgenda()
    }
    
    func getContactsList() async {
        await agendaClient.getContactsList()
    }
    
    func updateContact(contact: Contact) async {
        var toUpdateContact = Agenda_Contact()
        toUpdateContact.name = contact.name
        toUpdateContact.phone = contact.phone
        await agendaClient.updateContact(contact: toUpdateContact)
    }
    
    func removeContact(contact: Contact) async {
        var toDeleteContact = Agenda_Contact()
        toDeleteContact.name = contact.name
        toDeleteContact.phone = contact.phone
        await agendaClient.deleteContact(contact: toDeleteContact)
    }
    
    func addContact(contact: Contact) async {
        var newContact = Agenda_Contact()
        newContact.name = contact.name
        newContact.phone = contact.phone
        await agendaClient.addContact(contact: newContact)
    }
    
    private func setSubscriptions() {
        agendaClient.contactsPublisher.sink{[weak self] contactList in
            if let contactList = contactList {
                if let contacts = self?.contactsMapper.mapToDomain(contactList) {
                    self?.contactsPublisher.send(contacts)
                }
            } else {
                self?.connectionPublisher.send(nil)
            }
        }
        .store(in: &cancellables)
        
        agendaClient.connectionPublisher.sink{[weak self] agenda in
            self?.connectionPublisher.send(agenda)
        }
        .store(in: &cancellables)
        
        agendaClient.responsePublisher.sink{ [weak self] response in
            if let response = response {
                if let response = self?.responseMapper.mapToDomain(response) {
                    self?.responsePublisher.send(response)
                }
            } else {
                self?.connectionPublisher.send(nil)
            }
        }
        .store(in: &cancellables)
    }
    
}
