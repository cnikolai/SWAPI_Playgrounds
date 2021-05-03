import UIKit

struct Person: Decodable {
    let name: String
    let films: [String]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else { return }
        let peopleURL = baseURL.appendingPathComponent("people/")
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print("finalURL", finalURL)
        
        // Step 2: Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in

            // Step 3: Error Handling
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            // Step 4: Check for data
            guard let data = data else { return completion(nil)}

            // Step 5: Decode the data
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                print(person)
                return completion(person)
            } catch {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: String, completion: @escaping (Film?) -> Void) {
        guard let finalURL =  URL(string: url) else { return completion(nil)}
        print("finalURL", finalURL)
        
        // Step 2: Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in

            // Step 3: Error Handling
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            // Step 4: Check for data
            guard let data = data else { return completion(nil)}

            // Step 5: Decode the data
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                print(film)
                return completion(film)
            } catch {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: String) {
        SwapiService.fetchFilm(url: url, completion: { film in
            if let film = film {
                print(film)
            }
        })
    }
}//end of class

SwapiService.fetchPerson(id: 10) { person in
  if let person = person {
       print(person)
    for film in person.films {
        SwapiService.fetchFilm(url: film)
    }
  }
}

