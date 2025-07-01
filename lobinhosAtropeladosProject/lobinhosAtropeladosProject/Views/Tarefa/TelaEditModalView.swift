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
    @State private var data_entrega: Date = Date()
    @State private var showAlertMessage = false
    
    @State private var hora_picker: Date = Date()

    
    init(id: UUID) {
        self._id = State(initialValue: id)
        
        let tarefa = TarefaModel.shared.detalhe(id: id)
        
        self._titulo = State(initialValue: tarefa.nome)
        self._descricao = State(initialValue: tarefa.descricao ?? "")
        self._dificuldade = State(initialValue: tarefa.dificuldade)
        self._esforco = State(initialValue: tarefa.esforco)
        self._importancia = State(initialValue: tarefa.importancia)
        self._data_entrega = State(initialValue: tarefa.data_entrega)
        let horas = tarefa.duracao_minutos / 60
        let minutos = tarefa.duracao_minutos % 60
        let date = Calendar.current.date(bySettingHour: horas, minute: minutos, second: 0, of: Date()) ?? Date()
        self._hora_picker = State(initialValue: date)
    }
    
    var body: some View {
        ScrollView{
            
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
                                Text("🕐 Duração")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 18))
                                
                                Text("Quanto tempo vou levar para fazer essa tarefa?")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            DatePicker("", selection: $hora_picker, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 80)
                                .clipped()
                                .transition(.opacity)
                            
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
                            tarefaModel.atualizar_tarefa(id:id, Nome: titulo, Descricao: descricao, Duracao_minutos: horas_para_minutos(horas:hora_picker), Dificuldade: dificuldade, Esforco: esforco, Importancia : importancia, Data_entrega: data_entrega)
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
    
    private func horas_para_minutos(horas:Date) -> Int{
        let calendario = Calendar.current
        let componentes = calendario.dateComponents([.hour, .minute], from: horas)
        return (componentes.hour ?? 0) * 60 + (componentes.minute ?? 0)
    }
        
    }


/*#Preview {
    TelaEditModalView()
}*/
