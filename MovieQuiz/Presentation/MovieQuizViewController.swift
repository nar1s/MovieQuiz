import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    private let questions: [QuizQuestion] =
        [QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
         QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
         QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
         QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
         QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
         QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
         QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
         QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
         QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
         QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)]
    
    @IBOutlet private var indexLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
        
        imageView.layer.cornerRadius = 20
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        answerGiven(true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        answerGiven(false)
    }
    
    private func answerGiven(_ answer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let quizResults = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/10",
                buttonText: "Сыграть еще раз"
            )
            show(quiz: quizResults)
            imageView.layer.borderWidth = 0
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            show(quiz: convert(model: nextQuestion))
            imageView.layer.borderWidth = 0
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

// для состояния "Вопрос показан"
struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
