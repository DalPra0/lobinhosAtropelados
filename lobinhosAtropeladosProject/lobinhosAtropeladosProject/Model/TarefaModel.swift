//
//  TarefaModel.swift
//
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//
//  Atualizado para incluir persistência de dados e a lógica de priorização com IA.
// TO-DO CHECAR ATUALIZAR TAREFAS

import Foundation
import SwiftUI

@MainActor
class TarefaModel: ObservableObject {
    static let shared = TarefaModel()
    
    private let saveKey = "TarefasLoboApp"
    private let geminiService = GeminiService()
    @Published var estaPriorizando = false
    
    @Published var tarefas: [Tarefa] = [] {
        didSet {
            salvarTarefas()
        }
    }
    
    private init() {
        carregarTarefas()
    }
    
    
    func adiciona_tarefa(Nome: String, Descricao: String?, Duracao_minutos: Int, Dificuldade: String, Esforco: String, Importancia: String,Data_entrega: Date) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, duracao_minutos: Duracao_minutos, dificuldade: Dificuldade, esforco: Esforco, importancia: Importancia, data_entrega: Data_entrega)
        tarefas.append(novaTarefa)
        repriorizarLista()
    }
    
    func deletar_tarefa(id: UUID) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas.remove(at: index)
        }
    }
    
    func atualizar_tarefa(id: UUID, Nome: String, Descricao: String?, Duracao_minutos: Int, Dificuldade: String, Esforco: String, Importancia: String, Data_entrega: Date) {
        if let index = tarefas.firstIndex(where: { $0.id == id }) {
            tarefas[index].nome = Nome
            tarefas[index].descricao = Descricao
            tarefas[index].duracao_minutos = Duracao_minutos
            tarefas[index].dificuldade = Dificuldade
            tarefas[index].esforco = Esforco
            tarefas[index].importancia = Importancia
            tarefas[index].data_entrega = Data_entrega
        }
        repriorizarLista()//ADICAO
    }
    
    func detalhe(id: UUID) -> Tarefa {
        return tarefas.first(where: { $0.id == id }) ?? Tarefa(
            nome: "Tarefa não encontrada",
            descricao: "Nenhuma tarefa com esse ID.",
            duracao_minutos: 0,
            dificuldade: "Desconhecida",
            esforco: "Desconhecido",
            importancia: "Desconhecida",
            concluida: false,
            data_entrega : Date(),
            prioridade: nil
        )
    }
    
    private func salvarTarefas() {
        if let encodedData = try? JSONEncoder().encode(tarefas) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    private func carregarTarefas() {
        guard let savedData = UserDefaults.standard.data(forKey: saveKey),
              let decodedTasks = try? JSONDecoder().decode([Tarefa].self, from: savedData) else {
            self.tarefas = []
            return
        }
        self.tarefas = decodedTasks.sorted()
    }

    func repriorizarLista() {
        Task {
            self.estaPriorizando = true
            
            do {
                let tarefasPriorizadas = try await geminiService.priorizarTarefas(self.tarefas)
                self.tarefas = tarefasPriorizadas.sorted()
            } catch {
                print("Erro ao priorizar tarefas: \(error)")
            }
            
            self.estaPriorizando = false
        }
    }
    func marcarTarefa(tarefa: Tarefa) {
        if let index = tarefas.firstIndex(where: { $0.id == tarefa.id }) {
            tarefas[index].concluida.toggle()
            if tarefas[index].concluida == true {
                tarefas[index].data_conclusao = Date()
            }else{
                tarefas[index].data_conclusao = nil
            }
            //teste
            print(tarefas)

            tarefas.sort()
        }
    }
}
