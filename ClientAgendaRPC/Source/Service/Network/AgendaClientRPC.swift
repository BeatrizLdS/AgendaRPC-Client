//
//  AgendaClientRPC.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import Foundation
import GRPC
import Combine
import NIOCore
import NIOPosix

class AgendaClientRPC: AgendaClientRPCProtocol {
    var connectionPublisher = PassthroughSubject<Agenda?, Never>()
    
    var responsePublisher = PassthroughSubject<Agenda_Response?, Never>()
    var contactsPublisher =  PassthroughSubject<Agenda_ContactsList?, Never>()
    
    var connection: ClientConnection?
    var client: Agenda_AgendaServiceAsyncClient?
    
    var host: String
    
    init(host: String) async {
        self.host = host
    }
    
    func updateContact(contact: Agenda_Contact) async {
        do {
            let result = try await withTimeout(seconds: 1) {
                try await self.client?.updateContact(contact)
            }
            responsePublisher.send(result)
        } catch {
            print(error)
            responsePublisher.send(nil)
        }
    }
    
    func deleteContact(contact: Agenda_Contact) async {
        do {
            let result = try await withTimeout(seconds: 1) {
                try await self.client?.removeContact(contact)
            }
            responsePublisher.send(result)
        } catch {
            print(error)
            responsePublisher.send(nil)
        }
    }
    
    func addContact(contact: Agenda_Contact) async {
        do {
            let result = try await withTimeout(seconds: 1) {
                try await self.client?.addContact(contact)
            }
            responsePublisher.send(result)
        } catch {
            print(error)
            responsePublisher.send(nil)
        }
    }
    
    func getContactsList() async {
        do {
            let result = try await withTimeout(seconds: 5) {
                try await self.client?.getAllContacts(.init())
            }
            contactsPublisher.send(result)
        } catch {
            print(error)
            contactsPublisher.send(nil)
        }
    }
    
    
    func connecToAvailableAgenda() async {
        let agendas = Agenda.getAll()
        for agenda in agendas {
            let isAvailable = await checkConnection(agenda: agenda)
            if isAvailable {
                connectionPublisher.send(agenda)
                return
            }
        }
        connectionPublisher.send(nil)
    }
    
    private func checkConnection(agenda: Agenda) async -> Bool{
        do {
            let port = CommunicationPorts.getPort(for: agenda)
            createConnection(port: port)
            
            _ = try await withTimeout(seconds: 1) {
                try await self.client?.checkConnection(.init())
            }
        
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    private func createConnection(port: Int) {
        self.connection = ClientConnection.init(
            configuration: ClientConnection.Configuration(
                target: .hostAndPort(host, port),
                eventLoopGroup: MultiThreadedEventLoopGroup(numberOfThreads: 1)
            )
        )
        self.client = Agenda_AgendaServiceAsyncClient(channel: self.connection!)
    }
    
    private func withTimeout<T>(seconds: UInt64, operation: @escaping () async throws -> T) async throws -> T {
        return try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                return try await operation()
            }
            
            group.addTask {
                try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
                throw CancellationError()
            }
            
            guard let result = try await group.next() else {
                throw CancellationError()
            }
            
            return result
        }
    }
    
    enum CommunicationPorts: Int {
        case agenda1 = 1200
        case agenda2 = 1201
        case agenda3 = 1202
        
        static func getPort(for agenda: Agenda) -> Int {
            switch agenda {
            case .agendaOne:
                return CommunicationPorts.agenda1.rawValue
            case .agendaTwo:
                return CommunicationPorts.agenda2.rawValue
            case .agendaThree:
                return CommunicationPorts.agenda3.rawValue
            }
        }
    }
}
