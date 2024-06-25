import SwiftUI
import Combine

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    @State private var searchQuery = ""
    @State private var searchResults: [Book] = []
    @State private var isSearching = false
    @State private var showSearchResults = false
    
    var body: some View {
        VStack {
            if showSearchResults {
                List(searchResults, id: \.id) { result in
                    Button(action: {
                        self.title = result.title
                        self.author = result.author
                        self.showSearchResults = false
                        print("Selected book: \(result.title) by \(result.author)")
                    }) {
                        Text("\(result.title) by \(result.author)")
                    }
                }
            } else {
                HStack {
                    TextField("Buscar livro", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Buscar") {
                        searchBooks()
                    }
                    .disabled(searchQuery.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                HStack {
                    Text("Status")
                    Picker("Status", selection: $status) {
                        ForEach(Status.allCases) { status in
                            Text(status.descr).tag(status)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                VStack(alignment: .leading) {
                    GroupBox {
                        HStack {
                            Text("Data de Adição")
                                .foregroundStyle(.secondary)
                            Spacer()
                            DatePicker("", selection: $dateAdded, displayedComponents: .date)
                        }
                        
                        if status == .inProgress || status == .completed {
                            HStack {
                                Text("Data de Início")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                            }
                        }
                        if status == .completed {
                            HStack {
                                Text("Data de Conclusão")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                            }
                        }
                    }
                    .foregroundStyle(.secondary)
                    .onChange(of: status) { oldValue, newValue in
                        if !firstView {
                            if newValue == .onShelf {
                                dateStarted = Date.distantPast
                                dateCompleted = Date.distantPast
                            } else if newValue == .inProgress && oldValue == .completed {
                                dateCompleted = Date.distantPast
                            } else if newValue == .inProgress && oldValue == .onShelf {
                                dateStarted = Date.now
                            } else if newValue == .completed && oldValue == .onShelf {
                                dateCompleted = Date.now
                                dateStarted = dateAdded
                            } else {
                                dateCompleted = Date.now
                            }
                            firstView = false
                        }
                    }
                    Divider()
                    HStack {
                        Text("Classificar")
                            .foregroundStyle(.secondary)
                        Spacer()
                        RatingsView(maxRating: 5, currentRating: $rating, width: 30)
                    }
                    HStack {
                        Text("Título")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Autor")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("", text: $author)
                            .textFieldStyle(.roundedBorder)
                    }
                    Divider()
                    Text("Sumário")
                        .foregroundStyle(.secondary)
                    TextEditor(text: $summary)
                        .padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
                }
                .padding()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if changed {
                        Button("Atualizar") {
                            book.status = status
                            book.rating = rating
                            book.title = title
                            book.author = author
                            book.summary = summary
                            book.dateAdded = dateAdded
                            book.dateStarted = dateStarted
                            book.dateCompleted = dateCompleted
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .onAppear {
                    status = book.status
                    rating = book.rating
                    title = book.title
                    author = book.author
                    summary = book.summary
                    dateAdded = book.dateAdded
                    dateStarted = book.dateStarted
                    dateCompleted = book.dateCompleted
                }
            }
        }
    }
    
    var changed: Bool {
        status != book.status
        || rating != book.rating
        || title != book.title
        || author != book.author
        || summary != book.summary
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
    }
    
    func searchBooks() {
        isSearching = true
        GoogleBooksAPI.shared.fetchBooks(query: searchQuery) { result in
            isSearching = false
            switch result {
            case .success(let books):
                print("Books fetched: \(books)")
                searchResults = books
                showSearchResults = true
            case .failure(let error):
                print("Failed to fetch books: \(error)")
            }
        }
    }
}
