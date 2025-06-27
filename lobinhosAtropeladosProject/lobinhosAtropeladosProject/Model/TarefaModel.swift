//
//  TarefaModel.swift
//  
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//

// IMPORTANTE = ESSE ARQV SERÁ SUBSTITUIDO
// APENAS PARA TESTE

// singleton
import Foundation
import Combine


class TarefaModel: ObservableObject {
    static let shared = TarefaModel()  // Instância única global
    
    @Published var tarefas: [Tarefa] = [
        /*Tarefa(nome: "Task 1", descricao: nil, duracao_minutos: 90, dificuldade: "Alto", esforco: "Média", importancia: "Média", prioridade: nil),
        Tarefa(nome: "Task 2", descricao: "descricao task 2", duracao_minutos: 60, dificuldade: "Alto", esforco: "Fácil", importancia: "Média", prioridade: nil)*/
    ]
    
    private init() { }
    
    func adiciona_tarefa(Nome: String, Descricao: String?, Duracao_minutos: Int, Dificuldade: String, Esforco: String, Importancia: String) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, duracao_minutos: Duracao_minutos, dificuldade: Dificuldade, esforco: Esforco, importancia: Importancia, prioridade: nil)
        tarefas.append(novaTarefa)
    }
    
    func deletar_tarefa(id: UUID) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas.remove(at: index)
        }
    }
    
    func atualizar_tarefa(id: UUID, Nome: String, Descricao: String?, Duracao_minutos: Int, Dificuldade: String, Esforco: String, Importancia: String) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas[index].nome = Nome
            tarefas[index].descricao = Descricao
            tarefas[index].duracao_minutos = Duracao_minutos
            tarefas[index].dificuldade = Dificuldade
            tarefas[index].esforco = Esforco
            tarefas[index].importancia = Importancia
        }
    }
    
    func detalhe(id: UUID) -> Tarefa? {
        return tarefas.first(where: { $0.id == id })
    }
}
