import SwiftUI
import AVKit

struct LibraryView: View {
    @State private var searchText = ""
    @State private var selectedTopic: Topic?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
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
                    // Topic selection view
                    TopicListView(selectedTopic: $selectedTopic)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Financial Library")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search topics...", text: $text)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct VideoPlayerView: View {
    let title: String
    let duration: String
    let url: URL
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(duration)
                .font(.subheadline)
                .foregroundColor(.gray)
            VideoPlayer(player: AVPlayer(url: url))
                .cornerRadius(10)
        }
    }
}

struct Topic {
    let id: Int
    let title: String
    let shortVideoURL: URL
    let longVideoURL: URL
    let textContent: String
}

struct TopicListView: View {
    @Binding var selectedTopic: Topic?
    
    let topics = [
        "Store Cards",
        "Budgeting Basics",
        "Investment 101",
        "Saving Strategies",
        "Understanding Credit",
        "Retirement Planning"
    ]
    
    var body: some View {
        List(topics, id: \.self) { topic in
            Button(action: {
                if let videos = VideoPlaceholders.library[topic] {
                    selectedTopic = Topic(
                        id: topics.firstIndex(of: topic) ?? 0,
                        title: topic,
                        shortVideoURL: videos.short,
                        longVideoURL: videos.long,
                        textContent: "This is placeholder text content for \(topic). Replace this with actual educational content about the topic."
                    )
                }
            }) {
                Text(topic)
            }
        }
    }
}

#Preview {
    LibraryView()
} 