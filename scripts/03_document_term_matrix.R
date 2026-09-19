# ============================================
# SPAM DETECTION USING NAIVE BAYES
# Step 3 - Document-Term Matrix
# ============================================

# Create Document-Term Matrix for training data
train_dtm <- DocumentTermMatrix(train_corpus)

# Create Document-Term Matrix for testing data
test_dtm <- DocumentTermMatrix(test_corpus)

# Display dimensions
dim(train_dtm)
dim(test_dtm)

# Display first few terms
inspect(train_dtm[1:5, 1:10])

# ============================================
# Align Test DTM with Training DTM
# ============================================

# Find terms that are present in training data
common_terms <- intersect(
  Terms(train_dtm),
  Terms(test_dtm)
)

# Keep only common terms
train_dtm <- train_dtm[, common_terms]
test_dtm <- test_dtm[, common_terms]

# Check dimensions again
dim(train_dtm)
dim(test_dtm)

length(common_terms)
ncol(train_dtm)
ncol(test_dtm)