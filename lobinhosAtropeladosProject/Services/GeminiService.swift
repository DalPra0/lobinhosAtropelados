import Foundation
import GoogleGenerativeAI

class GeminiService {
    
    private var generativeModel: GenerativeModel
    
    init() {
        let config = GenerationConfig(
            responseMIMEType: "application/json"
        )
        
        self.generativeModel = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: APIKeyManager.geminiKey,
            generationConfig: config
        )
    }
    
    func priorizarTarefas(_ tarefas: [Tarefa]) async throws -> [Tarefa] {
        guard !tarefas.isEmpty else { return [] }
        
        let prompt = """
        Você é um assistente de produtividade especialista em priorização de tarefas complexas, baseando-se em múltiplos fatores.
        Analise a lista de tarefas a seguir, que está em formato JSON.

        REGRAS DE PRIORIZAÇÃO:
        - A prioridade é um número inteiro, onde 1 é a MAIS ALTA (deve ser feita primeiro).
        - Analise os seguintes campos para cada tarefa ativa (`concluida: false`):
          - `nome` e `descricao`: Para entender o contexto e a urgência da tarefa.
          - `duracao_minutos`: Tarefas mais longas podem ter prioridade menor, a menos que sejam muito importantes.
          - `dificuldade`: "Alta", "Média", "Baixa". Tarefas difíceis podem precisar ser feitas antes se estiverem bloqueando outras.
          - `esforco`: "Alto", "Médio", "Baixo". Tarefas de baixo esforço podem ser priorizadas para ganhos rápidos (quick wins).
          - `importancia`: "Alta", "Média", "Baixa". Este é um fator chave. Alta importância geralmente significa alta prioridade.

        ANÁLISE DE PERFIL:
        - Observe as tarefas que já foram concluídas (`concluida: true`) para entender os hábitos do usuário.
        - Se o usuário tende a completar tarefas com alta 'importancia' primeiro, reforce esse padrão na sua priorização. Se ele procrastina em tarefas de alto 'esforco', talvez seja necessário aumentar a prioridade delas para que não sejam esquecidas. Use o histórico para refinar suas decisões.

        TAREFAS ATUAIS:
        \(tarefas.toJsonString())

        Sua tarefa é retornar um objeto JSON contendo um único array chamado "tarefas". Este array deve conter TODAS as tarefas originais que foram enviadas, mas com o campo "prioridade" devidamente preenchido por você para as tarefas que ainda estão ativas. Não adicione nenhum outro texto ou explicação na sua resposta. O formato de cada objeto no array de resposta deve ser idêntico ao formato de entrada.
        """
        
        print("Enviando prompt atualizado para o Gemini...")
        let response = try await generativeModel.generateContent(prompt)
        
        guard let textResponse = response.text,
              let responseData = textResponse.data(using: .utf8) else {
            throw NSError(domain: "GeminiServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do Gemini."])
        }
        
        struct GeminiResponse: Codable {
            let tarefas: [Tarefa]
        }
        
        let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: responseData)
        
        print("Tarefas priorizadas recebidas!")
        return decodedResponse.tarefas
    }
}

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
