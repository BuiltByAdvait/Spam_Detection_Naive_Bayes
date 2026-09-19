============================================================
README.md
============================================================

# SENTINEL // SMS THREAT ANALYZER

> SMS Spam Detection using Multinomial Naive Bayes and R Shiny

SENTINEL is an interactive SMS threat analysis system that classifies text messages as HAM (legitimate) or SPAM (potentially malicious/unwanted) using a Multinomial Naive Bayes machine learning model.

The project combines Natural Language Processing, statistical modelling, probability, and an interactive R Shiny dashboard to provide message classification along with probability scores, confidence levels, threat indicators, and analysis history.

---

## 🚀 Features

- SMS Spam/Ham classification
- Multinomial Naive Bayes classifier
- Text preprocessing and Document-Term Matrix generation
- Vocabulary alignment
- Laplace smoothing
- HAM and SPAM probability estimation
- Confidence score
- Threat-level classification
- Suspicious keyword indicators
- Analysis trace
- Recent analysis history
- Interactive R Shiny interface
- Cyberpunk-inspired terminal interface
- Model performance visualization
- Confusion matrix visualization
- Test-message buttons for quick demonstration

---

## 🧠 How It Works

The system follows a complete text-classification pipeline:

SMS Message
     ↓
Text Preprocessing
     ↓
Document-Term Matrix
     ↓
Vocabulary Alignment
     ↓
Multinomial Naive Bayes
     ↓
HAM / SPAM Scores
     ↓
Probability Calculation
     ↓
Classification + Confidence
     ↓
Threat Indicators
     ↓
R Shiny Dashboard

The model calculates the probability of the message belonging to each class:

- HAM
- SPAM

The class with the higher probability becomes the final prediction.

The implementation uses Laplace smoothing to handle words that may not appear in a particular class during training.

---

## 📊 Dataset

The project uses a labelled SMS dataset containing:

| Dataset | Messages |
|---|---:|
| Total | 5,574 |
| Training | 4,459 |
| Testing | 1,115 |

The dataset contains two classes:

- `ham` — legitimate messages
- `spam` — spam messages

The dataset is included in:

data/SMSSpamCollection

> Dataset attribution/source information should follow the original dataset provider's terms and license.

---

## 📈 Model Performance

The final Multinomial Naive Bayes model was evaluated on the test dataset.

| Metric | Score |
|---|---:|
| Accuracy | 98.12% |
| Precision | 88.68% |
| Recall | 97.92% |
| F1-Score | 93.07% |

### Confusion Matrix

                 Predicted
              HAM       SPAM
Actual HAM     953       18
Actual SPAM      3      141

The corresponding visualization is available in:

plots/confusion_matrix.png

Additional model visualizations:

plots/model_performance.png
plots/spam_vs_ham_distribution.png

---

## 🖥️ SENTINEL Dashboard

The R Shiny application provides an interactive interface for analysing SMS messages.

### Dashboard capabilities

Model Status:
- Dataset size
- Training samples
- Testing samples
- Accuracy
- F1-score
- Analysis counter

Message Analysis:
- Enter any SMS message
- Analyze message
- Test sample spam message
- Test sample ham message
- Clear input

Analysis Results:
- Final classification
- HAM probability
- SPAM probability
- Confidence score
- Threat level
- Analysis trace
- Suspicious indicators
- Explanation panel
- Recent analysis history

---

## 🛠️ Tech Stack

### Programming Language

- R

### Machine Learning

- Multinomial Naive Bayes
- Probability-based classification
- Laplace smoothing

### Natural Language Processing

- Text preprocessing
- Document-Term Matrix
- Vocabulary alignment
- Token-based classification

### Visualization

- ggplot2
- Base R visualizations

### Application

- R Shiny

---

## 📁 Project Structure

Spam_Detection_Naive_Bayes/
│
├── data/
│   ├── SMSSpamCollection
│   └── readme
│
├── plots/
│   ├── confusion_matrix.png
│   ├── model_performance.png
│   └── spam_vs_ham_distribution.png
│
├── scripts/
│   ├── 01_data_loading.R
│   ├── 02_text_preprocessing.R
│   ├── 03_document_term_matrix.R
│   ├── 04_naive_bayes_model.R
│   ├── 05_new_message_prediction.R
│   └── 06_shiny_app.R
│
├── .gitignore
└── README.md

---

## ⚙️ How to Run

### 1. Clone the repository

git clone https://github.com/BuiltByAdvait/Spam_Detection_Naive_Bayes.git

### 2. Open the project

Open the project directory in RStudio.

### 3. Install the required packages

Install the packages required by the scripts if they are not already installed.

Example:

install.packages("tm")
install.packages("shiny")
install.packages("ggplot2")

Additional packages used by individual scripts may need to be installed depending on your R environment.

### 4. Run the analysis pipeline

Run the scripts in the following order:

01_data_loading.R
02_text_preprocessing.R
03_document_term_matrix.R
04_naive_bayes_model.R
05_new_message_prediction.R

### 5. Launch SENTINEL

Run:

06_shiny_app.R

The Shiny application will launch in RStudio's Shiny viewer or your default browser.

---

## 🔍 Example Predictions

### Spam

Congratulations! You have won a free prize. Call now!

Expected classification:

SPAM

### Ham

Hey bro, are you coming to college tomorrow?

Expected classification:

HAM

---

## ⚠️ Threat Indicators

SENTINEL also contains a separate rule-based indicator layer that checks the input message for suspicious terms commonly associated with potentially unwanted messages.

Examples include:

OTP
password
PIN
prize
winner
claim
urgent
click
verify
bank
reward
offer
free
cash
lottery
transfer
congratulations

These indicators are used for explainability and threat highlighting and are separate from the underlying Naive Bayes classification model.

---

## 📌 Limitations

- Classification depends on the vocabulary learned from the training dataset.
- Unusual or unseen message patterns may reduce prediction reliability.
- Some legitimate messages containing words commonly associated with spam may receive a high spam probability.
- The suspicious-keyword indicator layer is rule-based and should not be interpreted as part of the machine learning model itself.
- Model performance on the provided test dataset does not guarantee identical performance on real-world SMS traffic.

---

## 🔮 Future Scope

Possible improvements include:

- Larger and more diverse SMS datasets
- TF-IDF based feature representation
- N-gram features
- Additional machine learning algorithms
- Model comparison
- Cross-validation
- ROC and Precision-Recall analysis
- Real-time SMS stream analysis
- URL and sender analysis
- More advanced NLP techniques
- Multilingual spam detection
- Deployment as a web application

---

## 👨‍💻 Team

| Name | Roll No. |
|---|---:|
| Aniket Adhikari | 25901 |
| Anushaa Anjellah | 25902 |
| Aneesh Rawle | 25903 |
| Advait Bankar | 25904 |

### Project Guides

- Prof. Neha Salunkhe
- Prof. Monali Chandwadkar

### Head of Department

- Prof. Sonali Sherigar

### Course

Statistical Modelling for Machine Learning (SML)

---

## 📚 Academic Context

This project was developed as a microproject for the Statistical Modelling for Machine Learning (SML) course.

The project demonstrates the practical application of:

- Probability
- Bayes' theorem
- Naive Bayes classification
- Natural Language Processing
- Statistical modelling
- Data preprocessing
- Model evaluation
- Data visualization
- R programming
- Interactive application development

---

## 📜 License

This project is licensed under the MIT License.

See the LICENSE file for details.

---

## ⭐ Acknowledgements

Thanks to the faculty guides and the SML course team for their guidance and support throughout the project.

---

Built with R • NLP • Naive Bayes • R Shiny
