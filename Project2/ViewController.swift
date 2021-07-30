import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var buttonReset: UIButton!
    
    //MARK: - IBActions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            message = "Congratulations!"
            score += 1
        } else {
            title = "Wrong"
            message = "That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if score > highestScore {
            highestScore = score
        }
        saveScore()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(alert, animated: true)
    }
    
    @IBAction func buttonReset(_ sender: UIButton) {
        resetGame()
    }
    
    
    //MARK: - Proprieties
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var highestScore = 0
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        createButtonScore(title: "Score")
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "uk", "us"]
        changingProprietiesOffButtons()
        askQuestion()
        
        let defaultScore = UserDefaults.standard
        
        if let savedScore = defaultScore.object(forKey: "highestScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highestScore = try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                fatalError()
            }
        }
    }
    
    
    //MARK: - Methods
    func askQuestion(action: UIAlertAction! = nil) {
        questionsAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "What is the \(countries[correctAnswer].uppercased()) flag?"
        
        if questionsAsked == 10 {
            let alert = UIAlertController(title: "Game Over", message: "The game has finished, your final score was \(score) points", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: resetGame))
            present(alert, animated: true)
        }
    }
    
    func resetGame(action: UIAlertAction! = nil) {
        score = 0
        questionsAsked = 0
        askQuestion()
    }

    @objc func showScore() {
        createAlert(title: "Your actual Score: \(score)", message: "Highest Score: \(highestScore)")
    }
    
    func changingProprietiesOffButtons() {
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        buttonReset.layer.borderWidth = 1.5
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        buttonReset.layer.borderColor = UIColor.lightGray.cgColor
        buttonReset.layer.cornerRadius = 5
    }
    
    func createButtonScore(title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(showScore))
    }
    
    func createAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }
    
    
    //MARK: - Codable Saving
    func saveScore() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(highestScore) {
            let defaultScore = UserDefaults.standard
            defaultScore.set(savedData, forKey: "highestScore")
        } else {
            fatalError()
        }
    }
    
}

