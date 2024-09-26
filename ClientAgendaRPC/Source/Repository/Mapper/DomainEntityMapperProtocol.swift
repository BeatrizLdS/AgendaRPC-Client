//
//  DomainEntityMapperProtocol.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

protocol DomainEntityMapperProtocol {
    associatedtype DTO
    associatedtype DomainEntity
    func mapToDomain(_ dto: DTO) -> DomainEntity
}
