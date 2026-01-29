/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import Foundation

struct JWTRequest: Encodable {
    let consumer_id: String
    let kid: String
    let iss: String
    let aud: String
    let scope: String
}

struct JWTResponse: Decodable {
    let jwt: String
}


/// Fetches the JWT authentication token.
/// - Parameter completion: Callback.
func fetchSandboxJWT(completion: @escaping (Result<String, Error>) -> Void) {

    let url = URL(string:
                    D1Configuration.SANDBOX_JWT_URL
    )!

    let body = JWTRequest(
        consumer_id: D1Configuration.CONSUMER_ID,
        kid: D1Configuration.KID,
        iss: D1Configuration.ISS,
        aud: D1Configuration.AUD,
        scope: D1Configuration.SCOPE
    )

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setBasicAuth(username: D1Configuration.SANDBOX_JWT_USER,
                         password: D1Configuration.SANDBOX_JWT_PASSWORD)
    request.httpBody = try? JSONEncoder().encode(body)

    URLSession.shared.dataTask(with: request) { data, response, error in

        if let error = error {
            completion(.failure(error))
            return
        }

        guard let http = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "InvalidResponse", code: -1)))
            return
        }

        guard (200...299).contains(http.statusCode),
              let data = data else {
            completion(.failure(NSError(domain: "HTTP \(http.statusCode)", code: http.statusCode)))
            return
        }

        do {
            let decoded = try JSONDecoder().decode(JWTResponse.self, from: data)
            completion(.success(decoded.jwt))
        } catch {
            completion(.failure(error))
        }

    }.resume()
}

