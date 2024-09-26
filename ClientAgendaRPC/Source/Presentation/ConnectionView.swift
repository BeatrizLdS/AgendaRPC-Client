//
//  ContentView.swift
//  ClientAgendaRPC
//
//  Created by Beatriz Leonel da Silva on 25/09/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ConnectionViewModel = ConnectionViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoadingConnection {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
                
                Text("Carregando...")
                    .font(.headline)
                    .padding()
            } else {
                if !viewModel.connected {
                    Button {
                        Task{
                            viewModel.isLoadingConnection.toggle()
                            await viewModel.startConnection()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                }
                else{
                    ContactsList(vm: viewModel)
                }
            }
        }
        .padding()
        .onAppear {
            Task{
                viewModel.isLoadingConnection.toggle()
                await viewModel.startConnection()
            }
        }
    }
}

#Preview {
    ContentView()
}
