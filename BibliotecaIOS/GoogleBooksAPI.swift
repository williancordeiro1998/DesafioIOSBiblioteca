import Foundation

class GoogleBooksAPI {
    static let shared = GoogleBooksAPI()
    private let apiKey = "AIzaSyCvGmBB-NjC-J0PiaOh3_mJZfmuiNtbHR8"
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    
    private init() {}
    
    func fetchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let urlString = "\(baseURL)?q=\(query)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GoogleBooksResponse.self, from: data)
                let books = response.items.map { item in
                    Book(
                        title: item.volumeInfo.title,
                        author: item.volumeInfo.authors?.first ?? "Unknown",
                        summary: item.volumeInfo.description ?? "No summary available"
                    )
                }
                completion(.success(books))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]
}

struct GoogleBookItem: Codable {
    let volumeInfo: GoogleBookVolumeInfo
}

struct GoogleBookVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
}
