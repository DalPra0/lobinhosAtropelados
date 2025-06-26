import SwiftUI

struct TarefaModalView: View {
    
    let listaTarefas = TarefasList

    @State var paginaAdicao: Bool
    //quando paginaAdicao=false , sera edicao, e tera que passar o id da tarefa
    @State var id: UUID?
    
    //para botao cancelar poder fechar
    @Environment(\.dismiss) var dismiss
    
    
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var dificuldade: String = ""
    @State private var esforco: String = ""
    @State private var importancia: String = ""
    @State private var duracao: Int = 30
    
    var body: some View {
        VStack {
            
            TextField(
                "",
                text: $titulo,
                prompt: Text("Nome da Tarefa")
                    .foregroundStyle((Color(UIColor.systemGray3)))
                    .font(.custom("Helvetica Neue", size: 14))
            )
            .font(.subheadline)
            .foregroundStyle(.primary)
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
                    adiciona_tarefa(Nome: titulo, Descricao: descricao, Duracao_minutos: duracao, Dificuldade: dificuldade, Esforco: esforco, Importancia : importancia)
                }
                .buttonStyle(.borderedProminent)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Faz a VStack preencher a tela
    }
}

#Preview {
    TarefaModalView(paginaAdicao: true)
}
