# ============================================
# SPAM DETECTION USING NAIVE BAYES
# Step 1 - Data Loading and Verification
# ============================================

# Load SMS Spam Dataset
data <- read.delim(
  "data/SMSSpamCollection",
  header = FALSE,
  sep = "\t",
  quote = "",
  stringsAsFactors = FALSE
)

# Rename columns
colnames(data) <- c("Label", "Message")

# View first few records
head(data)

# Check structure
str(data)

# Check total number of messages
nrow(data)

# Count Ham and Spam messages
table(data$Label)

# Check missing values
sum(is.na(data$Label))
sum(is.na(data$Message))

# ============================================
# Exploratory Data Analysis
# ============================================

# Display dataset summary
summary(data)

# Calculate percentage of Ham and Spam
label_percentage <- prop.table(table(data$Label)) * 100

print(label_percentage)

# ============================================
# Spam vs Ham Distribution
# ============================================
library(ggplot2)

label_data <- data.frame(
  Label = names(table(data$Label)),
  Count = as.numeric(table(data$Label))
)

ggplot(label_data, aes(x = Label, y = Count, fill = Label)) +
  geom_col() +
  labs(
    title = "Spam vs Ham Message Distribution",
    x = "Message Type",
    y = "Number of Messages"
  ) +
  theme_classic() +
  theme(legend.position = "none")

# Save Spam vs Ham Distribution Plot
ggsave(
  "plots/spam_vs_ham_distribution.png",
  width = 8,
  height = 5,
  dpi = 300
)