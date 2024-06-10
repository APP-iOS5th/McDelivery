


import UIKit
import AVKit

class McRotator: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let countries = [
        "Switzerland", "Norway", "Uruguay", "Sweden", "Euro Area", "United States", "Canada", "Australia", "Brazil",
        "United Kingdom", "South Korea", "Saudi Arabia", "Argentina", "China", "India", "Indonesia", "Philippines",
        "Malaysia", "Egypt", "South Africa", "Ukraine", "Hong Kong", "Vietnam", "Japan", "Romania", "Azerbaijan",
        "Jordan", "Moldova", "Oman", "Taiwan"
    ]
    var labels: [UILabel] = []
    var lastAngle: CGFloat = 0
    var counter: CGFloat = 0
    var currentRotationAngle: CGFloat = 0
    
    var lastText : String?
    
    var resultLabel: UILabel!
    var centerLabel: UILabel!
    
    //SearchBar
    let searchBar = UISearchBar()
    let countryTableView = UITableView()
    var searchedCountries :[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        let circleCenter = CGPoint(x: 0, y: view.frame.height / 2)
        let circleRadius: CGFloat = 250
        
        for (index, country) in countries.enumerated() {
            let angle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(countries.count)
            let labelX = circleCenter.x + circleRadius * cos(angle)
            let labelY = circleCenter.y + circleRadius * sin(angle)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 125, height: 20))
            label.center = CGPoint(x: labelX, y: labelY)
            label.text = country
            label.textAlignment = .center
            label.attributedText = attributedString(for: country, fittingWidth: 125, in: label)
            label.transform = CGAffineTransform(rotationAngle: angle)
            
            
            //위치, 결과 확인용 레이블
            self.labels.append(label)
            self.view.addSubview(label)
            resultLabel = UILabel(frame: CGRect(x: 250, y: 100, width: 200, height: 40))
            resultLabel.numberOfLines = 0
            resultLabel.layer.borderWidth = 1.0
            resultLabel.layer.borderColor = UIColor.black.cgColor
            centerLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height / 2  - 20, width: self.view.frame.width, height: 40))
            centerLabel.layer.borderColor = UIColor.black.cgColor
            centerLabel.layer.borderWidth = 1.0
            self.view.addSubview(resultLabel)
            self.view.addSubview(centerLabel)
        }
        
        // UISearchBar
        view.addSubview(searchBar)
        searchBar.frame = CGRect(x: (self.view.frame.size.width  - 50) / 2 , y: 100, width: 50, height: 50)
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        // UITableView
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.allowsSelection = true
        countryTableView.frame = CGRect(x: (self.view.frame.size.width - 200) / 2, y: searchBar.frame.origin.y + 50 , width: 200, height:  100)
        countryTableView.layer.cornerRadius = 10
        countryTableView.layer.borderWidth = 1.0
        countryTableView.layer.borderColor = UIColor.black.cgColor
        countryTableView.isHidden = true
        view.addSubview(countryTableView)
        
    }
    
    func attributedString(for text: String, fittingWidth width: CGFloat, in label: UILabel) -> NSAttributedString {
           let font = label.font ?? UIFont.systemFont(ofSize: 17)  //label 폰트 여기에
           let attributes: [NSAttributedString.Key: Any] = [
               .font: font
           ]
           let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
           
           let textWidth = text.size(withAttributes: attributes).width
           let spacing = (width - textWidth) / CGFloat(text.count - 1)
           
           attributedText.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count - 1))
           
           return attributedText
       }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        let centerX = UIScreen.main.bounds.minX
        let centerY = UIScreen.main.bounds.height / 2
        var angle = atan2(location.y - centerY, location.x - centerX) * 180 / .pi
        
        if angle < 0 { angle += 360 }
        let theta = lastAngle - angle
        lastAngle = angle
        
        if abs(theta) < 12 {
            counter += theta
        }
        if counter > 12  {
            rotateLabels(by: -1)
            AudioServicesPlaySystemSound(1104)
        } else if counter < -12  {
            rotateLabels(by: 1)
            AudioServicesPlaySystemSound(1104)
        }
        if abs(counter) > 12 { counter = 0 }
        if gesture.state == .ended {
            counter = 0
        }
    }
    
    func rotateLabels(by steps: Int) {
        let angleStep = 2 * CGFloat.pi / CGFloat(labels.count)
        currentRotationAngle += CGFloat(steps) * angleStep
        
        let circleCenter = CGPoint(x: 0, y: view.frame.height / 2)
        let circleRadius: CGFloat = 250
        
        UIView.animate(withDuration: 0.2, animations:  {
            for (index, label) in self.labels.enumerated() {
                let baseAngle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(self.labels.count) + self.currentRotationAngle
                let labelX = circleCenter.x + circleRadius * cos(baseAngle)
                let labelY = circleCenter.y + circleRadius * sin(baseAngle)
                
                label.center = CGPoint(x: labelX, y: labelY)
                label.transform = CGAffineTransform(rotationAngle: baseAngle)
            }
        }, completion: { _ in  self.labelTextSending()
        } )
    }
    
    func labelTextSending()  {
        let circleCenter =  CGPoint(x: 0, y: view.frame.height / 2)
        let circleRadius: CGFloat = 250
        let sendingNearOne = circleCenter.x + circleRadius
        
        for label in labels {
            if abs(label.center.x - sendingNearOne) < 5 {
                if let labelText = label.text {
                    resultLabel.text = "\(labelText)"

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.lastText =  "\(labelText)"
                        if self.resultLabel.text == self.lastText {
                            UIView.animate(withDuration: 0.2, delay: 0 ,options: .curveEaseInOut , animations: {
                                label.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            } ) { _ in UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut
                            ) {
                                label.transform = CGAffineTransform.identity
                            }
                            }
                        }
                    }
                }
            }
        }
    }
    // UISearchBarDelegate 메서드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchedCountries = nil
            countryTableView.isHidden = true
        } else {
            searchedCountries = countries.filter { $0.contains(searchText) }
            countryTableView.isHidden = false
        }
        countryTableView.reloadData()
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 포커스가 가면 직사각형 모양으로 펼쳐지는 애니메이션
        UIView.animate(withDuration: 0.2, delay: 0 , options: .curveEaseInOut) {
            // x좌표를 searchBar의 중심이 되게 조정
            searchBar.frame.origin.x = (self.view.frame.size.width - 150) / 2
            searchBar.frame.size.width = 150
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 포커스가 가지 않으면 정사각형 모양으로 되돌리는 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut) {
            searchBar.frame.origin.x = (self.view.frame.size.width - 50) / 2
            searchBar.text = nil
            self.countryTableView.isHidden = true
            
            searchBar.frame.size.width = 50
        }
    }
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedCountries?.count ?? countries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = searchedCountries?[indexPath.row] ?? countries[indexPath.row]
        return cell
    }
    
    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = searchedCountries?[indexPath.row] ?? countries[indexPath.row]
        var searchedIndex: Int? = 0
        let tolerance: CGFloat = 5.0 // 오차 범위 설정
        let targetPoint = CGPoint(x: 250, y: view.frame.height / 2)
        
        for (index, label) in self.labels.enumerated() {
            if selectedData == label.text {
                searchedIndex = index
            }
            if let searchedIndex = searchedIndex {
                let currentIndex = labels.firstIndex(where: { distance(from: $0.center, to: targetPoint) < tolerance }) ?? 0
                let steps =   currentIndex - searchedIndex
                self.rotateLabels(by: steps )
                self.counter = 0
            }
        }
        searchBar.text = nil
        tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}
