//
//  ResponseMapper.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

protocol ResponseMapperProtocol: DomainEntityMapperProtocol where DTO == Agenda_Response, DomainEntity == Bool {}

class ResponseMapper: ResponseMapperProtocol {
    func mapToDomain(_ dto: Agenda_Response) -> Bool {
        return dto.isSuccess
    }
}
