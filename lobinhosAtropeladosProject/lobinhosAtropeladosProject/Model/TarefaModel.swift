//
//  TarefaModel.swift
//
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//
//  Atualizado para incluir persistência de dados e a lógica de priorização com IA.
//

import Foundation
import SwiftUI

@MainActor
class TarefaModel: ObservableObject {
    // Usando o padrão Singleton para ter uma única instância no app.
    static let shared = TarefaModel()
    
    private let saveKey = "TarefasLoboApp"
    private let geminiService = GeminiService()
    @Published var estaPriorizando = false
    
    // A lista de tarefas agora salva automaticamente sempre que é modificada.
    @Published var tarefas: [Tarefa] = [] {
        didSet {
            salvarTarefas()
        }
    }
    
    // O construtor é privado e carrega as tarefas salvas ao iniciar.
    private init() {
        carregarTarefas()
    }
    
    func adiciona_tarefa(Nome: String, Descricao: String?, Duracao_minutos: Int, Dificuldade: String, Esforco: String, Importancia: String) {
        let novaTarefa = Tarefa(nome: Nome, descricao: Descricao, duracao_minutos: Duracao_minutos, dificuldade: Dificuldade, esforco: Esforco, importancia: Importancia)
        tarefas.append(novaTarefa)
        
        // Chama a IA para repriorizar com o ritmo e tempo atuais.
        repriorizarLista(
            comRitmo: RitmoDiaManager.shared.ritmoAtual,
            tempoDisponivel: RitmoDiaManager.shared.tempoDisponivelEmMinutos
        )
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
        
        // Chama a IA para repriorizar após a edição.
        repriorizarLista(
            comRitmo: RitmoDiaManager.shared.ritmoAtual,
            tempoDisponivel: RitmoDiaManager.shared.tempoDisponivelEmMinutos
        )
    }
    
    func detalhe(id: UUID) -> Tarefa {
        return tarefas.first(where: { $0.id == id }) ?? Tarefa(
            nome: "Tarefa não encontrada",
            descricao: "Nenhuma tarefa com esse ID.",
            duracao_minutos: 0,
            dificuldade: "Desconhecida",
            esforco: "Desconhecido",
            importancia: "Desconhecida"
        )
    }
    
    // Salva a lista de tarefas no dispositivo.
    private func salvarTarefas() {
        if let encodedData = try? JSONEncoder().encode(tarefas) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    // Carrega a lista de tarefas do dispositivo.
    private func carregarTarefas() {
        guard let savedData = UserDefaults.standard.data(forKey: saveKey),
              let decodedTasks = try? JSONDecoder().decode([Tarefa].self, from: savedData) else {
            self.tarefas = []
            return
        }
        self.tarefas = decodedTasks.sorted()
    }

    // A função que chama o GeminiService.
    func repriorizarLista(comRitmo ritmo: RitmoDiario, tempoDisponivel: Int) {
        Task {
            self.estaPriorizando = true
            
            do {
                let tarefasPriorizadas = try await geminiService.priorizarTarefas(self.tarefas, comRitmo: ritmo, tempoDisponivel: tempoDisponivel)
                self.tarefas = tarefasPriorizadas.sorted()
            } catch {
                print("Erro ao priorizar tarefas: \(error)")
            }
            
            self.estaPriorizando = false
        }
    }
    
    // Marca uma tarefa como concluída ou não.
    func marcarTarefa(tarefa: Tarefa) {
        if let index = tarefas.firstIndex(where: { $0.id == tarefa.id }) {
            tarefas[index].concluida.toggle()
            tarefas.sort()
        }
    }
}
