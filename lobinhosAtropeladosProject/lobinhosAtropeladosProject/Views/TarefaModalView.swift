import SwiftUI

// problema, sempre na primeira vez que abre edicao cai na generica

struct TarefaModalView: View {
    
    @ObservedObject var tarefaModel = TarefaModel.shared

    @State var paginaAdicao: Bool
    //quando paginaAdicao=false , sera edicao, e tera que passar o id da tarefa
    @State var id: UUID
    
    //para botao cancelar poder fechar
    @Environment(\.dismiss) var dismiss
    
    
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var dificuldade: String = ""
    @State private var esforco: String = ""
    @State private var importancia: String = ""
    @State private var duracao: Int = 0
    
    var body: some View {

        var tarefa: Tarefa {
            let tarefa = tarefaModel.detalhe(id: id)
            if tarefa != nil{
                return tarefa!
            }
            print(id)
            print(tarefaModel.tarefas)
            return Tarefa(nome: "generica", descricao: "generica", duracao_minutos: 60, dificuldade: "Alto", esforco: "Fácil", importancia: "Média", prioridade: nil)
        }
        
        VStack {
            
            if (paginaAdicao){
                Text("Adicione tarefa")
            }else{
                Text("Edite tarefa \(tarefa.nome)")
            }
            TextField(
                "",
                text: $titulo,
                prompt: Text("Nome da Tarefa")
                    .font(.body)
                    .foregroundStyle(.tertiary)
            )
            .font(.body)
            .foregroundStyle(.black)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
            }
            
            Text("Esta é a sua Nova Sheet!")
                .font(.largeTitle)
                .padding()

            Text("Ela ocupa a tela inteira.")
                .font(.title2)
                .padding(.bottom, 20)

            HStack {
                Button("Cancelar") {
                    dismiss() // Fecha a sheet
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                Button("Salvar") {
                    tarefaModel.adiciona_tarefa(Nome: "teste", Descricao: descricao, Duracao_minutos: duracao, Dificuldade: dificuldade, Esforco: esforco, Importancia : importancia)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    TarefaModalView(paginaAdicao: true, id : UUID())
}
