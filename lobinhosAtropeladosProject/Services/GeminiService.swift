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
    
    func gerarPlanoDiario(
        tarefasPendentes: [Tarefa],
        tarefasConcluidas: [Tarefa],
        perfilUsuario: User
    ) async throws -> (planoDoDia: [Tarefa], naoPlanejado: [Tarefa]) {
        
        guard !tarefasPendentes.isEmpty else {
            return (planoDoDia: [], naoPlanejado: [])
        }
        

        let prompt = """
        Você é um planejador de produtividade de elite para estudantes universitários. Seu objetivo principal é analisar a lista completa de tarefas de um usuário e selecionar um subconjunto realista e otimizado de tarefas que ele possa completar em um bloco de **5 horas (300 minutos)** hoje.

        INFORMAÇÕES DISPONÍVEIS:
        - **Contexto do Usuário:**
          - Curso: \(perfilUsuario.curso)
          - Período na Faculdade: \(perfilUsuario.periodo)
          - Estilo de Organização Preferido: "\(perfilUsuario.estiloOrganizacao ?? "Não definido")"
        - **Tarefas Pendentes:** A lista de tarefas que precisam ser planejadas.
        - **Histórico de Conclusão:** A lista de tarefas que o usuário já completou.

        SEU PROCESSO DE PENSAMENTO DEVE SEGUIR 3 PASSOS:

        **Passo 1: Avaliação de Urgência e Prioridade.**
        Primeiro, atribua uma prioridade numérica (1 = mais alta) para TODAS as tarefas pendentes. O fator mais crítico é a `data_entrega`. Tarefas para hoje ou amanhã são extremamente urgentes e devem ter prioridade máxima. Use a `dificuldade` e a `importancia` como fatores secundários.

        **Passo 2: Análise de Perfil e Comportamento.**
        Analise o `Histórico de Conclusão`. Se o usuário conclui rapidamente tarefas de 'Cálculo', mesmo que de 'Alta' dificuldade, ele é proficiente nesse tópico. Se ele consistentemente deixa tarefas de 'Leitura' para a última hora, essas tarefas podem precisar de um "empurrão" na prioridade para não serem procrastinadas. Use o histórico para refinar sutilmente a priorização que você fez no Passo 1.

        **Passo 3: Seleção do Plano Diário de 5 Horas.**
        Com a lista final priorizada, monte o "Plano do Dia". Comece a adicionar as tarefas de maior prioridade (começando pela prioridade 1) à sua seleção. Continue adicionando tarefas na ordem de prioridade até que a soma de `duracao_minutos` se aproxime de 300 minutos, **sem ultrapassar este limite**. Use o `estiloOrganizacao` do usuário como critério de desempate: se ele prefere um dia 'tranquilo', pare um pouco antes do limite; se prefere 'foco total', tente encaixar o máximo possível.

        FORMATO DA RESPOSTA:
        Sua resposta DEVE ser um único objeto JSON. Este objeto deve conter DUAS chaves no nível raiz:
        1.  `"planoDoDia"`: um array contendo **apenas** as tarefas que você selecionou para serem feitas hoje.
        2.  `"naoPlanejado"`: um array contendo **todas as outras tarefas pendentes** que não couberam no plano de hoje.
        
        É crucial que TODAS as tarefas pendentes originais estejam em um desses dois arrays, e que TODAS tenham o campo `prioridade` preenchido. Não inclua nenhum texto ou formatação fora do objeto JSON.

        DADOS PARA ANÁLISE:
        - TAREFAS PENDENTES:
        \(tarefasPendentes.toJsonString())
        
        - HISTÓRICO DE CONCLUSÃO:
        \(tarefasConcluidas.toJsonString())
        """
        
        print("Enviando prompt de planejamento para o Gemini...")
        let response = try await generativeModel.generateContent(prompt)
        
        guard let textResponse = response.text,
              let responseData = textResponse.data(using: .utf8) else {
            throw NSError(domain: "GeminiServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do Gemini."])
        }
        
        struct GeminiResponse: Codable {
            let planoDoDia: [Tarefa]
            let naoPlanejado: [Tarefa]
        }
        
        let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: responseData)
        
        print("Plano diário recebido!")
        return (planoDoDia: decodedResponse.planoDoDia, naoPlanejado: decodedResponse.naoPlanejado)
    }
}

extension Array where Element == Tarefa {
    func toJsonString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
}
