# SENTINEL // SMS THREAT ANALYZER

> SMS Spam Detection using Multinomial Naive Bayes and R Shiny

<p align="center">

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-Naive%20Bayes-8A2BE2?style=for-the-badge)
![NLP](https://img.shields.io/badge/NLP-Text%20Classification-00A67E?style=for-the-badge)
![R Shiny](https://img.shields.io/badge/R%20Shiny-Interactive%20Dashboard-75AADB?style=for-the-badge)
![Accuracy](https://img.shields.io/badge/Accuracy-98.12%25-2EA44F?style=for-the-badge)
![F1 Score](https://img.shields.io/badge/F1--Score-93.07%25-FFB000?style=for-the-badge)

</p>

<p align="center">
  <strong>Intelligent SMS Spam Detection powered by Multinomial Naive Bayes</strong>
</p>

<p align="center">
  A statistical machine learning project built with R, Natural Language Processing, and R Shiny.
</p>

---

## 🛡️ Overview

**SENTINEL** is an interactive SMS threat analysis system that classifies text messages as **HAM** or **SPAM** using a **Multinomial Naive Bayes** machine learning model.

The system combines statistical modelling, probability, Natural Language Processing, text classification, and an interactive R Shiny dashboard to provide classification results, probability scores, confidence levels, threat indicators, and analysis history.

The project was developed as a practical implementation of concepts covered in **Statistical Modelling for Machine Learning (SML)**.

---

## ✨ Key Features

- 🧠 Multinomial Naive Bayes classification
- 🔤 Natural Language Processing pipeline
- 📊 Document-Term Matrix representation
- 🧮 Laplace smoothing
- 🎯 HAM and SPAM probability calculation
- 📈 Classification confidence score
- 🚨 Threat-level classification
- 🔍 Suspicious keyword indicators
- 🧾 Classification analysis trace
- 📜 Recent analysis history
- 🖥️ Interactive R Shiny dashboard
- 🌐 Cybersecurity-inspired terminal interface
- 📊 Confusion matrix visualization
- 📉 Model performance visualization
- 📨 Built-in test messages

---

# 🧠 System Architecture

```text
                         ┌───────────────────────┐
                         │      SMS MESSAGE      │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │  TEXT PREPROCESSING   │
                         │                       │
                         │  • Cleaning           │
                         │  • Normalization      │
                         │  • Tokenization       │
                         │  • Feature Extraction │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ DOCUMENT-TERM MATRIX  │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ VOCABULARY ALIGNMENT  │
                         └───────────┬───────────┘
                                     │
                                     ▼
                 ┌────────────────────────────────────┐
                 │      MULTINOMIAL NAIVE BAYES       │
                 │                                    │
                 │  • Class Priors                    │
                 │  • Word Probabilities              │
                 │  • Laplace Smoothing               │
                 │  • Log Probability Scores          │
                 └──────────────────┬─────────────────┘
                                    │
                                    ▼
                         ┌───────────────────────┐
                         │ PROBABILITY ANALYSIS  │
                         │                       │
                         │  • HAM Probability    │
                         │  • SPAM Probability   │
                         │  • Confidence         │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │   THREAT ANALYSIS     │
                         │                       │
                         │  • Suspicious Terms   │
                         │  • Threat Level       │
                         │  • Analysis Trace     │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │       R SHINY         │
                         │      DASHBOARD         │
                         └───────────────────────┘
```

---

# 📊 Dataset

The project uses a labelled SMS dataset containing **5,574 messages**.

| Dataset Split | Messages |
|---|---:|
| Total | **5,574** |
| Training | **4,459** |
| Testing | **1,115** |

### Classes

| Class | Meaning |
|---|---|
| `ham` | Legitimate SMS message |
| `spam` | Spam SMS message |

Dataset file:

```text
data/SMSSpamCollection
```

> Dataset attribution and usage should follow the original dataset provider's terms and license.

---

# ⚙️ Machine Learning Pipeline

SENTINEL uses a manually implemented **Multinomial Naive Bayes** approach for text classification.

### 01 — Text Preprocessing

Raw SMS messages are cleaned and transformed into a normalized representation.

```text
Raw SMS
   ↓
Cleaning
   ↓
Normalization
   ↓
Tokenization
   ↓
Processed Text
```

### 02 — Document-Term Matrix

The processed messages are converted into a **Document-Term Matrix (DTM)** where:

- Rows represent SMS messages
- Columns represent vocabulary terms
- Values represent term occurrences

### 03 — Vocabulary Alignment

The training and testing matrices are aligned using their common vocabulary so that both datasets use the same feature space.

### 04 — Multinomial Naive Bayes

The classifier calculates:

- Class priors
- Word probabilities
- HAM score
- SPAM score

### 05 — Laplace Smoothing

Laplace smoothing is applied to prevent zero probabilities for unseen words.

### 06 — Final Classification

The message is classified according to the higher calculated class probability.

---

# 📈 Model Performance

The final model was evaluated on the held-out testing dataset.

| Metric | Result |
|---|---:|
| 🎯 Accuracy | **98.12%** |
| 🔎 Precision | **88.68%** |
| 📥 Recall | **97.92%** |
| ⚡ F1-Score | **93.07%** |

## Confusion Matrix

```text
                         Predicted
                    ┌─────────┬─────────┐
                    │   HAM   │  SPAM   │
┌────────────┬──────┼─────────┼─────────┤
│ Actual HAM │      │   953   │    18   │
├────────────┼──────┼─────────┼─────────┤
│ Actual SPAM│      │     3   │   141   │
└────────────┴──────┴─────────┴─────────┘
```

## 📊 Performance Visualizations

```text
plots/
├── confusion_matrix.png
├── model_performance.png
└── spam_vs_ham_distribution.png
```

---

# 🖥️ SENTINEL Dashboard

The project includes an interactive **R Shiny dashboard** with a dark, cybersecurity-inspired terminal interface.

## 📡 Model Status

The dashboard displays:

- Dataset size
- Training samples
- Testing samples
- Accuracy
- F1-score
- Analysis count

## 📨 Message Analyzer

Users can:

- Enter an SMS message
- Analyze the message
- Test a sample spam message
- Test a sample ham message
- Clear the input

## 🎯 Classification Result

After analysis, the dashboard displays:

```text
Prediction
    ↓
HAM / SPAM

Probability
    ↓
HAM %
SPAM %

Confidence
    ↓
Classification Confidence

Threat Level
    ↓
HIGH / MODERATE / LOW
```

## 🔍 Explainability

SENTINEL provides:

- Analysis trace
- Suspicious terms
- Threat indicators
- Threat level
- "Why was this flagged?" information
- Recent analysis history

---

# 🚨 Threat Indicator Layer

SENTINEL contains a separate rule-based indicator layer that highlights suspicious terms commonly associated with potentially unwanted messages.

Examples include:

```text
OTP
password
PIN
prize
winner
claim
urgent
click
verify
verification
account
bank
reward
offer
free
cash
lottery
transfer
fee
congratulations
selected
```

These indicators are used for **explainability and threat highlighting**.

They are separate from the underlying Multinomial Naive Bayes model and are not used to calculate the official test-set performance metrics.

---

# 🧪 Example Analysis

## 📩 Example 01 — Spam

```text
Congratulations! You have won a free prize. Call now!
```

**Prediction:** `SPAM`

## 💬 Example 02 — Ham

```text
Hey bro, are you coming to college tomorrow?
```

**Prediction:** `HAM`

---

# 🛠️ Technology Stack

### Programming Language

- R

### Machine Learning

- Multinomial Naive Bayes
- Probability Modelling
- Laplace Smoothing

### Natural Language Processing

- Text Preprocessing
- Document-Term Matrix
- Vocabulary Alignment
- Token-Based Features

### Visualization

- ggplot2
- Base R

### Application

- R Shiny

---

# 📁 Project Structure

```text
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
├── LICENSE
└── README.md
```

---

# 🚀 Installation & Setup

## 1. Clone the Repository

```bash
git clone https://github.com/BuiltByAdvait/Spam_Detection_Naive_Bayes.git
cd Spam_Detection_Naive_Bayes
```

## 2. Open in RStudio

Open the project directory in **RStudio**.

## 3. Install Dependencies

Install the required packages if they are not already installed:

```r
install.packages("tm")
install.packages("shiny")
install.packages("ggplot2")
```

Additional packages required by individual scripts may need to be installed depending on your R environment.

## 4. Run the Analysis Pipeline

Execute the scripts in sequence:

```text
01_data_loading.R
        ↓
02_text_preprocessing.R
        ↓
03_document_term_matrix.R
        ↓
04_naive_bayes_model.R
        ↓
05_new_message_prediction.R
        ↓
06_shiny_app.R
```

---

# 🌐 Launch the Application

Open:

```text
scripts/06_shiny_app.R
```

Run the Shiny application from RStudio.

The application will open in the RStudio Viewer or your default web browser.

---

# 📌 Limitations

- Classification depends on the vocabulary learned from the training dataset.
- Unusual or unseen message patterns may reduce prediction reliability.
- Legitimate messages containing spam-associated words may receive a high spam probability.
- The suspicious-keyword indicator layer is rule-based and separate from the machine learning model.
- Test-set performance does not guarantee identical performance on real-world SMS traffic.
- The current system primarily analyses message text and does not independently verify URLs, sender identity, or external message metadata.

---

# 🔮 Future Scope

Potential improvements include:

- Larger and more diverse SMS datasets
- TF-IDF feature representation
- N-gram features
- Additional machine learning algorithms
- Model comparison
- Cross-validation
- ROC curve analysis
- Precision-Recall analysis
- URL analysis
- Sender analysis
- Real-time SMS stream processing
- Multilingual spam detection
- Advanced NLP models
- Web deployment
- API-based integration

---

# 👨‍💻 Project Team

| Name | Roll No. |
|---|---:|
| **Aniket Adhikari** | 25901 |
| **Anushaa Anjellah** | 25902 |
| **Aneesh Rawle** | 25903 |
| **Advait Bankar** | 25904 |

### Faculty Guides

**Prof. Neha Salunkhe**

**Prof. Monali Chandwadkar**

### Head of Department

**Prof. Sonali Sherigar**

### Course

**Statistical Modelling for Machine Learning (SML)**

---

# 🎓 Academic Context

This project was developed as a microproject for the **Statistical Modelling for Machine Learning (SML)** course.

The project demonstrates practical applications of:

- Probability
- Bayes' Theorem
- Naive Bayes Classification
- Natural Language Processing
- Statistical Modelling
- Data Preprocessing
- Model Evaluation
- Data Visualization
- R Programming
- Interactive Application Development

---

# ⭐ Acknowledgements

We would like to thank our faculty guides and the SML course team for their guidance and support throughout the development of this project.

---

<p align="center">

<strong>SENTINEL // SMS THREAT ANALYZER</strong>

<br><br>

Built with R • NLP • Multinomial Naive Bayes • R Shiny

<br><br>

<a href="https://github.com/BuiltByAdvait/Spam_Detection_Naive_Bayes">
View Repository
</a>

</p>- 📨 Built-in test messages for demonstration

---

# 🧠 System Architecture

```text
                         ┌───────────────────────┐
                         │      SMS MESSAGE      │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │  TEXT PREPROCESSING   │
                         │                       │
                         │  • Cleaning           │
                         │  • Normalization      │
                         │  • Tokenization       │
                         │  • Feature Extraction │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ DOCUMENT-TERM MATRIX  │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ VOCABULARY ALIGNMENT  │
                         └───────────┬───────────┘
                                     │
                                     ▼
                 ┌────────────────────────────────────┐
                 │      MULTINOMIAL NAIVE BAYES       │
                 │                                    │
                 │  • Class Priors                    │
                 │  • Word Probabilities              │
                 │  • Laplace Smoothing               │
                 │  • Log Probability Scores          │
                 └──────────────────┬─────────────────┘
                                    │
                                    ▼
                         ┌───────────────────────┐
                         │ PROBABILITY ANALYSIS  │
                         │                       │
                         │  • HAM Probability    │
                         │  • SPAM Probability   │
                         │  • Confidence         │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │   THREAT ANALYSIS     │
                         │                       │
                         │  • Suspicious Terms   │
                         │  • Threat Level       │
                         │  • Analysis Trace     │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │       R SHINY         │
                         │    DASHBOARD / UI     │
                         └───────────────────────┘
📊 Dataset

The project uses a labelled SMS dataset containing 5,574 messages.

Dataset Split	Messages
Total	5,574
Training	4,459
Testing	1,115
Classes
Class	Meaning
ham	Legitimate SMS message
spam	Spam SMS message

The dataset is included in:

data/SMSSpamCollection

Dataset attribution and usage should follow the original dataset provider's terms and license.

⚙️ Machine Learning Pipeline

SENTINEL uses a manually implemented Multinomial Naive Bayes approach for text classification.

01 — Text Preprocessing

Raw SMS messages are transformed into a normalized representation suitable for statistical modelling.

Raw Message
     ↓
Cleaning
     ↓
Normalization
     ↓
Tokenization
     ↓
Processed Text
02 — Document-Term Matrix

The processed messages are converted into a Document-Term Matrix (DTM) where:

Rows represent SMS messages
Columns represent vocabulary terms
Values represent term occurrences
03 — Vocabulary Alignment

The training and testing matrices are aligned using their common vocabulary so that both datasets use the same feature space.

04 — Multinomial Naive Bayes

The classifier calculates:

Class priors
Word probabilities
HAM score
SPAM score
05 — Laplace Smoothing

Laplace smoothing is applied to prevent zero probabilities for unseen words.

06 — Final Classification

The message is classified according to the higher calculated class probability.

                    Message
                       │
              ┌────────┴────────┐
              ▼                 ▼
        HAM Probability    SPAM Probability
              │                 │
              └────────┬────────┘
                       ▼
               Higher Probability
                       │
                       ▼
                Final Prediction
📈 Model Performance

The final model was evaluated using the held-out testing dataset.

Metric	Result
🎯 Accuracy	98.12%
🔎 Precision	88.68%
📥 Recall	97.92%
⚡ F1-Score	93.07%
Confusion Matrix
                         Predicted
                    ┌─────────┬─────────┐
                    │   HAM   │  SPAM   │
┌────────────┬──────┼─────────┼─────────┤
│ Actual HAM │      │   953   │    18   │
├────────────┼──────┼─────────┼─────────┤
│ Actual SPAM│      │     3   │   141   │
└────────────┴──────┴─────────┴─────────┘
📊 Visualizations

The repository contains:

plots/
├── confusion_matrix.png
├── model_performance.png
└── spam_vs_ham_distribution.png
🖥️ SENTINEL Dashboard

The project includes an interactive R Shiny dashboard with a dark, cybersecurity-inspired terminal interface.

📡 Model Status

The dashboard displays:

Dataset size
Training samples
Testing samples
Model accuracy
F1-score
Total analysis count
📨 Message Analyzer

Users can:

Enter an SMS message
Analyze the message
Test a sample spam message
Test a sample ham message
Clear the input
🎯 Classification Result

After analysis, the dashboard displays:

Prediction
     ↓
HAM / SPAM

Probability
     ↓
HAM %
SPAM %

Confidence
     ↓
Classification Confidence

Threat Level
     ↓
HIGH / MODERATE / LOW
🔍 Explainability

SENTINEL provides additional information to make the classification easier to understand:

Analysis trace
Suspicious terms
Threat indicators
Threat level
"Why was this flagged?" section
Recent analysis history
🚨 Threat Indicator Layer

SENTINEL contains a separate rule-based indicator layer that highlights suspicious terms commonly associated with potentially unwanted messages.

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
verification
account
bank
reward
offer
free
cash
lottery
transfer
fee
congratulations
selected

These indicators are used for explainability and threat highlighting.

They are separate from the underlying Multinomial Naive Bayes model and are not used to calculate the official test-set performance metrics.

🧪 Example Analysis
📩 Example 01 — Spam
Congratulations! You have won a free prize. Call now!
Prediction: SPAM
💬 Example 02 — Ham
Hey bro, are you coming to college tomorrow?
Prediction: HAM
🛠️ Technology Stack
Programming Language
R
Machine Learning
Multinomial Naive Bayes
Probability Modelling
Laplace Smoothing
Natural Language Processing
Text Preprocessing
Document-Term Matrix
Vocabulary Alignment
Token-Based Features
Visualization
ggplot2
Base R
Application
R Shiny
📁 Project Structure
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
├── LICENSE
└── README.md
🚀 Installation & Setup
1. Clone the Repository
git clone https://github.com/BuiltByAdvait/Spam_Detection_Naive_Bayes.git
cd Spam_Detection_Naive_Bayes
2. Open in RStudio

Open the project directory in RStudio.

3. Install Dependencies

Install the required packages if they are not already installed:

install.packages("tm")
install.packages("shiny")
install.packages("ggplot2")

Additional packages required by individual scripts may need to be installed depending on your R environment.

4. Run the Analysis Pipeline

Execute the scripts in sequence:

01_data_loading.R
        ↓
02_text_preprocessing.R
        ↓
03_document_term_matrix.R
        ↓
04_naive_bayes_model.R
        ↓
05_new_message_prediction.R
        ↓
06_shiny_app.R
🌐 Launch the Application

Open:

scripts/06_shiny_app.R

Run the Shiny application from RStudio.

The application will open in the RStudio Viewer or your default web browser.

📌 Limitations
Classification depends on the vocabulary learned from the training dataset.
Unusual or unseen message patterns may reduce prediction reliability.
Legitimate messages containing spam-associated words may receive a high spam probability.
The suspicious-keyword indicator layer is rule-based and separate from the machine learning model.
Test-set performance does not guarantee identical performance on real-world SMS traffic.
The current system primarily analyses message text and does not independently verify URLs, sender identity, or external message metadata.
🔮 Future Scope

Potential improvements include:

Larger and more diverse SMS datasets
TF-IDF feature representation
N-gram features
Additional machine learning algorithms
Model comparison
Cross-validation
ROC curve analysis
Precision-Recall analysis
URL analysis
Sender analysis
Real-time SMS stream processing
Multilingual spam detection
Advanced NLP models
Web deployment
API-based integration
👨‍💻 Project Team
Name	Roll No.
Aniket Adhikari	25901
Anushaa Anjellah	25902
Aneesh Rawle	25903
Advait Bankar	25904
Faculty Guides

Prof. Neha Salunkhe

Prof. Monali Chandwadkar

Head of Department

Prof. Sonali Sherigar

Course

Statistical Modelling for Machine Learning (SML)

🎓 Academic Context

This project was developed as a microproject for the Statistical Modelling for Machine Learning (SML) course.

The project demonstrates practical applications of:

Probability
Bayes' Theorem
Naive Bayes Classification
Natural Language Processing
Statistical Modelling
Data Preprocessing
Model Evaluation
Data Visualization
R Programming
Interactive Application Development
📜 License

This project is licensed under the MIT License.

See the LICENSE file for complete license information.

Note: The MIT License applies to the project code and documentation. Third-party datasets may be subject to their own licensing and usage terms.

⭐ Acknowledgements

We would like to thank our faculty guides and the SML course team for their guidance and support throughout the development of this project.

<p align="center">

<strong>SENTINEL // SMS THREAT ANALYZER</strong>

<br><br>

Built with R • NLP • Multinomial Naive Bayes • R Shiny

<br><br>

<a href="https://github.com/BuiltByAdvait/Spam_Detection_Naive_Bayes"> View Repository </a> </p> ```
