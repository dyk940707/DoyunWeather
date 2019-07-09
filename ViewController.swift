//
//  ViewController.swift
//  DoyunWeather
//
//  Created by Doyun on 09/07/2019.
//  Copyright © 2019 Doyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            return 0 //나중에 수정
        default:
            return 0
        }
    }
    //셀을 리턴하는 코드
    //summary 셀 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath)
            
        return cell
    }
    //forecast 셀 리턴
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath)
        
        return cell
    }
}
