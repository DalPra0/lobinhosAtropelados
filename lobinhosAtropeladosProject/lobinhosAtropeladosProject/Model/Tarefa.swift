//
//  Tarefa.swift
//
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//

import Foundation

struct Tarefa: Identifiable {
    let id = UUID()
    var nome: String
    var descricao: String?  // Opcional
    var duracao_minutos: Int   // para usar em hora divida por 60
    var dificuldade: String     //texto botao
    var esforco: String        // texto botao
    var importancia: String        // texto botao
    var concluida: Bool = false   // para selecionado da tarefa funcionar
    var prioridade : Int?      // o que a IA vai alterar -> null (nil no swift) ou int
}
