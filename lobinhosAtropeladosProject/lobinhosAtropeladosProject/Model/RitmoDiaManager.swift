//
//  RitmoDiaManager.swift
//  lobinhosAtropeladosProject
//
//  Created by Gemini on 01/07/25.
//
//  VERSÃO CORRIGIDA: Resolve o erro de inicialização do Swift.
//

import Foundation
import SwiftUI

enum RitmoDiario: String, Codable {
    case tranquilo = "Tranquilo"
    case moderado = "Moderado"
    case intenso = "Intenso"
    case nenhum = "Nenhum"
}

@MainActor
class RitmoDiaManager: ObservableObject {
    
    static let shared = RitmoDiaManager()
    
    @AppStorage("ritmoDiarioEscolhido") private var ritmoSalvo: String = RitmoDiario.nenhum.rawValue
    @AppStorage("tempoDisponivelSalvo") private var tempoSalvo: Int = 0
    @AppStorage("ultimaDataVisualizacaoRitmo") private var ultimaData: String = ""

    @Published var ritmoAtual: RitmoDiario
    @Published var tempoDisponivelEmMinutos: Int
    @Published var mostrarTelaDeRitmo: Bool = false

    // CORREÇÃO APLICADA AQUI
    private init() {
        // Inicializamos as propriedades lendo diretamente do UserDefaults,
        // sem usar 'self', para cumprir as regras de inicialização do Swift.
        let savedRitmoRawValue = UserDefaults.standard.string(forKey: "ritmoDiarioEscolhido") ?? RitmoDiario.nenhum.rawValue
        self.ritmoAtual = RitmoDiario(rawValue: savedRitmoRawValue) ?? .nenhum
        
        self.tempoDisponivelEmMinutos = UserDefaults.standard.integer(forKey: "tempoDisponivelSalvo")
        
        // Agora que todas as propriedades estão inicializadas, podemos chamar outros métodos.
        verificarSeDeveMostrarTela()
    }
    
    private func verificarSeDeveMostrarTela() {
        let hoje = Date().formatted(date: .abbreviated, time: .omitted)
        if ultimaData != hoje {
            mostrarTelaDeRitmo = true
        }
    }
    
    func concluirSelecaoDeRitmo(ritmo: RitmoDiario?, tempoEmMinutos: Int?) {
        let hoje = Date().formatted(date: .abbreviated, time: .omitted)
        
        let novoRitmo = ritmo ?? .nenhum
        let novoTempo = tempoEmMinutos ?? 0
        
        // Atualiza as propriedades publicadas
        self.ritmoAtual = novoRitmo
        self.tempoDisponivelEmMinutos = novoTempo
        
        // Salva os novos valores no AppStorage
        self.ritmoSalvo = novoRitmo.rawValue
        self.tempoSalvo = novoTempo
        self.ultimaData = hoje
        
        self.mostrarTelaDeRitmo = false
        
        // Dispara a repriorização da IA com as novas informações
        TarefaModel.shared.repriorizarLista(comRitmo: self.ritmoAtual, tempoDisponivel: self.tempoDisponivelEmMinutos)
    }
}
