import SwiftUI


struct TelaEditModalView: View {
    
    @ObservedObject var tarefaModel = TarefaModel.shared

    
    @Environment(\.dismiss) var dismiss
    @State var id: UUID

    @State private var titulo:String
    @State private var descricao: String
    @State private var dificuldade: String
    @State private var data_entrega: Date = Date()
    @State private var showAlertMessage = false
    
    @State private var hora_picker: Date = Date()

    
    init(id: UUID) {
        self._id = State(initialValue: id)
        
        let tarefa = TarefaModel.shared.detalhe(id: id)
        
        self._titulo = State(initialValue: tarefa.nome)
        self._descricao = State(initialValue: tarefa.descricao ?? "")
        self._dificuldade = State(initialValue: tarefa.dificuldade)
        self._data_entrega = State(initialValue: tarefa.data_entrega)
    }
    
    var body: some View {
        ZStack{
            //fundo
                Color.corFundo
                    .ignoresSafeArea()
            
            
            VStack (alignment:.leading,spacing : 30){
                //botao de fechar
                HStack{
                    Button{
                        dismiss() // Fecha a sheet
                    }label:{
                        Image(systemName: "chevron.left")
                            .foregroundColor(.corPrimaria)
                            .font(.system(size: 22))
                            .bold()
                    }
                    Spacer()
                }
                
                
                VStack(alignment:.leading, spacing: 30)
                {
                    Text("Editar Tarefa")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.corPrimaria)
                    
                    VStack(alignment:.leading, spacing: 17){
                        
                        //titulo
                        VStack(alignment:.leading, spacing: 10){
                            Text("Tarefa")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.corTextoSecundario)
                            
                            //campo
                            TextField(
                                "",
                                text: $titulo,
                                prompt: Text("NOME DA TAREFA")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.corStroke)
                            )
                            .font(.body)
                            .foregroundStyle(.black)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.corFundo)
                                    .stroke(Color.corStroke, lineWidth: 2)
                            }
                            
                        }
                        
                        //descricao
                        VStack(alignment:.leading, spacing: 10){
                            Text("Descrição (opcional)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.corTextoSecundario)

                            
                            //campo
                            TextField(
                                "",
                                text: $descricao,
                                prompt: Text("DESCRIÇÃO DA TAREFA")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.corStroke)
                            )
                            .font(.body)
                            .foregroundStyle(.black)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.corFundo)
                                    .stroke(Color.corStroke, lineWidth: 2)
                            }
                            
                        }

                        //data
                        VStack(alignment:.leading, spacing: 10){
                            Text("Prazo de entrega")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.corTextoSecundario)

                            
                            //campo

                            
                            HStack {
                                DatePicker("", selection: $data_entrega, in: Date()..., displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .padding(.vertical, 10)
                                    .padding(.leading,15)
                                    .environment(\.locale, Locale(identifier: "pt_BR"))
                                
                                Spacer()
                                
                                /*Image(systemName: "calendar")
                                    .foregroundColor(.corStroke)
                                    .font(.system(size: 20))
                                    .padding(.horizontal,11)*/
                                
                            }.background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.corFundo)
                                    .stroke(Color.corStroke, lineWidth: 2)
                        }
                        
                            
                        }
                        
                        //dificuldade
                        VStack(alignment:.leading, spacing: 10){
                            Text("Dificuldade da tarefa")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.corTextoSecundario)

                            
                            //opcoes
                            //usando componente
                            //CustomNivelSelector(selected: $difi)
                            
                            HStack(spacing: 26){
                                Button{
                                    dificuldade = "1"
                                }label:{
                                    Text("1")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(dificuldade == "1" ? .white : .corStroke)
                                        .padding(.vertical,14)
                                        .padding(.horizontal,20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(dificuldade == "1" ? .corPrimaria : .corFundo)
                                                .stroke(dificuldade == "1" ? .corPrimaria : .corStroke, lineWidth: 2)
                                        }
                                }
                                
                                Button{
                                    dificuldade = "2"
                                }label:{
                                    Text("2")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(dificuldade == "2" ? .white : .corStroke)
                                        .padding(.vertical,14)
                                        .padding(.horizontal,20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(dificuldade == "2" ? .corPrimaria : .corFundo)
                                                .stroke(dificuldade == "2" ? .corPrimaria : .corStroke, lineWidth: 2)
                                        }
                                }
                                
                                Button{
                                    dificuldade = "3"
                                }label:{
                                    Text("3")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(dificuldade == "3" ? .white : .corStroke)
                                        .padding(.vertical,14)
                                        .padding(.horizontal,20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(dificuldade == "3" ? .corPrimaria : .corFundo)
                                                .stroke(dificuldade == "3" ? .corPrimaria : .corStroke, lineWidth: 2)
                                        }
                                }
                                
                                Button{
                                    dificuldade = "4"
                                }label:{
                                    Text("4")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(dificuldade == "4" ? .white : .corStroke)
                                        .padding(.vertical,14)
                                        .padding(.horizontal,20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(dificuldade == "4" ? .corPrimaria : .corFundo)
                                                .stroke(dificuldade == "4" ? .corPrimaria : .corStroke, lineWidth: 2)
                                        }
                                }
                                
                                Button{
                                    dificuldade = "5"
                                }label:{
                                    Text("5")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(dificuldade == "5" ? .white : .corStroke)
                                        .padding(.vertical,14)
                                        .padding(.horizontal,20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(dificuldade == "5" ? .corPrimaria : .corFundo)
                                                .stroke(dificuldade == "5" ? .corPrimaria : .corStroke, lineWidth: 2)
                                        }
                                }
                            }
                            
                            
                            
                        }

                        
                        
                    }
                }
                
                Spacer()
                
            }
                .padding(.horizontal,24)
                .padding(.top,64)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack{
                Spacer()
                if showAlertMessage {
                    Text("Preencha todos os campos obrigatórios!")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.vertical,5)
                }

                
                Button{
                    if titulo.isEmpty {
                        showAlertMessage = true
                    }
                    else{
                        showAlertMessage = false
                        tarefaModel.atualizar_tarefa(id: id, Nome: titulo, Descricao: descricao, Dificuldade: dificuldade, Data_entrega : data_entrega)
                        dismiss()
                    }
                }label:{
                    Text("SALVAR")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 144)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.corPrimaria)
                        )
                }
            }
            .padding(.bottom,64)
            .ignoresSafeArea()

            }
        }
        
    }


/*#Preview {
    TelaEditModalView()
}*/
