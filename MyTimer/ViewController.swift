//
//  ViewController.swift
//  MyTimer
//
//  Created by tsuyoshi_pro on 2019/02/03.
//  Copyright © 2019 TsuyoshiOkumura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // タイマーの変数を作成
    var timer : Timer?
    
    // カウント(経過時間)の変数を作成
    var count = 0
    
    // 設定値を扱うキーを設定
    let settingKey = "timer_value"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        
        // UserDefaultsに初期値を登録
        settings.register(defaults: [settingKey: 10])
    }


    @IBOutlet weak var countDownLabel: UILabel!
    
    private func stopTimer() {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが実行中だったら停止
            if nowTimer.isValid == true {
                // タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    @IBAction func settingButtonAction(_ sender: Any) {
        stopTimer()
        
        // 画面遷移を行う
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが実行中だったら実行しない
            if nowTimer.isValid == true {
                // 何も処理しない
                return
            }
        }
        
        // タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        stopTimer()
    }
    
    // 画面の更新をする(戻り値: remainCount:戻り時間)
    func displayUpdate() -> Int {
        // UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        
        // 取得した秒数をtimer_valueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        
        // 残り時間(remainCount)を生成
        let remainCount = timerValue - count
        
        // remainCount(残り時間)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        
        // 残り時間を戻り値に設定
        return remainCount
    }
    
    @objc func timerInterrupt(_ timer:Timer) {
        // count(経過時間)に+1していく
        count += 1
        
        // remainCount(残り時間)が0以下の時に、タイマーを止める
        if displayUpdate()  <= 0 {
            // 初期化処理
            count = 0
            
            // タイマー停止
            timer.invalidate()
            
            // カスタマイズ編: ダイアログを作成
            let alertController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
            // ダイアログに表示させるOKボタンを作成
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            // アクションを追加
            alertController.addAction(defaultAction)
            // ダイアログを表示
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // 画面切り替えのタイミングで処理を行う
    override func viewDidAppear(_ animated: Bool) {
        // カウント(経過時間)を0にする
        count = 0
        
        // タイマーの表示を更新する
        _ = displayUpdate()
    }
}

