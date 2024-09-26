//
//  AddContactCard.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import SwiftUI

struct AddContactCard: View {
    @ObservedObject var vm: ConnectionViewModel
    
    var body: some View {
        VStack (spacing: 10) {
            VStack {
                TextField("Nome", text: $vm.contactToAddName).textFieldStyle(.roundedBorder)
                TextField("Telefone", text: $vm.contactToAddPhone).textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Spacer()
                Button {
                    Task {
                        vm.isAddingNewContact = true
                        await vm.addContact()
                    }
                } label: {
                    Text("Adicionar")
                }
                .buttonStyle(.bordered)
            }

        }
        .padding()
        .background(
            Color.gray.opacity(0.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    AddContactCard(vm: ConnectionViewModel())
}
