import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Lifecycle
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        presenter = MovieQuizPresenter(
            viewController: self,
            questionFactory: QuestionFactory(),
            statisticsService: StatisticService()
        )
        
        presenter?.startGame()
    }
    
    // MARK: - Private functions
    private func configureUI() {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        indexLabel.font = .ysDisplayMedium20
        questionLabel.font = .ysDisplayMedium20
        noButton.titleLabel?.font = .ysDisplayMedium20
        yesButton.titleLabel?.font = .ysDisplayMedium20
        textLabel.font = .ysDisplayBold23
    }
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    func show(quiz result: QuizResultViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonTitle: result.buttonText
        ) { [weak self] in
            self?.presenter?.restartGame()
        }
        
        alertPresenter.show(in: self, model: alertModel)
    }
    
    func highlightAnswer(isCorrect: Bool) {
        setButtonsEnabled(false)
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func removeHighlight() {
        setButtonsEnabled(true)
        imageView.layer.borderWidth = 0
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
}
