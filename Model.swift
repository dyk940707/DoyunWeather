//
//  Model.swift
//  DoyunWeather
//
//  Created by Doyun on 09/07/2019.
//  Copyright © 2019 Doyun. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherSummary: Codable {
    struct Weather: Codable {
        struct minutely: Codable {
            struct Sky: Codable {
                let code: String
                let name: String
            }
            struct Temperature: Codable {
                let tc: String
                let tmax: String
                let tmin: String
                
            }
            let sky: Sky
            let temperature: Temperature
        }
        let minutely: [minutely]
    }
    struct Result: Codable {
        let code: Int
        let message: String
        
    }
    
    let weather: Weather
    let result: Result
}
struct ForecastData {
    let date: Date
    let skyCode: String
    let skyName: String
    let temperature: Double
}


struct Forecast: Codable {
    struct Weather: Codable {
        struct Forecast3Days: Codable {
            struct Fcst3Hour: Codable {
                @objcMembers class Sky: NSObject, Codable {
                    let code4hour: String
                    let name4hour: String
                    let code7hour: String
                    let name7hour: String
                    let code10hour: String
                    let name10hour: String
                    let name13hour: String
                    let code13hour: String
                    let name16hour: String
                    let code16hour: String
                    let name19hour: String
                    let code19hour: String
                    let name22hour: String
                    let code22hour: String
                    let name25hour: String
                    let code25hour: String
                    let name28hour: String
                    let code28hour: String
                    let name31hour: String
                    let code31hour: String
                    let name34hour: String
                    let code34hour: String
                    let name37hour: String
                    let code37hour: String
                    let name40hour: String
                    let code40hour: String
                    let name43hour: String
                    let code43hour: String
                    let name46hour: String
                    let code46hour: String
                    let name49hour: String
                    let code49hour: String
                    let name52hour: String
                    let code52hour: String
                    let name55hour: String
                    let code55hour: String
                    let name58hour: String
                    let code58hour: String
                    let name61hour: String
                    let code61hour: String
                    let name64hour: String
                    let code64hour: String
                    let name67hour: String
                    let code67hour: String
                    
                }
                @objcMembers class Temperature: NSObject, Codable {
                    let temp4hour: String
                    let temp7hour: String
                    let temp10hour: String
                    let temp13hour: String
                    let temp16hour: String
                    let temp19hour: String
                    let temp22hour: String
                    let temp25hour: String
                    let temp28hour: String
                    let temp31hour: String
                    let temp34hour: String
                    let temp37hour: String
                    let temp40hour: String
                    let temp43hour: String
                    let temp46hour: String
                    let temp49hour: String
                    let temp52hour: String
                    let temp55hour: String
                    let temp58hour: String
                    let temp61hour: String
                    let temp64hour: String
                    let temp67hour: String
                }
                let sky: Sky
                let temperature: Temperature
                
                func arrayRepresentation() -> [ForecastData] {
                    var data = [ForecastData]()
                    let now = Date()
                    
                    for hour in stride(from: 4, to: 67, by: 3) {
                        var key = "code\(hour)hour" // 스카이 코드 키 구상후 변수에 저장
                        //value forKey 메소드를 이용해 값을 읽어온 후에 문자열로 캐스팅
                        guard let skyCode = sky.value(forKey: key) as? String else {
                            continue
                        }
                        key = "name\(hour)hour"
                        guard let skyName = sky.value(forKey: key) as? String else {
                            continue
                        }
                        
                        key = "temp\(hour)hour"
                        let tempStr = temperature.value(forKey: key) as? String ?? "0.0"
                        guard let temp = Double(tempStr) else { continue }
                        
                        // 현재날짜에서 반복상수에 저장된 시간을 더한 다음에 새로운 날짜를 생성
                        let date = now.addingTimeInterval(TimeInterval(hour) * 60 * 60)
                        
                        // 앞에서 만든값을 활용해서 새로운 forecast 인스턴스 생성
                        
                        let forecast = ForecastData(date: date, skyCode: skyCode, skyName: skyName, temperature: temp)
                        // 새롭게 생성하는 인스턴스를 배열에 저장
                        data.append(forecast)
                    }
                    return data // 배열을 리턴
                }
            }
            
            
            let fcst3hour: Fcst3Hour
        }
        
        let forecast3days: [Forecast3Days]
    }
    
    struct Result: Codable {
        let code: Int
        let message: String
    }
    
    let weather: Weather
    let result: Result
}

class WeatherDataSource {
    static let shared = WeatherDataSource()
    
    private init() {}
    
    var summary: WeatherSummary? // 현재날씨 데이터 저장
    var forecastList = [ForecastData]() //예보 데이터를 배열로 저장
    
    let group = DispatchGroup()
    let workQueue = DispatchQueue(label: "apiQueue", attributes: .concurrent)
    
    func fetch(location: CLLocation, completion: @escaping () -> ()) {
        group.enter()
        workQueue.async {
            self.fetchSummary(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completion: {
                self.group.leave()
            })
        }
        
        group.enter()
        workQueue.async {
            self.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude, completion: {
                self.group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    //현재날씨를 가져와서 파싱하는 메소드
    //파라미터로 두 좌표 전달
    //완료후에 실행할 코드
    
    
    func fetchSummary(lat: Double, lon: Double, completion: @escaping () -> ()) {
        //컴플리션으로 전달된 클로저를 호출

        
        let apiUrl = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"
       
        
        let url = URL(string: apiUrl)!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print(httpResponse.statusCode)
                return
            }
            guard let data = data else {
                fatalError("Invalid Data")
            }
            
            do {
                let decoder = JSONDecoder()
                self.summary = try decoder.decode(WeatherSummary.self, from: data)
                
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    func fetchForecast(lat: Double, lon: Double, completion: @escaping () -> ()) {
        
        let apiUrl = "https://api2.sktelecom.com/weather/forecast/3days?version=1&lat=\(lat)&lon=\(lon)&appKey=\(appKey)"
  
        
        let url = URL(string: apiUrl)!
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    completion()
                }
            }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print(httpResponse.statusCode)
                return
            }
            guard let data = data else {
                fatalError("Invalid Data")
            }
            
            do {
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(Forecast.self, from: data)
                // 구현된 리스트를 forecast 배열에 저장
                if let list = forecast.weather.forecast3days.first?.fcst3hour.arrayRepresentation() {
                    self.forecastList = list
                }
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
}
