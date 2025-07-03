import SwiftUI


struct TarefaAddModalView: View {
    
    @ObservedObject var tarefaModel = TarefaModel.shared

    
    @Environment(\.dismiss) var dismiss
    
    
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var dificuldade: String = ""
    @State private var esforco: String = ""
    @State private var importancia: String = ""
    @State private var data_entrega: Date = Date()
    @State private var showAlertMessage = false
    
    @State private var hora_picker: Date = Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: Date()) ?? Date()
    
    var body: some View {
        
        ScrollView{
            
        VStack (spacing : 52){
                    
                VStack (alignment:.leading, spacing: 16) {
                
                VStack (alignment:.leading, spacing : 7){
                    Text ("Adicionar Tarefa")
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
                
                    
                VStack(alignment:.leading, spacing:10){
                    VStack(alignment:.leading, spacing:7){
                        Text("📆 Data de entrega")
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                        
                        Text("Qual a data de entrega?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    DatePicker("", selection: $data_entrega, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(height: 80)
                        .clipped()
                        .transition(.opacity)
                    
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
                    
                    
                }
                
                
                if showAlertMessage {
                    Text("Preencha todos os campos obrigatórios!")
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
                    if titulo.isEmpty || dificuldade.isEmpty {
                        showAlertMessage = true
                    }
                    else{
                        tarefaModel.adiciona_tarefa(Nome: titulo, Descricao: descricao, Duracao_minutos: 0, Dificuldade: dificuldade, Esforco: esforco, Importancia : importancia, Data_entrega : data_entrega)
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
        
    }


#Preview {
    TarefaAddModalView()
}
