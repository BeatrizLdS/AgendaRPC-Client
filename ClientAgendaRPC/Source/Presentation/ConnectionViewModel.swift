//
//  ConnectionViewModel.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import Foundation
import Combine

class ConnectionViewModel: ObservableObject {
    @Published var isLoadingConnection: Bool = false
    @Published var isAddingNewContact: Bool = false
    @Published var isLoadingContactList: Bool = false
    @Published var connected: Bool = false
    
    @Published var connectedAgenda: Agenda? = nil
    @Published var contactsList: [Contact] = []
    
    @Published var contactToAddName: String = ""
    @Published var contactToAddPhone: String = ""
    @Published var feedBackMessage: String = ""
    
    private var ipAddress: String = "127.0.0.1"
    private var repository: (any NetworkRepositoryProtocol)?
    
    private var cancellables = Set<AnyCancellable>()
    
    func startConnection() async {
        DispatchQueue.main.async{
            self.connected = false
            self.isLoadingConnection = true
        }
        self.repository = await NetworkRepository (
            clientService: AgendaClientRPC(host: ipAddress),
            responseMapper: ResponseMapper()
        )
        setSubscriptions()
        await repository?.startConnection()
    }
    
    func getContactsList() async {
        DispatchQueue.main.async {
            self.isLoadingContactList = true
        }
        await repository?.getContactsList()
    }
    
    func addContact() async {
        if !contactToAddName.isEmpty && !contactToAddPhone.isEmpty {
            let newContact = Contact(
                name: contactToAddName,
                phone: contactToAddPhone
            )
            await repository?.addContact(contact: newContact)
        }
    }
    
    func deleteContact(contact: Contact) async {
        await repository?.removeContact(contact: contact)
    }
    
    func updateContact(contact: Contact) async {
        await repository?.updateContact(contact: contact)
    }
    
    private func setSubscriptions() {
        repository?.responsePublisher.sink {[weak self] hasSuccess in
            self?.updateContactUpdate(hasSuccess: hasSuccess)
        }
        .store(in: &cancellables)
        
        repository?.contactsPublisher.sink { [weak self] contactsList in
            self?.updateContactsList(list: contactsList)
        }
        .store(in: &cancellables)
        
        repository?.connectionPublisher.sink { [weak self] agenda in
            self?.setConnection(gettedAgenda: agenda)
        }
        .store(in: &cancellables)
    }
    
    private func updateContactUpdate(hasSuccess: Bool) {
        DispatchQueue.main.async {
            if hasSuccess {
                self.isAddingNewContact = false
                self.contactToAddName = ""
                self.contactToAddPhone = ""
                self.feedBackMessage = "Ação realizada com sucesso, atualize a listagem!"
            } else {
                self.feedBackMessage = "Não foi possível realizar ação!"
            }
        }
    }
    
    private func setConnection(gettedAgenda: Agenda?) {
        DispatchQueue.main.async {
            if gettedAgenda == nil {
                self.connected = false
                self.isLoadingConnection = false
            } else {
                self.connected = true
                self.isLoadingConnection = false
                self.connectedAgenda = gettedAgenda
            }
        }
    }
    
    private func updateContactsList(list: [Contact]) {
        DispatchQueue.main.async {
            self.contactsList = list
            self.isLoadingContactList = false
        }
    }
}
