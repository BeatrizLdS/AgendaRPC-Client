//
//  ContactCell.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import SwiftUI

struct ContactCell: View {
    @Binding var currentContact: Contact
    @State var isEditing: Bool = false
    @State var newPhone: String = ""
    @ObservedObject var vm: ConnectionViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Nome: \(currentContact.name)")
                if isEditing {
                    TextField("Telefone", text: $newPhone)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text("Telefone: \(currentContact.phone)")
                }
            }
            Spacer()
            Button {
                if (isEditing) {
                    var toUpdate = currentContact
                    toUpdate.phone = newPhone
                    Task {
                        await vm.updateContact(contact: toUpdate)
                    }
                    isEditing.toggle()
                } else {
                    Task {
                        await vm.deleteContact(contact: currentContact)
                    }
                }
            } label: {
                Image(systemName: isEditing ? "checkmark" : "trash")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
            }
            .padding()
            .clipShape(Circle())
        }
        .padding(.leading, 5)
        .padding(.horizontal, 5)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            newPhone = currentContact.phone
            isEditing.toggle()
        }
    }
}

#Preview {
    ContactCell(currentContact: .constant(Contact(name: "Beatriz Leonel", phone: "(85) 98832-3247")), vm: ConnectionViewModel())
}
