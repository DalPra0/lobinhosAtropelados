import SwiftUI


struct TelaEditModalView: View {
    
    @ObservedObject var tarefaModel = TarefaModel.shared

    
    @Environment(\.dismiss) var dismiss
    @State var id: UUID

    @State private var titulo:String
    @State private var descricao: String
    @State private var dificuldade: String
    @State private var esforco: String
    @State private var importancia: String
    @State private var duracao: Int
    @State private var showAlertMessage = false
    
    init(id: UUID) {
        self._id = State(initialValue: id)
        
        let tarefa = TarefaModel.shared.detalhe(id: id)
        
        self._titulo = State(initialValue: tarefa.nome)
        self._descricao = State(initialValue: tarefa.descricao ?? "")
        self._dificuldade = State(initialValue: tarefa.dificuldade)
        self._esforco = State(initialValue: tarefa.esforco)
        self._importancia = State(initialValue: tarefa.importancia)
        self._duracao = State(initialValue: tarefa.duracao_minutos)
    }
    
    var body: some View {
        
        
        VStack (spacing : 52){
            
            VStack (alignment:.leading, spacing: 16) {
                
                VStack (alignment:.leading, spacing : 7){
                    Text ("Editar Tarefa")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                    
                    TextField(
                        "",
                        text: $titulo,
                        prompt: Text("Nome da Tarefa...")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .tertiaryLabel))
                    )
                    .font(.body)
                    .foregroundStyle(.black)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                    }
                    
                    TextField(
                        "",
                        text: $descricao,
                        prompt: Text("Descrição...")
                            .font(.body)
                            .foregroundStyle(Color(uiColor: .tertiaryLabel))
                    )
                    .font(.body)
                    .foregroundStyle(.black)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                    }
                }
                
                VStack(alignment:.leading, spacing:24){
                    
                    VStack(alignment:.leading, spacing:10){
                        VStack(alignment:.leading, spacing:7){
                           Text("🏋️‍♂️ Dificuldade")
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                            
                            Text("Qual a dificuldade dessa tarefa?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        //filtro
                        HStack(spacing:17){
                            Button{
                                dificuldade="Baixa"
                            }
                            label:{
                                Text("Baixa")
                                    .foregroundColor(dificuldade == "Baixa" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 33)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(dificuldade == "Baixa" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                            
                            Button{
                                dificuldade="Média"
                            }
                            label:{
                                Text("Média")
                                    .foregroundColor(dificuldade == "Média" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 31)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(dificuldade == "Média" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                            
                            Button{
                                dificuldade="Alta"
                            }
                            label:{
                                Text("Alta")
                                    .foregroundColor(dificuldade == "Alta" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 38)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(dificuldade == "Alta" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                        }
                    }
                    VStack(alignment:.leading, spacing:10){
                        VStack(alignment:.leading, spacing:7){
                            Text("💪 Esforço")
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                            
                            Text("Quanto de esforço preciso aplicar nessa tarefa?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        //filtro
                        HStack(spacing:17){
                            Button{
                                esforco="Baixo"
                            }
                            label:{
                                Text("Baixo")
                                    .foregroundColor(esforco == "Baixo" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 33)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(esforco == "Baixo" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                            
                            Button{
                                esforco="Médio"
                            }
                            label:{
                                Text("Médio")
                                    .foregroundColor(esforco == "Médio" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 31)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(esforco == "Médio" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                            
                            Button{
                                esforco="Alto"
                            }
                            label:{
                                Text("Alto")
                                    .foregroundColor(esforco == "Alto" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 38)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(esforco == "Alto" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                        }
                    }
                    VStack(alignment:.leading, spacing:10){
                        VStack(alignment:.leading, spacing:7){
                            Text("📝 Importância")
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                            
                            Text("Qual a importância dessa tarefa?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        //filtro
                        HStack(spacing:17){
                            Button{
                                importancia="Baixa"
                            }
                            label:{
                                Text("Baixa")
                                    .foregroundColor(importancia == "Baixa" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 33)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(importancia == "Baixa" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                            
                            Button{
                                importancia="Média"
                            }
                            label:{
                                Text("Média")
                                    .foregroundColor(importancia == "Média" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 31)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(importancia == "Média" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                            
                            Button{
                                importancia="Alta"
                            }
                            label:{
                                Text("Alta")
                                    .foregroundColor(importancia == "Alta" ? .white : .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 38)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(importancia == "Alta" ? Color.blue.opacity(1) : Color.blue.opacity(0.13)))
                            }
                        }
                    }
                    
                    
                    VStack(alignment:.leading, spacing:10){
                        VStack(alignment:.leading, spacing:7){
                            Text("🕐 Duração (em horas)")
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                            
                            Text("Quanto tempo vou levar para fazer essa tarefa?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing:17){
                            Button{
                                if(duracao>=30){
                                    duracao=duracao-30
                                }
                            }
                            label:{
                                Text("-30min")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 26)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill( Color.blue.opacity(0.13)))
                            }
                            
                            
                            Text(String(format: "%02d:%02d", duracao / 60, duracao % 60))
                                .foregroundColor(.secondary)
                                    .font(.subheadline)
                                    .padding(.horizontal, 31)
                                    .padding(.vertical, 7)
                                    /*.background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill( Color.gray.opacity(0.13)))*/
                            
                            
                            Button{
                                duracao=duracao+30
                            }
                            label:{
                                Text("+30min")
                                    .foregroundColor( .blue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 26)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill( Color.blue.opacity(0.13)))
                            }
                        }

                        
                    }
                    
                }
                
                
                if showAlertMessage {
                    Text("Título deve ser preenchido")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 5)
                }
                
                
            }
            
            HStack {
                Button(){
                    dismiss() // Fecha a sheet
                }label: {
                    Text("Cancelar")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal, 32.5)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.red.opacity(0.13))
                        )
                }
                Spacer()
                Button(){
                    if titulo.isEmpty {
                        showAlertMessage = true
                    }
                    else{
                        tarefaModel.atualizar_tarefa(id:id, Nome: titulo, Descricao: descricao, Duracao_minutos: duracao, Dificuldade: dificuldade, Esforco: esforco, Importancia : importancia)
                        //teste
                        //print(tarefaModel.tarefas)
                        dismiss()
                    }
                }label:{
                        Text("Salvar")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                            .padding(.horizontal, 41.5)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(Color.blue.opacity(0.13))
                            )
                    
                }
            }.padding(.horizontal,37)
        }
        .padding(.horizontal,24)
        .padding(.top,29)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
        
    }


/*#Preview {
    TelaEditModalView()
}*/
