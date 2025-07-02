//
//  PerfilView.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 26/06/25.
//

import SwiftUI

struct PerfilView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared

    @State private var isEditing = false
    @State private var nome: String = "Mari Oliveira"
    @State private var bio: String = "Estudante de Psicologia do 5º período na UFPR em tempo integral e faço estágio de 20h semanais."
    
    private var tarefas_concluidas_anteriormente: [Tarefa] {
        let hoje = Calendar.current.startOfDay(for: Date())
        
        return tarefaModel.tarefas.filter {
            $0.concluida && ($0.data_conclusao ?? Date.distantFuture) < hoje
        }
    }
    
    var body: some View {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer().frame(height: 32)

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue)

                    VStack(spacing: 4) {
                        if isEditing {
                            VStack(spacing: 2) {
                                TextField("Nome", text: $nome)
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)
                                    .frame(width: 200) // Largura parecida com o texto
                                
                                Rectangle()
                                    .frame(width: 200, height: 1)
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                        } else {
                            Text(nome)
                                .font(.title2.bold())
                                .multilineTextAlignment(.center)
                        }

                        Button(action: {
                            withAnimation {
                                isEditing = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("Editar perfil")
                                    .font(.subheadline)
                                Image(systemName: "pencil")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.gray)
                        }
                        .opacity(isEditing ? 0 : 1)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sobre mim:")
                            .font(.title3.bold())
                            .foregroundColor(.secondary)
                            .padding(.leading, 12)
                            .padding(.bottom, isEditing ? 2 : -12)

                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .disabled(!isEditing)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isEditing ? Color.gray.opacity(0.3) : Color.clear)
                            )
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()

                    if isEditing {
                        HStack(spacing: 16) {
                            Button(action: {
                                withAnimation {
                                    isEditing = false
                                }
                            }) {
                                Text("Cancelar")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(.systemGray5))
                                    .foregroundColor(.gray)
                                    .cornerRadius(16)
                            }

                            Button(action: {
                                withAnimation {
                                    isEditing = false
                                }
                            }) {
                                Text("Salvar")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(red: 0.8, green: 0.9, blue: 1.0))
                                    .foregroundColor(.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // lista de tarefas concluidas nos dias anteriores
                    List {
                                                
                        Section(header: Text("Concluídas")) {
                                ForEach(tarefas_concluidas_anteriormente) { tarefa in
                                    celulaDaTarefa(tarefa: tarefa)
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                }
            }
        }
    
    @ViewBuilder
    private func celulaDaTarefa(tarefa: Tarefa) -> some View {
        HStack(spacing: 15) {
            Button(action: {
                tarefaModel.marcarTarefa(tarefa: tarefa)
                //para fechar automatico quando expandida
            }) {
                Image(systemName: tarefa.concluida ? "checkmark.circle.fill" : "circle")
                    .font(.title2).foregroundColor(tarefa.concluida ? .green : .secondary)
            }.buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 5) {
                Text(tarefa.nome).font(.headline).strikethrough(tarefa.concluida, color: .primary)
                if let descricao = tarefa.descricao, !descricao.isEmpty {
                    Text(descricao).font(.subheadline).lineLimit(2).foregroundColor(.secondary)
                }
                    HStack {
                        HStack(spacing: 4) { Image(systemName: "hourglass"); Text("\(tarefa.duracao_minutos) min") }
                        Spacer()
                        HStack(spacing: 4) { Image(systemName: "bolt.fill"); Text(tarefa.importancia) }
                        
                    }.font(.caption).foregroundColor(.secondary).padding(.top, 4)
                }
                
            Spacer()
        }.padding(.vertical, 5).opacity(tarefa.concluida ? 0.6 : 1.0)
    }
    
    }

#Preview {
    PerfilView()
}
