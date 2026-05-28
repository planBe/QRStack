import Combine
import Foundation

/// Persists the recently-encoded text inputs across launches via UserDefaults.
/// Capped at `maxItems`; most-recent-first; deduplicates on add (moving an
/// existing entry to the top rather than inserting a duplicate).
final class HistoryStore: ObservableObject {
    @Published private(set) var items: [String] = []

    private let key = "QRStack.history.v1"
    private let maxItems = 10

    init() {
        load()
    }

    /// Records `text` as the most-recent item. No-op for empty strings.
    /// If `text` already exists, it's moved to the top (not duplicated).
    func add(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.removeAll(where: { $0 == trimmed })
        items.insert(trimmed, at: 0)
        if items.count > maxItems { items = Array(items.prefix(maxItems)) }
        save()
    }

    func clear() {
        items = []
        save()
    }

    private func load() {
        if let stored = UserDefaults.standard.array(forKey: key) as? [String] {
            items = stored
        }
    }

    private func save() {
        UserDefaults.standard.set(items, forKey: key)
    }
}
