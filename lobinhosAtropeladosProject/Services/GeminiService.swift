import Foundation
import GoogleGenerativeAI

class GeminiService {
    
    private var generativeModel: GenerativeModel
    
    init() {
        let config = GenerationConfig(
            // Garante que a resposta da IA será sempre em formato JSON
            responseMIMEType: "application/json"
        )
        
        self.generativeModel = GenerativeModel(
            // Usando o modelo mais recente e eficiente
            name: "gemini-1.5-flash",
            apiKey: APIKeyManager.geminiKey,
            generationConfig: config
        )
    }
    
    // Esta é a função principal que chama a IA.
    // Ela foi atualizada para receber o ritmo e o tempo disponível.
    func priorizarTarefas(_ tarefas: [Tarefa], comRitmo ritmo: RitmoDiario, tempoDisponivel: Int) async throws -> [Tarefa] {
        // Se não houver tarefas, não há nada a fazer.
        guard !tarefas.isEmpty else { return [] }
        
        // Cria uma parte dinâmica do prompt com base na escolha do usuário.
        let contextoRitmo: String
        switch ritmo {
        case .tranquilo:
            contextoRitmo = "CONTEXTO DO DIA: O usuário escolheu um dia 'Tranquilo' com \(tempoDisponivel) minutos disponíveis. Priorize um número menor de tarefas, focando em atividades de baixo esforço para manter a produtividade sem sobrecarga."
        case .moderado:
            contextoRitmo = "CONTEXTO DO DIA: O usuário escolheu um dia 'Moderado' com \(tempoDisponivel) minutos disponíveis. Busque um bom equilíbrio entre tarefas importantes e esforço, criando um dia produtivo mas sustentável."
        case .intenso:
            contextoRitmo = "CONTEXTO DO DIA: O usuário escolheu um dia 'Intenso' com \(tempoDisponivel) minutos disponíveis. Seja mais agressivo na priorização para maximizar a produtividade e encaixar o máximo de tarefas de alta importância possível."
        case .nenhum:
            contextoRitmo = "CONTEXTO DO DIA: Nenhum ritmo ou tempo foi definido. Faça a priorização padrão com base apenas nos atributos das tarefas."
        }
        
        // Monta o prompt final que será enviado para a IA.
        let prompt = """
        Você é um assistente de produtividade especialista em priorização de tarefas.
        
        \(contextoRitmo)

        REGRAS DE PRIORIZAÇÃO:
        - Sua principal tarefa é retornar a lista COMPLETA de tarefas, com o campo "prioridade" (um número inteiro, 1 = mais alta) preenchido para as tarefas ativas (`concluida: false`).
        - Use o tempo disponível e o ritmo como os fatores MAIS IMPORTANTES para definir a ordem das prioridades.
        - Use os outros campos (`nome`, `duracao_minutos`, `dificuldade`, `esforco`, `importancia`) e o histórico de tarefas concluídas (`concluida: true`) para refinar suas decisões.

        TAREFAS ATUAIS:
        \(tarefas.toJsonString())

        Sua resposta deve ser um objeto JSON contendo um único array chamado "tarefas", com TODAS as tarefas originais e suas novas prioridades. Não adicione nenhum outro texto ou explicação.
        """
        
        print("Enviando prompt com ritmo e tempo para o Gemini...")
        let response = try await generativeModel.generateContent(prompt)
        
        // Processa a resposta JSON da IA.
        guard let textResponse = response.text,
              let responseData = textResponse.data(using: .utf8) else {
            throw NSError(domain: "GeminiServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do Gemini."])
        }
        
        // Uma struct temporária para decodificar a resposta esperada.
        struct GeminiResponse: Codable {
            let tarefas: [Tarefa]
        }
        
        let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: responseData)
        
        print("Tarefas priorizadas recebidas!")
        return decodedResponse.tarefas
    }
}

// Uma pequena função auxiliar para converter o array de tarefas em uma string JSON.
extension Array where Element == Tarefa {
    func toJsonString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
}
