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
    
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My points", style: .plain, target: self, action: #selector(showScore))
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        buttonReset.layer.borderWidth = 1.5
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        buttonReset.layer.borderColor = UIColor.lightGray.cgColor
        buttonReset.layer.cornerRadius = 5
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        questionsAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "What is the \(countries[correctAnswer].uppercased()) flag?"
        
        if questionsAsked == 5 {
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
        let alert = UIAlertController(title: "Your actual Score: \(score)", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }
    
}

