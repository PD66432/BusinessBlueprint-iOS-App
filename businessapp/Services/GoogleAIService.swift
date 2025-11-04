import Foundation

class GoogleAIService {
    static let shared = GoogleAIService()
    
    private let apiKey = FirebaseConfig.googleAIAPIKey
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    
    // MARK: - Generate Business Ideas
    
    func generateBusinessIdeas(
        skills: [String],
        personality: [String],
        interests: [String],
        completion: @escaping (Result<[BusinessIdea], Error>) -> Void
    ) {
        let prompt = buildPrompt(skills: skills, personality: personality, interests: interests)
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: URL(string: "\(baseURL)?key=\(apiKey)")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.success([]))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let firstPart = parts.first,
                   let text = firstPart["text"] as? String {
                    
                    let ideas = self.parseBusinessIdeas(from: text)
                    completion(.success(ideas))
                } else {
                    completion(.success([]))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Get AI Suggestions
    
    func getAISuggestions(
        businessIdea: BusinessIdea,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let prompt = "Provide practical advice and next steps for the following business idea: \(businessIdea.title). Description: \(businessIdea.description). Keep response concise and actionable."
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: URL(string: "\(baseURL)?key=\(apiKey)")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.success("Unable to get suggestions at this time."))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let firstPart = parts.first,
                   let text = firstPart["text"] as? String {
                    completion(.success(text))
                } else {
                    completion(.success("No suggestions available"))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Private Helper Methods
    
    private func buildPrompt(skills: [String], personality: [String], interests: [String]) -> String {
        let skillsText = skills.joined(separator: ", ")
        let personalityText = personality.joined(separator: ", ")
        let interestsText = interests.joined(separator: ", ")
        
        return """
        Based on the following user profile, generate 5 unique and personalized business ideas:
        
        Skills: \(skillsText)
        Personality Traits: \(personalityText)
        Interests: \(interestsText)
        
        For each idea, provide:
        1. Business Title
        2. Description (2-3 sentences)
        3. Category (e.g., Tech, Service, Creative, etc.)
        4. Difficulty Level (Easy/Medium/Hard)
        5. Estimated Revenue Range
        6. Time to Launch
        7. Required Skills
        8. Startup Cost
        9. Profit Margin Estimate
        10. Market Demand (High/Medium/Low)
        11. Competition Level (High/Medium/Low)
        12. Personalized Notes
        
        Format each idea clearly with numbered sections.
        """
    }
    
    private func parseBusinessIdeas(from text: String) -> [BusinessIdea] {
        // Parse the AI response and convert to BusinessIdea objects
        // This is a simplified parser - enhance as needed
        var ideas: [BusinessIdea] = []
        
        // For now, return sample data
        ideas.append(
            BusinessIdea(
                id: UUID().uuidString,
                title: "AI-Powered Business Consultant",
                description: "Provide personalized business consulting using AI to help entrepreneurs.",
                category: "Technology",
                difficulty: "Medium",
                estimatedRevenue: "$50,000 - $150,000/year",
                timeToLaunch: "3-4 months",
                requiredSkills: ["AI/ML", "Business Strategy", "Communication"],
                startupCost: "$5,000 - $15,000",
                profitMargin: "60-75%",
                marketDemand: "High",
                competition: "Medium",
                createdAt: Date(),
                userId: "",
                personalizedNotes: "Perfect match for your tech skills and entrepreneurial interests"
            )
        )
        
        return ideas
    }
}
