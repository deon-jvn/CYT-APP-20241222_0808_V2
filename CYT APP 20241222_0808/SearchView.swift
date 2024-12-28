import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Ask anything about finance...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            Task {
                                await viewModel.performSearch(query: searchText)
                            }
                        }
                }
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            if let response = viewModel.searchResponse {
                                Text(response)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemBackground))
                                        .shadow(radius: 2))
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Financial Assistant")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

class SearchViewModel: ObservableObject {
    @Published var searchResponse: String?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let apiKey = "xai-raTbfqFhFaym6N7SuvrEfPfC7BoNveZRlevJnuyKdWLjG8BixSyg76sTLVLPFJ6EJ4x0J2GgGMt7lKb5"
    private let baseURL = "https://api.x.ai/v1"
    
    func performSearch(query: String) async {
        guard !query.isEmpty else { return }
        
        await MainActor.run {
            isLoading = true
            searchResponse = nil
        }
        
        do {
            let url = URL(string: baseURL)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "messages": [
                    [
                        "role": "system",
                        "content": "You are a helpful financial assistant. Provide clear, concise answers about financial topics."
                    ],
                    [
                        "role": "user",
                        "content": query
                    ]
                ],
                "model": "grok-beta",
                "temperature": 0.7,
                "max_tokens": 500
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"])
                }
            }
            
            let decodedResponse = try JSONDecoder().decode(GrokResponse.self, from: data)
            
            await MainActor.run {
                searchResponse = decodedResponse.choices.first?.message.content
                isLoading = false
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Error: \(error.localizedDescription)"
                showError = true
                isLoading = false
            }
        }
    }
}

struct GrokResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
}

#Preview {
    SearchView()
} 
