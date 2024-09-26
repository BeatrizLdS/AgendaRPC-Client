//
//  Agenda.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

enum Agenda: String, CaseIterable{
    case agendaOne = "agenda1"
    case agendaTwo = "agenda2"
    case agendaThree = "agenda3"
    
    var name: String {
        return self.rawValue
    }
    
    static func getAll() -> [Agenda] {
        return Agenda.allCases
    }
}
