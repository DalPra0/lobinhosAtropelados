//
//  TelaInicialView.swift
//  lobinhosAtropeladosProject
//
//  Created by Ana Agner on 26/06/25.
//

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
    @ObservedObject var tarefaModel = TarefaModel.shared
    //para abrir modal de edicao
    @State private var showModal = false
    //pra passar id de tarefa
    @State private var tarefa_id : UUID = UUID()
    
    @State private var filtro: String = "Baixa"

    
    var body: some View {
        VStack(spacing: 24){ //coloquei duas vstack pq a lista já vem com padding horizontal e queria colocar padding apenas no título e botões
            VStack(alignment: .leading, spacing: 24) {
                HStack{
                    Text("Visualize suas atividades por prioridade")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                HStack(spacing:17){
                    Button{
                        filtro="Baixa"
                    }
                    label:{
                        Text("Baixa")
                            .foregroundColor(filtro == "Baixa" ? .white : .blue)
                            .font(.subheadline)
                            .padding(.horizontal, 33)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(filtro == "Baixa" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                    }
                    
                    Button{
                        filtro="Média"
                    }
                    label:{
                        Text("Média")
                            .foregroundColor(filtro == "Média" ? .white : .blue)
                            .font(.subheadline)
                            .padding(.horizontal, 31)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(filtro == "Média" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                    }
                    
                    Button{
                        filtro="Alta"
                    }
                    label:{
                        Text("Alta")
                            .foregroundColor(filtro == "Alta" ? .white : .blue)
                            .font(.subheadline)
                            .padding(.horizontal, 38)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(filtro == "Alta" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                    }
                }

                .frame(maxWidth: .infinity)

            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
                List{
                    //o foreach pra pegar todas as tarefas da lista
                    ForEach($tarefaModel.tarefas) { tarefa in
                        HStack{
                            BotaoSelecaoView(selecionado: tarefa.concluida)
                            //EDITADO - BIA = muda quando removo ou adiciono uma tarefa, use o wrapped value para ser dinamico
                            Text(tarefa.nome.wrappedValue)
                                .strikethrough(tarefa.concluida.wrappedValue)
                                .foregroundColor(tarefa.concluida.wrappedValue ? .gray : .primary)
                        }.swipeActions {
                            Button(){
                                //ADICIONEI - BIA = FUNC DE TAREFA_MODEL
                                tarefaModel.deletar_tarefa(id: tarefa.id)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            /*Button(){
                                //ADICIONEI - BIA = abrir modal com edicao
                                tarefa_id = tarefa.id
                                showModal = true
                                
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            .tint(.blue)*/
                        }
                    }

                    
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(.white)
            }
        
        //ADICIONEI - BIA = para mostrar modal
        /*.sheet(isPresented: $showModal) {
            TarefaModalView(paginaAdicao : false, id: tarefa_id)
                .presentationDetents([.large])
        }*/
        }
    }



#Preview {
    TelaInicialView()
}
