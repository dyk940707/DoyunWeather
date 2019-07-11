//
//  ViewController.swift
//  DoyunWeather
//
//  Created by Doyun on 09/07/2019.
//  Copyright © 2019 Doyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tempFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ko_kr")
        
        return formatter
    }()
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherDataSource.shared.fetchSummary(lat: 37.498206, lon: 127.02761) {
            [weak self] in
            self?.listTableView.reloadData() //파싱이 완료되면 테이블 뷰를 리로딩
        
        WeatherDataSource.shared.fetchForecast(lat: 37.498206, lon:127.02761) {
            [weak self] in
            self?.listTableView.reloadData()
        }
    }

}
    
}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 테이블뷰에 2개의 섹션 표시
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:  //현재날씨 하나만 표시
            return 1
        case 1: //예보의 숫자만큼 리턴해야함.
            return WeatherDataSource.shared.forecastList.count
        default:
            return 0
        }
    }
    //셀을 리턴하는 코드
    //summary 셀 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as! SummaryTableViewCell
            
            if let data = WeatherDataSource.shared.summary?.weather.minutely.first {
                cell.weatherImageView.image = UIImage(named: data.sky.code)
                cell.statusLabel.text = data.sky.name
                cell.minMaxLabel.text = "최대 \(data.temperature.tmax)º 최소 \(data.temperature.tmin)º"
                cell.currentTemperatureLabel.text = "\(data.temperature.tc)º"
            }
        return cell
    }
    //forecast 셀 리턴
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        let target = WeatherDataSource.shared.forecastList[indexPath.row]
        
        dateFormatter.dateFormat = "M.d (E)"
        cell.dateLabel.text = dateFormatter.string(for: target.date)
        
        dateFormatter.dateFormat = "HH:00"
        cell.timeLabel.text = dateFormatter.string(for: target.date)
        
        cell.weatherImageView.image = UIImage(named: target.skyCode)
        // 현재날씨
        cell.statusLabel.text = target.skyName
        
        let tempStr = tempFormatter.string(for: target.temperature) ?? "-"
        cell.temperatureLabel.text = "\(tempStr)º"
        
        return cell
    }
}

