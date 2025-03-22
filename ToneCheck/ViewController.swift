//
//  ViewController.swift
//  ToneCheck
//
//  Created by HIDEYASU ISHII on 2025/03/19.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var soundOptionStackView: UIStackView!
    
    @IBOutlet weak var firstSoundOptionButton: UIButton!
    
    @IBOutlet weak var secondSoundOptionButton: UIButton!
    
    @IBOutlet weak var soundButton: UIButton!
    
    @IBOutlet weak var soundButtonWidthConstraint: NSLayoutConstraint!
    
    private let pickerView = UIPickerView()
    private let toolbar = UIToolbar()
    private let pickerContainerView = UIView()
    
    let speakerPickerDataSource =  ["Google", "Apple", "Facebook", "Amazon"]
    
    /// 検査中フラグ
    private var isSoundOn = false {
        didSet {
            soundButton.setTitle(isSoundOn ? "検査中" : "検査音\n開始",
                                 for: .normal)
        }
    }
    
    private var frequencyType = FrequencyType.low {
        didSet {
            let onImageName = "button.programmable"
            let offImageName = "circle"
            firstSoundOptionButton.setImage(UIImage(systemName: frequencyType.isLow ? onImageName : offImageName), for: .normal)
            secondSoundOptionButton.setImage(UIImage(systemName: frequencyType.isLow ? offImageName : onImageName), for: .normal)
        }
    }
    
    @IBAction func showSpeakerPicker(_ sender: Any) {
        self.hidePickerView(isHidden: false)
    }
    
    @IBAction func didTapFirstSoundOption(_ sender: Any) {
        self.frequencyType = .low
        AudioManager.shared.updateFrequency(self.frequencyType.rawValue)
    }
    
    @IBAction func didTapSecondSoundOption(_ sender: Any) {
        self.frequencyType = .heigh
        AudioManager.shared.updateFrequency(self.frequencyType.rawValue)
    }
    
    @IBAction func didTapSoundButton(_ sender: Any) {
        if isSoundOn {
            AudioManager.shared.finish()
        } else {
            AudioManager.shared.start()
        }
        isSoundOn.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        print("Do any additional setup after loading the view.")
        
    }
    
    private func setupButtons() {
        soundOptionStackView.layer.cornerRadius = 5
        soundOptionStackView.layer.opacity = 0.5
        soundOptionStackView.backgroundColor = ToneCheckColor.stackViewBackground
        
        firstSoundOptionButton.setImage(UIImage(systemName: "button.programmable"), for: .normal)
        firstSoundOptionButton.setTitleColor(.black, for: .normal)
        firstSoundOptionButton.titleLabel?.textColor = .black
        secondSoundOptionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
        let height = soundButton.frame.size.height
        soundButtonWidthConstraint.constant = height
        soundButton.backgroundColor = .cyan
        soundButton.layer.cornerRadius = height / 2
        soundButton.setTitle("検査音\n開始", for: .normal)
        soundButton.titleLabel?.textAlignment = .center
        soundButton.titleLabel?.numberOfLines = 2
        
        // 決定ボタン付きのツールバーを作成
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        pickerContainerView.addSubview(toolbar)
        pickerContainerView.addSubview(pickerView)
        
        let screenHeight = UIScreen.main.bounds.size.height
        let pickerHeight = pickerView.bounds.size.height
        pickerView.backgroundColor = ToneCheckColor.stackViewBackground
        pickerView.frame = CGRect(x: 0, y: screenHeight - pickerHeight,
                                  width: UIScreen.main.bounds.size.width,
                                  height: pickerHeight)
        pickerView.delegate   = self
        pickerView.dataSource = self
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerContainerView)
        pickerContainerView.frame = CGRect(x: 0, y: screenHeight - 250,
                                           width: view.frame.width, height: 250)

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: pickerContainerView.topAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),

            pickerView.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor),
        ])
        self.hidePickerView(isHidden: true)
    }
    
    @objc private func doneTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
//        selectedValue = self.speakerPickerDataSource[selectedRow]

        self.hidePickerView(isHidden: true)
    }
    
    /// ピッカーの表示切り替え
    /// - Parameter isHidden: 表示フラグ
    private func hidePickerView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.frame.origin.y = isHidden ? self.view.frame.height : self.view.frame.height - 250
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return speakerPickerDataSource[row]
        }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speakerPickerDataSource.count
    }
    
    // 各選択肢が選ばれた時の操作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

class ToneCheckColor: UIColor {
    static let soundButtonColor = UIColor(red: 152, green: 232, blue: 227, alpha: 0.5)
    static let stackViewBackground = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
}
