import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared

    @ObservedObject var userModel = UserModel.shared

    @State private var showModal_add = false
    @State private var filtro: String = "Todos"
    @State private var showModal = false
    @State private var showModal_aux = false
    @State private var tarefa_id_edicao : UUID = UUID()
    @State private var id_tarefa_expandida : UUID = UUID()
    @State private var decidir_modo = false
    @State private var expandir = false
    
    
    var cor: Color {
            switch userModel.user.modo_selecionado {
            case 1: return .corModoTranquilo
            case 2: return .corModoModerado
            case 3: return .corModoIntenso
            default: return .gray
            }
        }
    
    var texto: String {
//IMPLEMENTAR ---------------------------------------
            //no momento esta com base no numero, mas no cadastro (aparentemente muda apenas o estilo de organizacao, em string)
            //ou mudar aqui com base nos textos das opcoes
            switch userModel.user.modo_selecionado {
            case 1: return "tranquilo"
            case 2: return "moderado"
            case 3: return "intenso"
            default: return "a escolher"
            }
        }

    private var tarefasFiltradas: [Tarefa] {
        if filtro == "Todos" {
            return tarefaModel.tarefas.filter { !$0.concluida }
        }
        
        if filtro == "Concluídas" {
            return tarefaModel.tarefas.filter { $0.concluida }
        }
        
        if filtro == "Para hoje" {
//IMPLEMENTAR ---------------------------------------
            return tarefaModel.tarefas.filter { $0.concluida }
        }
        
        return tarefaModel.tarefas
    }
        
        
    
    //tela
    
    var body: some View {
        ZStack {
            //fundo
            Color.corFundo
                .ignoresSafeArea()
            
            VStack(alignment:.leading, spacing :32){
                
            }
            .padding(.horizontal, 24)
            .padding(.horizontal, 32)
            
            //botao flutuante
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button{
                        showModal_add = true
                    }
                    label:{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.corPrimaria)
                            .font(.system(size: 45))

                    }
                    .padding(.horizontal,16)
                    .padding(.vertical,20)
                }
            }
            
            
            //painel com perfil/nome etc
            VStack(alignment:.leading, spacing:32){
                HStack(spacing:8){
                    //texto
                    VStack(alignment:.leading, spacing:5){
                        Text("Olá \(userModel.user.nome),")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.corTextoSecundario)
                        Text("Seu dia será \(texto)!")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(cor)
                        
                        Button{
//IMPLEMENTAR ---------------------------------------

                            //acao de alterar modo
                        }label:{
                            Text("Clique aqui para alterar")
                                .font(.system(size: 13))
                                .fontWeight(.regular)
                                .foregroundColor(.corTextoTerciario)
                        }
                        
                    }
                    
                    Spacer()
                    
                    //perfil
                    VStack{
                        Button{
//IMPLEMENTAR ---------------------------------------
                            //ir para perfil
                        }label:{
                            Image(systemName: "person")
                                .foregroundColor(.corPrimaria)
                                .font(.system(size: 30))
                                .bold()
                            
                        }
                    }
                }
                
                VStack(alignment:.leading, spacing:24){
                    Text("Minhas tarefas")
                        .bold()
                        .font(.system(size: 25))
                    
                    //filtros
                    HStack(spacing:8){
                        BotaoFiltro(titulo: "Para hoje", filtroSelecionado: $filtro)
                        BotaoFiltro(titulo: "Concluídas", filtroSelecionado: $filtro)
                        BotaoFiltro(titulo: "Todas", filtroSelecionado: $filtro)
                    }
                    
//IMPLEMENTAR ---------------------------------------

                    //lista
                    List{

                        
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    Spacer()

                    
                }
                
                
                Spacer()
                
            }.padding(.horizontal,24)
                .padding(.vertical,64)
                .ignoresSafeArea()
            

            
            //carregando
            if tarefaModel.estaPriorizando {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Priorizando tarefas...")
                        .padding(.top, 8)
                }
                .padding(20)
                .background(.thinMaterial)
                .cornerRadius(10)
            }
        }
        
        //sem < back
        .navigationBarHidden(true)
        //se clica no botao -> sheet de add
        .sheet(isPresented: $showModal_add) {
            TarefaAddModalView()
                .presentationDetents([.large])
        }
        //se clica no editar -> modal de edicao
        .sheet(isPresented: $showModal) {
            TelaEditModalView(id:tarefa_id_edicao)
                .presentationDetents([.large])
        }
        //variavel auxiliar pra abrir modal de edicao -> correcao de bug------------------------------------------------
        .onChange(of: showModal_aux) {
            if showModal_aux {
                showModal = true
            }
        }
        .onChange(of: showModal) {
            if showModal {
                showModal_aux = false
            }
        }
        //------------------------------------------------
    }
    
    
    
    
    
    
    
    @ViewBuilder
    private func celulaDaTarefa(tarefa: Tarefa) -> some View {
        HStack(spacing: 15) {
            Button(action: {
                tarefaModel.marcarTarefa(tarefa: tarefa)
                //para fechar automatico quando expandida
                if(id_tarefa_expandida == tarefa.id && expandir){
                    expandir=false
                }
            }) {
                Image(systemName: tarefa.concluida ? "checkmark.circle.fill" : "circle")
                    .font(.title2).foregroundColor(tarefa.concluida ? .green : .secondary)
            }.buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 5) {
                Text(tarefa.nome).font(.headline).strikethrough(tarefa.concluida, color: .primary)
                if let descricao = tarefa.descricao, !descricao.isEmpty {
                    Text(descricao).font(.subheadline).lineLimit(2).foregroundColor(.secondary)
                }
                if(id_tarefa_expandida != tarefa.id || expandir == false){
                    HStack {
                        HStack(spacing: 4) { Image(systemName: "hourglass"); Text("\(tarefa.data_entrega) min") }
                        Spacer()
                        HStack(spacing: 4) { Image(systemName: "bolt.fill"); Text(tarefa.dificuldade) }
                        
                    }.font(.caption).foregroundColor(.secondary).padding(.top, 4)
                }
                
                /*if (id_tarefa_expandida == tarefa.id && expandir == true){
                    Text("Dificuldade : \(tarefa.dificuldade)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                    Text("Esforço : \(tarefa.esforco)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                    Text("Importância : \(tarefa.importancia)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                    let tempo = String(format: "%dh %02dmin", tarefa.duracao_minutos / 60, tarefa.duracao_minutos % 60)
                    Text("Duração : \(tempo)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                }*/
            }
            Spacer()
        }.padding(.vertical, 5).opacity(tarefa.concluida ? 0.6 : 1.0)
        .swipeActions {
            Button(){
                tarefaModel.deletar_tarefa(id: tarefa.id)
            } label: {
                Label("Excluir", systemImage: "trash")
            }
            .tint(.red)
            
            Button(){
                tarefa_id_edicao = tarefa.id
                showModal_aux = true
            } label: {
                Label("Editar", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .onTapGesture {
            id_tarefa_expandida=tarefa.id
            expandir.toggle()
        }
    }
}


struct BotaoFiltro: View {
    let titulo: String
    @Binding var filtroSelecionado: String
    
    var isSelected: Bool {
        titulo == filtroSelecionado
    }
    
    var body: some View {
        Button(action: {
            filtroSelecionado = titulo
        }) {
            HStack{
                Spacer()
                Text(titulo)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .corPrimaria)
                Spacer()
                    
            }
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 12.0).fill(isSelected ? Color.corPrimaria : Color.clear)

                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12.0).stroke(Color.corPrimaria, lineWidth: 1.0)
                )
        }
    }
}

#Preview {
    TelaInicialView()
}
