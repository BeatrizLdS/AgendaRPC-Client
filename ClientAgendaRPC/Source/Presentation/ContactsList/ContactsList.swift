//
//  ContactsList.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import SwiftUI

struct ContactsList: View {
    @ObservedObject var vm: ConnectionViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (spacing: 10) {
                HStack {
                    Button {
                        Task {
                            vm.isLoadingContactList.toggle()
                            await vm.getContactsList()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                    
                    Spacer()
                    Text("Agenda listada: \(vm.connectedAgenda?.name ?? "-")")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        vm.isAddingNewContact.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                }
                
                if vm.isAddingNewContact {
                    AddContactCard(vm: vm)
                }
                
                if !vm.feedBackMessage.isEmpty {
                    Text(vm.feedBackMessage)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                                vm.feedBackMessage = ""
                            }
                        }
                        .padding()
                        .background(.yellow.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if vm.isLoadingContactList {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                    
                    Text("Carregando...")
                        .font(.headline)
                        .padding()
                }
                if !vm.isLoadingContactList {
                    if vm.contactsList.isEmpty {
                        Spacer()
                        Text("Nenhum contato listado!")
                            .foregroundColor(.gray)
                    }
                    if !vm.contactsList.isEmpty {
                        ForEach(vm.contactsList.indices, id: \.self) { index in
                            ContactCell(
                                currentContact: $vm.contactsList[index],
                                vm: vm
                            )
                            .padding(.horizontal, 8)
                        }
                        
                    }
                }
                Spacer()
            }
        }
        .onAppear{
            Task {
                await vm.getContactsList()
            }
        }
    }
}

#Preview {
    ContactsList(vm: ConnectionViewModel())
}
