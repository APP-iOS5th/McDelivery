//
//  CustomTooltipViewController.swift
//  UIKitPlayground
//
//  Created by Minyoung Yoo on 6/5/24.
//

import UIKit

class CustomTooltipViewController: UIViewController {
    
    lazy var viewWithBackgroundColorTooltip: UIView = {
        //회색뷰
        let view = UIView()
        //레이블뷰
        let label = UILabel(frame: CGRect(x: 0, y: 0,
                                          width: 100, height: 50))
        //뾰루지뷰
        let bubblePointer = UIView(frame: CGRect(origin: CGPoint(x: 60 ,y: 115), size: CGSize(width: 10, height: 10)))

        //뾰루지 배경색 맞추고 45도 회전
        bubblePointer.backgroundColor = .systemGray
        bubblePointer.transform = CGAffineTransform(rotationAngle: .pi / 4)

        //회색뷰 세팅
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0

        //툴팁 레이블 세팅
        label.text = "This is Tooltip"
        label.textAlignment = .center

        //회색뷰에 자식뷰들 심기
        view.addSubview(label)
        view.addSubview(bubblePointer)
        view.layer.opacity = 0.0

        return view
    }()

    //툴팁 on/off에 필요한 boolean
    var isTooltipShowing: Bool = false
    
    let button: UIButton = {
        let btn = UIButton()
        btn.configuration = .borderedProminent()
        btn.configuration?.title = "Show ToolTip!"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(button)
        self.view.addSubview(viewWithBackgroundColorTooltip)
        
        self.button.addTarget(self, action: #selector(toggleTooltip), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.viewWithBackgroundColorTooltip.widthAnchor.constraint(equalToConstant: 200),
            self.viewWithBackgroundColorTooltip.heightAnchor.constraint(equalToConstant: 120),
            self.viewWithBackgroundColorTooltip.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -20),
            self.viewWithBackgroundColorTooltip.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc func toggleTooltip() {
        isTooltipShowing.toggle()
        switch isTooltipShowing {
            case true:
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.viewWithBackgroundColorTooltip.layer.opacity = 1.0
                }
            case false:
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.viewWithBackgroundColorTooltip.layer.opacity = 0.0
                }
        }
    }

}
