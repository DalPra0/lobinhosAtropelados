//
//  TarefaModel.swift
//  
//
//  Created by Beatriz Perotto Muniz on 25/06/25.
//

// IMPORTANTE = ESSE ARQV SERÁ SUBSTITUIDO
// APENAS PARA TESTE



import Foundation

var TarefasList: [Tarefa] = [
    Tarefa(nome: "Task 1", descricao: nil, duracao_minutos: 90, dificuldade: "Alto", esforco: "Média", importancia : "Média",prioridade: nil),
    Tarefa(nome: "Task 2", descricao: "descricao task 2", duracao_minutos: 60, dificuldade: "Alto", esforco: "Fácil", importancia : "Média", prioridade: nil)
]

func adiciona_tarefa(Nome : String, Descricao: String?, Duracao_minutos: Int ,Dificuldade: String, Esforco: String, Importancia : String){
    TarefasList.append(Tarefa(nome: Nome, descricao: Descricao, duracao_minutos: Duracao_minutos, dificuldade: Dificuldade, esforco: Esforco,importancia : Importancia, prioridade: nil))
}

func deletar_tarefa(id: UUID){
    for i in 0..<TarefasList.count{
        if TarefasList[i].id == id{
            TarefasList.remove(at: i)
        }
    }
}

func atualizar_tarefa(id: UUID, Nome : String, Descricao: String?, Duracao_minutos: Int ,Dificuldade: String, Esforco: String, Importancia : String){
    for i in 0..<TarefasList.count{
        if TarefasList[i].id == id{
            TarefasList[i].nome = Nome
            TarefasList[i].descricao = Descricao
            TarefasList[i].duracao_minutos = Duracao_minutos
            TarefasList[i].dificuldade = Dificuldade
            TarefasList[i].esforco = Esforco
            TarefasList[i].importancia = Importancia

        }
    }
}
