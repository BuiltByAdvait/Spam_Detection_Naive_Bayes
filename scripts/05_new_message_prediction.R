# ============================================
# SPAM DETECTION USING NAIVE BAYES
# Step 5 - New Message Prediction
# ============================================

library(tm)
library(SnowballC)

# Function to preprocess a new message
preprocess_message <- function(message) {
  
  corpus <- VCorpus(
    VectorSource(message)
  )
  
  corpus <- tm_map(
    corpus,
    content_transformer(tolower)
  )
  
  corpus <- tm_map(
    corpus,
    removePunctuation
  )
  
  corpus <- tm_map(
    corpus,
    removeNumbers
  )
  
  corpus <- tm_map(
    corpus,
    removeWords,
    stopwords("english")
  )
  
  corpus <- tm_map(
    corpus,
    stripWhitespace
  )
  
  corpus <- tm_map(
    corpus,
    stemDocument
  )
  
  return(corpus)
}

# Function to predict a new message
predict_message <- function(message) {
  
  # Preprocess message
  cleaned_message <- preprocess_message(message)
  
  # Create DTM using training vocabulary
  new_dtm <- DocumentTermMatrix(
    cleaned_message,
    control = list(
      dictionary = Terms(train_dtm)
    )
  )
  
  # Convert to matrix
  new_matrix <- as.matrix(new_dtm)
  
  # Calculate Ham score
  ham_score <- (
    new_matrix %*% log_ham_prob
  ) + log_ham_prior
  
  # Calculate Spam score
  spam_score <- (
    new_matrix %*% log_spam_prob
  ) + log_spam_prior
  
  # Prediction
  prediction <- ifelse(
    ham_score > spam_score,
    "HAM",
    "SPAM"
  )
  
  return(prediction)
}

# ============================================
# Test New Messages
# ============================================

message1 <- "Congratulations! You have won a free prize. Call now!"
message2 <- "Hey bro, are you coming to college tomorrow?"

print(
  paste(
    "Message 1 Prediction:",
    predict_message(message1)
  )
)

print(
  paste(
    "Message 2 Prediction:",
    predict_message(message2)
  )
)