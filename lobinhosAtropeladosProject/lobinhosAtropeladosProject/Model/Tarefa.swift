//
//  Tarefa.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//
//  Esta é a estrutura de dados para cada tarefa.
//  Atualizada para funcionar com a lógica de IA, persistência e ordenação.
//

import Foundation

// Adicionamos Codable e Comparable para que a tarefa possa ser salva,
// enviada via rede (JSON) e ordenada automaticamente na lista.
struct Tarefa: Codable, Identifiable, Comparable {
    
    // As propriedades que definem uma tarefa.
    let id: UUID
    var nome: String
    var descricao: String?
    var duracao_minutos: Int
    var dificuldade: String
    var esforco: String
    var importancia: String
    var concluida: Bool
    var prioridade: Int? // A IA vai preencher este campo.
    
    // O 'init' garante que novos objetos possam ser criados com valores padrão.
    init(id: UUID = UUID(), nome: String, descricao: String?, duracao_minutos: Int, dificuldade: String, esforco: String, importancia: String, concluida: Bool = false, prioridade: Int? = nil) {
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.duracao_minutos = duracao_minutos
        self.dificuldade = dificuldade
        self.esforco = esforco
        self.importancia = importancia
        self.concluida = concluida
        self.prioridade = prioridade
    }
    
    // A função de comparação que ensina o Swift a ordenar a lista.
    static func < (lhs: Tarefa, rhs: Tarefa) -> Bool {
        // REGRA 1: Tarefas incompletas sempre vêm antes das completas.
        if lhs.concluida != rhs.concluida {
            return !lhs.concluida
        }
        
        // REGRA 2: Se ambas são incompletas, ordena pela prioridade.
        // `?? Int.max` trata tarefas sem prioridade como se tivessem a menor prioridade (indo para o final).
        if !lhs.concluida {
            return lhs.prioridade ?? Int.max < rhs.prioridade ?? Int.max
        }
        
        // REGRA 3: Para tarefas já completas, ou como critério de desempate, ordena pelo nome.
        return lhs.nome < rhs.nome
    }
}
