//
//  Model.swift
//  News
//
//  Created by Vladimir Stepanchikov on 05.04.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Foundation

var strURL = "https://newsapi.org/v2/top-headlines?apiKey=7fcc4d7bbf8d4392b3e3a70d4d742108"

var urlToJson: URL {
    let pathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/data.json"
    return URL(fileURLWithPath: pathString)
}

var news: [OneNews] = []

var nDownloadCompleted = Notification.Name("nDownloadCompleted")
var nDownloadWithError = Notification.Name("nDownloadWithError")

func loadNews(with queryString: String) {
    downloadJSON(query: queryString) { (error) in
        if error != nil {
            NotificationCenter.default.post(name: nDownloadWithError, object: nil, userInfo: ["error": error ?? ""])
            return
        }
        
        let returnValue = parseJSON()
        
        if returnValue.error != nil {
            NotificationCenter.default.post(name: nDownloadWithError, object: nil, userInfo: ["error": error ?? ""])
            return
        }
        
        news = returnValue.news
        NotificationCenter.default.post(name: nDownloadCompleted, object: nil)
    }
}

func downloadJSON(query: String, completionHandler: ((_ error: String?) -> Void)?) {
    let session = URLSession(configuration: .default)
    let urlStrWithQuery = strURL + "&q=" + (query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")
    
    guard let url = URL(string: urlStrWithQuery) else {
        completionHandler?("Строка не преобразуется к URL: \(urlStrWithQuery)")
        return
    }
    
    let task = session.downloadTask(with: url) { (urlFile, response, error) in
        if error != nil {
            completionHandler?("Ошибка при загрузки json: \(error!.localizedDescription)")
            return
        }
        
        guard let urlFile = urlFile else {
            completionHandler?("Ошибка при загрузки json: ничего не загрузили urlFile = nil")
            return
        }
        
        do {
            if try FileManager.default.replaceItemAt(urlToJson, withItemAt: urlFile) != nil {
                completionHandler?(nil)
            } else {
                completionHandler?("Не удалось скопировать файл json, replaceItemAt вернул nil")
            }
        } catch {
            completionHandler?("Не удалось скопировать файл json. Ошибка: \(error.localizedDescription)")
        }
    }
    
    task.resume()
}

func parseJSON() -> (news: [OneNews], error: String?) {
    guard let data = try? Data(contentsOf: urlToJson) else {
        return ([], "Не могу получить Data из сохранённого файла")
    }
    
    guard let mainDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> else {
        return ([], "Не могу преобразовать json к типу Dictionary<String, Any>")
    }
    
    if mainDictionary["status"] as? String != "ok" {
        return ([], "Статус не равен ОК. \(mainDictionary["message"] as? String ?? "не могу определить код ошибки, отсутствует элемент message")")
    }
    
    guard let array = mainDictionary["articles"] as? [Dictionary<String, Any>] else {
        return ([], "Не могу обратиться к элементу articles")
    }
    
    var returnArray: [OneNews] = []
    for dictItem in array {
        returnArray.append(OneNews(dictionaryOneNews: dictItem))
    }
    
    return(returnArray, nil)
}
