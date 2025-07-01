//
//  Tarefa.swift
//
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//
//  Atualizado com a lógica de IA, persistência e ordenação.
// to- do = data de entrega

import Foundation

struct Tarefa: Codable, Identifiable, Comparable {
    
    let id: UUID
    var nome: String
    var descricao: String?
    var duracao_minutos: Int
    var dificuldade: String
    var esforco: String
    var importancia: String
    var concluida: Bool
    var data_conclusao: Date? = nil
    var data_entrega: Date
    var prioridade: Int?
    
    init(id: UUID = UUID(), nome: String, descricao: String?, duracao_minutos: Int, dificuldade: String, esforco: String, importancia: String, concluida: Bool = false, data_entrega : Date, prioridade: Int? = nil) {
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.duracao_minutos = duracao_minutos
        self.dificuldade = dificuldade
        self.esforco = esforco
        self.importancia = importancia
        self.concluida = concluida
        self.data_entrega = data_entrega
        self.prioridade = prioridade
    }
    
    static func < (lhs: Tarefa, rhs: Tarefa) -> Bool {
        if lhs.concluida != rhs.concluida {
            return !lhs.concluida
        }
        
        if !lhs.concluida {
            return lhs.prioridade ?? Int.max < rhs.prioridade ?? Int.max
        }
        
        return lhs.nome < rhs.nome
    }
}
