//
//  Tarefa.swift
//
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//

import Foundation

struct Tarefa: Identifiable {
    let id = UUID()
    let nome: String
    let descricao: String?  // Opcional
    let duracao_minutos: Int   // para usar em hora divida por 60
    let dificuldade: String     //texto botao
    var esforco: String        // texto botao
    var prioridade : Int?      // o que a IA vai alterar -> null (nil no swift) ou int
}
