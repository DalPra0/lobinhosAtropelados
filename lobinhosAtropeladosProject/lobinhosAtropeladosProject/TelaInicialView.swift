//
//  TelaInicialView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ana Agner on 26/06/25.
//

// PROBLEMA = QUANDO CLICO EM UM CONCLUIDO, TODAS CONCLUEM
import SwiftUI

struct BotaoSelecaoView: View {

    @Binding var selecionado: Bool
    
    var body: some View {
        Image(systemName: selecionado ? "largecircle.fill.circle" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(selecionado ? .blue : .gray)
            .font(.system(size: 20, weight: .bold, design: .default))
            .onTapGesture {
                self.selecionado.toggle()
            }
    }
}

struct TelaInicialView: View {
    //ADICIONEI - BIA
    //para lista de tarefas
    let listaTarefas = TarefasList
    //para abrir modal de edicao
    @State private var showModal = false
    //pra passar id de tarefa
    @State private var tarefa : UUID? = nil

    @State private var tarefaConcluida = false
    
    var body: some View {
        VStack(spacing: 24){ //coloquei duas vstack pq a lista já vem com padding horizontal e queria colocar padding apenas no título e botões
            VStack(alignment: .leading, spacing: 24) {
                HStack{
                    Text("Visualize suas atividades por prioridade")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                HStack(spacing: 16){
                    Button("Baixa"){
                    }
                    .cornerRadius(20)
                    .buttonStyle(.bordered)
                        .tint(.blue)
                    
                    Button("Média"){
                    }
                    .cornerRadius(20)
                    .buttonStyle(.bordered)
                        .tint(.blue)
                    
                    Button("Alta"){
                    }
                    .cornerRadius(20)
                    .buttonStyle(.bordered)
                        .tint(.blue)
                }
                .frame(maxWidth: .infinity)

            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
                List{
                    //o foreach pra pegar todas as tarefas da lista
                    ForEach(listaTarefas) { tarefa in
                        HStack{
                            BotaoSelecaoView(selecionado: $tarefaConcluida)
                            Text(tarefa.nome)
                                .strikethrough(tarefaConcluida)
                                .foregroundColor(tarefaConcluida ? .gray : .primary)
                        }.swipeActions {
                            Button(){
                                //ADICIONEI - BIA = FUNC DE TAREFA_MODEL
                                deletar_tarefa(id: tarefa.id)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button(){
                                //ADICIONEI - BIA = abrir modal com edicao
                                //$showModal
                                //$tarefa = tarefa.id
                                
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }

                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(.white)
            }
        .sheet(isPresented: $showModal) {
            // Conteúdo da sheet
            TarefaModalView(paginaAdicao : false)
                .presentationDetents([.large]) //sheet ocupe a tela inteira
        }
        }
    }



#Preview {
    TelaInicialView()
}
