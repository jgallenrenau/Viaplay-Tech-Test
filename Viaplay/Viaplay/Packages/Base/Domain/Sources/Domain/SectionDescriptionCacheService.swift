import Foundation

/// Service to manage the cache of section descriptions
@MainActor
public class SectionDescriptionCacheService: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let cacheKey = "section_descriptions_cache"
    private let rootPageKey = "root_page_cache"
    
    @Published public var cachedSections: [String: SectionDescriptionCache] = [:]
    @Published public var rootPageCache: RootPageCache?
    
    public init() {
        loadCachedData()
    }
    
    // MARK: - Public Methods
    
    /// Saves the root page description
    public func cacheRootPage(title: String, description: String?) {
        let rootCache = RootPageCache(title: title, description: description)
        self.rootPageCache = rootCache
        
        do {
            let data = try JSONEncoder().encode(rootCache)
            userDefaults.set(data, forKey: rootPageKey)
            print("✅ [SectionDescriptionCacheService] Root page cached successfully")
        } catch {
            print("❌ [SectionDescriptionCacheService] Failed to cache root page: \(error)")
        }
    }
    
    /// Saves the descriptions of all sections
    public func cacheSections(_ sections: [Section]) {
        var newCache: [String: SectionDescriptionCache] = [:]
        
        for section in sections {
            let cache = SectionDescriptionCache(
                sectionId: section.id,
                title: section.title,
                description: section.description,
                href: section.href?.absoluteString ?? ""
            )
            newCache[section.id] = cache
        }
        
        self.cachedSections = newCache
        
        do {
            let data = try JSONEncoder().encode(newCache)
            userDefaults.set(data, forKey: cacheKey)
            print("✅ [SectionDescriptionCacheService] Cached \(sections.count) sections successfully")
        } catch {
            print("❌ [SectionDescriptionCacheService] Failed to cache sections: \(error)")
        }
    }
    
    /// Gets the description of a specific section
    public func getSectionDescription(for sectionId: String) -> SectionDescriptionCache? {
        return cachedSections[sectionId]
    }
    
    /// Gets the root page description
    public func getRootPageDescription() -> RootPageCache? {
        return rootPageCache
    }
    
    /// Checks if a section is cached
    public func isSectionCached(_ sectionId: String) -> Bool {
        return cachedSections[sectionId] != nil
    }
    
    /// Clears all cache
    public func clearCache() {
        cachedSections.removeAll()
        rootPageCache = nil
        
        userDefaults.removeObject(forKey: cacheKey)
        userDefaults.removeObject(forKey: rootPageKey)
        print("✅ [SectionDescriptionCacheService] Cache cleared successfully")
    }
    
    // MARK: - Private Methods
    
    private func loadCachedData() {
        loadCachedSections()
        loadCachedRootPage()
    }
    
    private func loadCachedSections() {
        do {
            guard let data = userDefaults.data(forKey: cacheKey) else { return }
            let sections = try JSONDecoder().decode([String: SectionDescriptionCache].self, from: data)
            self.cachedSections = sections
            print("✅ [SectionDescriptionCacheService] Loaded \(sections.count) cached sections")
        } catch {
            print("❌ [SectionDescriptionCacheService] Failed to load cached sections: \(error)")
        }
    }
    
    private func loadCachedRootPage() {
        do {
            guard let data = userDefaults.data(forKey: rootPageKey) else { return }
            let rootPage = try JSONDecoder().decode(RootPageCache.self, from: data)
            self.rootPageCache = rootPage
            print("✅ [SectionDescriptionCacheService] Loaded cached root page")
        } catch {
            print("❌ [SectionDescriptionCacheService] Failed to load cached root page: \(error)")
        }
    }
}
