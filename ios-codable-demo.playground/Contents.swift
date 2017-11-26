//: Playground - noun: a place where people can play

import UIKit

// MARK: - Decode

// MARK: plist
struct Person: Codable {
    let name: String
    let age: Int
}

extension Person {

    static func createPerson() -> Person {
        guard
            let url = Bundle.main.url(forResource: "person", withExtension: "plist"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = PropertyListDecoder()
        do {
            let person = try decoder.decode(Person.self, from: data)
            return person
        } catch {
            print("plist decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let person = Person.createPerson()
print(person)

// MARK: plist（配列）
struct Prefecture: Codable {
    let code: String
    let name: String
}

extension Prefecture {

    static func createPrefectures() -> [Prefecture] {
        guard
            let url = Bundle.main.url(forResource: "prefectures", withExtension: "plist"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = PropertyListDecoder()
        do {
            let prefectures = try decoder.decode([Prefecture].self, from: data)
            return prefectures
        } catch {
            print("plist decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let prefectures = Prefecture.createPrefectures()
prefectures.forEach { print($0) }

// MARK: json
struct Child: Codable {
    let name: String
    let age: Double
    let parents: Parents

    // ネストも可能
    struct Parents: Codable {
        let father: String
        let mother: String
    }
}

extension Child {

    static func createChild() -> Child {
        guard
            let url = Bundle.main.url(forResource: "child", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = JSONDecoder()
        do {
            let child = try decoder.decode(Child.self, from: data)
            return child
        } catch {
            print("json decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let child = Child.createChild()
print(child)

// MARK: json（配列）
struct City: Codable {
    let cityCode: Int
    let name: String
    let url: URL


    /// キーとプロパティ名が一致しない場合はCodingKeyを利用する
    /// - case名: プロパティ名
    /// - rawValue: キー名
    ///
    /// - cityCode: プロパティ: キャメルケース, キー: スネークケース
    /// - name: 一致しているのでrawValueの定義不要
    /// - url: 一致しているのでrawValueの定義不要
    private enum CodingKeys: String, CodingKey {
        case cityCode = "city_code"
        case name
        case url
    }
}

extension City {

    static func creatCities() -> [City] {
        guard
            let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                fatalError("unwrap failed")
        }

        let decoder = JSONDecoder()
        do {
            let cities = try decoder.decode([City].self, from: data)
            return cities
        } catch {
            print("json decode failed", error.localizedDescription)
            fatalError()
        }
    }
}

let cities = City.creatCities()
cities.forEach { print($0) }

// MARK: - Encode

// MARK: plist
let encodePerson = Person(name: "名前", age: 20)
let personData = try? PropertyListEncoder().encode(encodePerson)
let decodePerson = try? PropertyListDecoder().decode(Person.self, from: personData!)
print(decodePerson!)

// MARK: json
let parents = Child.Parents(father: "父", mother: "母")
let encodeChild = Child(name: "こども", age: 1.2, parents: parents)
let jsonData = try? JSONEncoder().encode(encodeChild)
let decodeChild = try? JSONDecoder().decode(Child.self, from: jsonData!)
print(decodeChild!)
