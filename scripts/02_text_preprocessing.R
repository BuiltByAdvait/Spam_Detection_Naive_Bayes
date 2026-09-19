# ============================================
# SPAM DETECTION USING NAIVE BAYES
# Step 2 - Text Preprocessing
# ============================================

# Install packages if required
# install.packages("tm")
# install.packages("SnowballC")

library(tm)
library(SnowballC)

# Convert labels to factors
data$Label <- factor(data$Label)

# Set seed for reproducibility
set.seed(123)

# Split data into training and testing sets
sample_index <- sample(
  1:nrow(data),
  size = 0.80 * nrow(data)
)

train_data <- data[sample_index, ]
test_data <- data[-sample_index, ]

# Check sizes
nrow(train_data)
nrow(test_data)

# Create text corpora
train_corpus <- VCorpus(
  VectorSource(train_data$Message)
)

test_corpus <- VCorpus(
  VectorSource(test_data$Message)
)

# Text preprocessing function
clean_text <- function(corpus) {
  
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

# Apply preprocessing
train_corpus <- clean_text(train_corpus)
test_corpus <- clean_text(test_corpus)

# Display a few cleaned messages
inspect(train_corpus[1:5])

# Display actual cleaned text
for (i in 1:5) {
  print(as.character(train_corpus[[i]]))
}