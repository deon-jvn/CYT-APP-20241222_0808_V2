import SwiftUI
import AVKit

struct DebtView: View {
    @State private var searchText = ""
    @State private var selectedTopic: DebtTopic?
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                if let topic = selectedTopic {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Back button
                            Button(action: {
                                selectedTopic = nil
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back to Topics")
                                }
                                .foregroundColor(.blue)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Short video section
                            VideoPlayerView(title: "Quick Overview", duration: "30-45 sec", url: topic.shortVideoURL)
                                .frame(height: 200)
                            
                            // Long video section
                            VideoPlayerView(title: "Detailed Explanation", duration: "4-5 min", url: topic.longVideoURL)
                                .frame(height: 200)
                            
                            // Text content section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Written Guide")
                                    .font(.headline)
                                Text(topic.textContent)
                                    .font(.body)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(radius: 2))
                        }
                        .padding()
                    }
                } else {
                    DebtTopicListView(selectedTopic: $selectedTopic)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Debt Management")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct DebtTopic {
    let id: Int
    let title: String
    let shortVideoURL: URL
    let longVideoURL: URL
    let textContent: String
    var websiteURL: URL? = nil  // New property for website links
}

struct DebtTopicListView: View {
    @Binding var selectedTopic: DebtTopic?
    @Environment(\.openURL) private var openURL
    
    let topics = [
        "Understanding Debt Types",
        "Debt Repayment Strategies",
        "Credit Score Management",
        "Debt Consolidation",
        "Avoiding Bad Debt",
        "Check your credit score"  // New item
    ]
    
    var body: some View {
        List(topics, id: \.self) { topic in
            Button(action: {
                if topic == "Check your credit score" {
                    if let url = URL(string: "https://clearscore.co.za") {
                        openURL(url)
                    }
                } else if let videos = VideoPlaceholders.debt[topic] {
                    selectedTopic = DebtTopic(
                        id: topics.firstIndex(of: topic) ?? 0,
                        title: topic,
                        shortVideoURL: videos.short,
                        longVideoURL: videos.long,
                        textContent: "This is placeholder text content for \(topic). Replace this with actual educational content about debt management."
                    )
                }
            }) {
                Text(topic)
            }
        }
    }
}

#Preview {
    DebtView()
} 