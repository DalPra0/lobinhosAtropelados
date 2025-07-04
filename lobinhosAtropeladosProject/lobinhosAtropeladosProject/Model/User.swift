//
//  Tarefa.swift
//
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//
//to-do = salvar local, comparable

import Foundation

struct User: Codable, Identifiable {
    
    let id: UUID
    var nome: String
    var bio: String
    var curso: String
    var periodo: String
    
    var modo_selecionado: Int = 0
    
    var tempo_disponível_minutos : Int = 0
    
    var estiloOrganizacao: String?
    
    init(id: UUID = UUID(), nome: String, bio: String, curso: String, periodo: String, estiloOrganizacao: String? = nil) {
        self.id = id
        self.nome = nome
        self.bio = bio
        self.curso = curso
        self.periodo = periodo
        self.estiloOrganizacao = estiloOrganizacao
    }
}
