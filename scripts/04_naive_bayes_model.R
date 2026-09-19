# ============================================
# SPAM DETECTION USING NAIVE BAYES
# Step 4 - Multinomial Naive Bayes Model
# ============================================

# Convert DTM to matrices
train_matrix <- as.matrix(train_dtm)
test_matrix <- as.matrix(test_dtm)

# Training labels
train_labels <- train_data$Label

# Classes
classes <- levels(train_labels)

# Number of terms
num_terms <- ncol(train_matrix)

# Laplace smoothing
alpha <- 1

# Calculate prior probabilities
class_counts <- table(train_labels)
priors <- class_counts / sum(class_counts)

# Calculate word counts for each class
ham_word_counts <- colSums(
  train_matrix[train_labels == "ham", , drop = FALSE]
)

spam_word_counts <- colSums(
  train_matrix[train_labels == "spam", , drop = FALSE]
)

# Total words in each class
ham_total_words <- sum(ham_word_counts)
spam_total_words <- sum(spam_word_counts)

# Calculate conditional probabilities with Laplace smoothing
ham_word_prob <- (
  ham_word_counts + alpha
) / (
  ham_total_words + alpha * num_terms
)

spam_word_prob <- (
  spam_word_counts + alpha
) / (
  spam_total_words + alpha * num_terms
)

# Use log probabilities to avoid numerical underflow
log_ham_prob <- log(ham_word_prob)
log_spam_prob <- log(spam_word_prob)

log_ham_prior <- log(priors["ham"])
log_spam_prior <- log(priors["spam"])

# Calculate log posterior scores for test messages
ham_scores <- (
  test_matrix %*% log_ham_prob
) + log_ham_prior

spam_scores <- (
  test_matrix %*% log_spam_prob
) + log_spam_prior

# Classify each message
predictions <- ifelse(
  ham_scores > spam_scores,
  "ham",
  "spam"
)

predictions <- factor(
  predictions,
  levels = classes
)

# Display first few predictions
head(predictions)

# ============================================
# Model Evaluation
# ============================================

# Confusion Matrix
confusion_matrix <- table(
  Actual = test_data$Label,
  Predicted = predictions
)

print(confusion_matrix)

# Accuracy
accuracy <- sum(diag(confusion_matrix)) /
  sum(confusion_matrix)

print(
  paste(
    "Accuracy =",
    round(accuracy * 100, 2),
    "%"
  )
)

# ============================================
# Precision, Recall and F1-Score
# ============================================

true_positive <- confusion_matrix["spam", "spam"]
false_positive <- confusion_matrix["ham", "spam"]
false_negative <- confusion_matrix["spam", "ham"]

precision <- true_positive /
  (true_positive + false_positive)

recall <- true_positive /
  (true_positive + false_negative)

f1_score <- 2 * (
  precision * recall
) / (
  precision + recall
)

print(paste(
  "Precision =",
  round(precision * 100, 2),
  "%"
))

print(paste(
  "Recall =",
  round(recall * 100, 2),
  "%"
))

print(paste(
  "F1-Score =",
  round(f1_score * 100, 2),
  "%"
))

# ============================================
# Confusion Matrix Visualization
# ============================================

library(ggplot2)

# Convert confusion matrix to data frame
cm_data <- as.data.frame(confusion_matrix)

colnames(cm_data) <- c(
  "Actual",
  "Predicted",
  "Count"
)

# Create confusion matrix plot
ggplot(cm_data, aes(x = Predicted, y = Actual, fill = Count)) +
  geom_tile(color = "white") +
  geom_text(
    aes(label = Count),
    size = 6
  ) +
  labs(
    title = "Confusion Matrix - Naive Bayes",
    x = "Predicted Class",
    y = "Actual Class"
  ) +
  scale_fill_gradient(
    low = "lightblue",
    high = "blue"
  ) +
  theme_classic()

ggsave(
  "plots/confusion_matrix.png",
  width = 7,
  height = 5,
  dpi = 300
)

# ============================================
# Model Performance Visualization
# ============================================

performance_data <- data.frame(
  Metric = c(
    "Accuracy",
    "Precision",
    "Recall",
    "F1-Score"
  ),
  Score = c(
    accuracy,
    precision,
    recall,
    f1_score
  )
)

ggplot(
  performance_data,
  aes(x = Metric, y = Score)
) +
  geom_col(fill = "skyblue") +
  geom_text(
    aes(label = paste0(round(Score * 100, 2), "%")),
    vjust = -0.5,
    size = 5
  ) +
  scale_y_continuous(
    limits = c(0, 1),
    labels = scales::percent
  ) +
  labs(
    title = "Naive Bayes Model Performance",
    x = "Evaluation Metric",
    y = "Score"
  ) +
  theme_classic()

ggsave(
  "plots/model_performance.png",
  width = 8,
  height = 5,
  dpi = 300
)