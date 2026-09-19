# ============================================================
# SENTINEL // SMS THREAT ANALYZER
# Interactive Spam Detection System
# Multinomial Naive Bayes + Shiny
# ============================================================

library(shiny)
library(tm)
library(SnowballC)

# ============================================================
# TEXT PREPROCESSING
# ============================================================

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

# ============================================================
# CLASSIFICATION ENGINE
# ============================================================

classify_message <- function(message) {
  
  cleaned_message <- preprocess_message(message)
  
  new_dtm <- DocumentTermMatrix(
    cleaned_message,
    control = list(
      dictionary = Terms(train_dtm)
    )
  )
  
  new_matrix <- as.matrix(new_dtm)
  
  ham_score <- as.numeric(
    (new_matrix %*% log_ham_prob) +
      log_ham_prior
  )
  
  spam_score <- as.numeric(
    (new_matrix %*% log_spam_prob) +
      log_spam_prior
  )
  
  # Convert log scores into normalized scores
  
  max_score <- max(
    ham_score,
    spam_score
  )
  
  ham_exp <- exp(
    ham_score - max_score
  )
  
  spam_exp <- exp(
    spam_score - max_score
  )
  
  total <- ham_exp + spam_exp
  
  ham_probability <- ham_exp / total
  spam_probability <- spam_exp / total
  
  prediction <- ifelse(
    spam_probability > ham_probability,
    "SPAM",
    "HAM"
  )
  
  # Classification confidence indicator
  confidence <- max(
    ham_probability,
    spam_probability
  )
  
  
  # Explainability layer: detect common suspicious SMS keywords
  suspicious_terms <- c(
    "otp", "password", "pin", "prize", "winner", "won",
    "claim", "urgent", "click", "verify", "verification",
    "account", "bank", "reward", "offer", "free", "cash",
    "lottery", "transfer", "fee", "congratulations", "selected"
  )
  
  message_lower <- tolower(message)
  
  matched_terms <- suspicious_terms[
    sapply(
      suspicious_terms,
      function(term) grepl(
        paste0("\\b", term, "\\b"),
        message_lower,
        perl = TRUE
      )
    )
  ]
  
  matched_terms <- unique(matched_terms)
  
  if (confidence >= 0.90) {
    
    threat_level <- "HIGH CONFIDENCE"
    
  } else if (confidence >= 0.70) {
    
    threat_level <- "MODERATE CONFIDENCE"
    
  } else {
    
    threat_level <- "LOW CONFIDENCE / REVIEW"
  }
  
  list(
    prediction = prediction,
    ham_probability = ham_probability,
    spam_probability = spam_probability,
    confidence = confidence,
    threat_level = threat_level,
    indicators = matched_terms
  )
}

# ============================================================
# USER INTERFACE
# ============================================================

ui <- fluidPage(
  
  tags$head(
    
    tags$style(HTML("

      body {
        background-color: #080b0d;
        color: #d8f3dc;
        font-family: 'Courier New', monospace;
      }

      .container-fluid {
        padding: 25px 35px;
      }

      .terminal-header {
        background: #0d1117;
        border: 1px solid #00ff88;
        border-radius: 8px;
        padding: 20px 28px;
        margin-bottom: 20px;
        box-shadow: 0 0 20px rgba(0,255,136,0.12);
      }

      .terminal-title {
        color: #00ff88;
        font-size: 28px;
        font-weight: bold;
        letter-spacing: 2px;
      }

      .terminal-subtitle {
        color: #6ee7b7;
        font-size: 13px;
        margin-top: 6px;
      }

      .status-online {
        color: #00ff88;
        font-weight: bold;
      }

      .panel-box {
        background: #0d1117;
        border: 1px solid #1f2933;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 0 10px rgba(0,255,136,0.04);
      }

      .panel-title {
        color: #00ff88;
        font-size: 15px;
        font-weight: bold;
        letter-spacing: 1px;
        border-bottom: 1px solid #1f2933;
        padding-bottom: 10px;
        margin-bottom: 15px;
      }

      textarea {
        background-color: #050708 !important;
        color: #d8f3dc !important;
        border: 1px solid #00ff88 !important;
        border-radius: 6px !important;
        font-family: 'Courier New', monospace !important;
        font-size: 15px !important;
      }

      textarea:focus {
        box-shadow: 0 0 12px rgba(0,255,136,0.25) !important;
      }

      .btn {
        font-family: 'Courier New', monospace;
        font-weight: bold;
        border-radius: 5px;
        margin-right: 8px;
      }

      .btn-primary {
        background: #003b24;
        border: 1px solid #00ff88;
        color: #00ff88;
      }

      .btn-primary:hover {
        background: #00ff88;
        color: #050708;
      }

      .btn-default {
        background: #111820;
        border: 1px solid #374151;
        color: #9ca3af;
      }

      .btn-default:hover {
        background: #1f2937;
        color: white;
      }

      .stat-box {
        background: #050708;
        border: 1px solid #1f2933;
        border-radius: 6px;
        padding: 12px;
        margin-bottom: 10px;
      }

      .stat-label {
        color: #6b7280;
        font-size: 11px;
        text-transform: uppercase;
      }

      .stat-value {
        color: #00ff88;
        font-size: 20px;
        font-weight: bold;
      }

      .result-spam {
        background: #160708;
        border: 1px solid #ff3344;
        border-radius: 8px;
        padding: 25px;
        text-align: center;
        box-shadow: 0 0 20px rgba(255,51,68,0.15);
      }

      .result-spam h2 {
        color: #ff3344;
        font-weight: bold;
        letter-spacing: 3px;
      }

      .result-ham {
        background: #06150d;
        border: 1px solid #00ff88;
        border-radius: 8px;
        padding: 25px;
        text-align: center;
        box-shadow: 0 0 20px rgba(0,255,136,0.15);
      }

      .result-ham h2 {
        color: #00ff88;
        font-weight: bold;
        letter-spacing: 3px;
      }

      .probability-bar {
        height: 22px;
        background: #111820;
        border-radius: 4px;
        overflow: hidden;
        margin-top: 5px;
        margin-bottom: 15px;
      }

      .ham-bar {
        height: 100%;
        background: #00ff88;
      }

      .spam-bar {
        height: 100%;
        background: #ff3344;
      }

      .prob-label {
        color: #9ca3af;
        font-size: 12px;
      }

      .threat-high {
        color: #ff3344;
        font-weight: bold;
        font-size: 18px;
      }

      .threat-moderate {
        color: #ffaa00;
        font-weight: bold;
        font-size: 18px;
      }

      .threat-low {
        color: #00bfff;
        font-weight: bold;
        font-size: 18px;
      }

      .log-box {
        background: #050708;
        border: 1px solid #1f2933;
        border-radius: 6px;
        padding: 15px;
        color: #6ee7b7;
        font-size: 12px;
        line-height: 1.9;
      }


      .indicator-chip {
        display: inline-block;
        background: #17090a;
        color: #ff6675;
        border: 1px solid #ff3344;
        border-radius: 4px;
        padding: 5px 9px;
        margin: 3px 5px 3px 0;
        font-size: 11px;
        font-weight: bold;
      }

      .indicator-safe {
        display: inline-block;
        background: #06150d;
        color: #00ff88;
        border: 1px solid #00ff88;
        border-radius: 4px;
        padding: 5px 9px;
        font-size: 11px;
        font-weight: bold;
      }
      
      .reason-box {
        background: #050708;
        border: 1px solid #1f2933;
        border-left: 3px solid #00ff88;
        border-radius: 6px;
        padding: 16px;
        color: #9ca3af;
        font-size: 13px;
        line-height: 1.7;
      }
      
      .reason-title {
        color: #00ff88;
        font-weight: bold;
        margin-bottom: 8px;
        letter-spacing: 1px;
      }
      
      .reason-spam {
        color: #ff6675;
        font-weight: bold;
      }
      
      .reason-ham {
        color: #00ff88;
        font-weight: bold;
      }
      
      .reason-stat {
        color: #d8f3dc;
        font-weight: bold;
      }
      
      .reason-warning {
        color: #ffaa00;
        font-weight: bold;
      }

      .confidence-meter {
        height: 10px;
        background: #111820;
        border-radius: 5px;
        overflow: hidden;
        margin: 8px 0 12px 0;
      }

      .confidence-fill {
        height: 100%;
        background: linear-gradient(90deg, #00bfff, #00ff88);
      }

      .history-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 11px;
      }

      .history-table th {
        color: #00ff88;
        text-align: left;
        border-bottom: 1px solid #1f2933;
        padding: 7px;
      }

      .history-table td {
        color: #9ca3af;
        border-bottom: 1px solid #111820;
        padding: 7px;
        vertical-align: top;
      }

      .history-spam {
        color: #ff3344 !important;
        font-weight: bold;
      }

      .history-ham {
        color: #00ff88 !important;
        font-weight: bold;
      }

      .footer {
        color: #374151;
        text-align: center;
        font-size: 11px;
        margin-top: 20px;
        padding: 10px;
      }

    "))
  ),
  
  # ==========================================================
  # HEADER
  # ==========================================================
  
  div(
    class = "terminal-header",
    
    div(
      class = "terminal-title",
      "◉ SENTINEL // SMS THREAT ANALYZER"
    ),
    
    div(
      class = "terminal-subtitle",
      
      HTML(
        "MULTINOMIAL NAIVE BAYES ENGINE &nbsp;|&nbsp;
         MODEL STATUS:
         <span class='status-online'>● ONLINE</span>"
      )
    )
  ),
  
  # ==========================================================
  # MAIN LAYOUT
  # ==========================================================
  
  fluidRow(
    
    # ========================================================
    # SYSTEM STATUS
    # ========================================================
    
    column(
      width = 3,
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-title",
          "// SYSTEM STATUS"
        ),
        
        div(
          class = "stat-box",
          div(
            class = "stat-label",
            "Model"
          ),
          div(
            class = "stat-value",
            "NAIVE BAYES"
          )
        ),
        
        div(
          class = "stat-box",
          div(
            class = "stat-label",
            "Dataset"
          ),
          div(
            class = "stat-value",
            "5,574"
          )
        ),
        
        div(
          class = "stat-box",
          div(
            class = "stat-label",
            "Training"
          ),
          div(
            class = "stat-value",
            "4,459"
          )
        ),
        
        div(
          class = "stat-box",
          div(
            class = "stat-label",
            "Testing"
          ),
          div(
            class = "stat-value",
            "1,115"
          )
        ),
        
        div(
          class = "stat-box",
          div(
            class = "stat-label",
            "Accuracy"
          ),
          div(
            class = "stat-value",
            "98.12%"
          )
        ),
        
        div(
          class = "stat-box",
          div(
            class = "stat-label",
            "F1 Score"
          ),
          div(
            class = "stat-value",
            "93.07%"
          )
        ),
        
        
        div(
          class = "stat-box",
          
          div(
            class = "stat-label",
            "Analyses"
          ),
          
          div(
            class = "stat-value",
            textOutput("analysis_count", inline = TRUE)
          )
        )
      )
    ),
    
    # ========================================================
    # ANALYZER
    # ========================================================
    
    column(
      width = 9,
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-title",
          "// MESSAGE ANALYSIS TERMINAL"
        ),
        
        textAreaInput(
          "message",
          NULL,
          rows = 5,
          width = "100%",
          placeholder =
            ">> Enter SMS payload for threat analysis..."
        ),
        
        br(),
        
        actionButton(
          "predict",
          "⚡ ANALYZE MESSAGE",
          class = "btn-primary"
        ),
        
        actionButton(
          "sample_spam",
          "⚠ TEST SPAM"
        ),
        
        actionButton(
          "sample_ham",
          "✓ TEST HAM"
        ),
        
        actionButton(
          "clear",
          "⌫ CLEAR"
        )
      ),
      
      # ======================================================
      # RESULT
      # ======================================================
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-title",
          "// CLASSIFICATION RESULT"
        ),
        
        uiOutput(
          "prediction"
        )
      ),
      
      # ======================================================
      # PROBABILITIES
      # ======================================================
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-title",
          "// THREAT PROBABILITY ANALYSIS"
        ),
        
        uiOutput(
          "probabilities"
        )
      ),
      
      # ======================================================
      # THREAT LEVEL
      # ======================================================
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-title",
          "// THREAT LEVEL"
        ),
        
        uiOutput(
          "threat_level"
        )
      ),
      
      # ======================================================
      # ANALYSIS TRACE
      # ======================================================
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-title",
          "// ANALYSIS TRACE"
        ),
        
        uiOutput(
          "system_log"
        )
      )
    )
  ),
  
  
  div(
    class = "panel-box",
    
    div(
      class = "panel-title",
      "// THREAT INDICATORS"
    ),
    
    uiOutput("threat_indicators")
  ),
  
  div(
    class = "panel-box",
    
    div(
      class = "panel-title",
      "// WHY WAS THIS FLAGGED?"
    ),
    
    uiOutput("classification_reason")
  ),
  
  div(
    class = "panel-box",
    
    div(
      class = "panel-title",
      "// RECENT ANALYSIS LOG"
    ),
    
    uiOutput("analysis_history")
  ),
  
  div(
    class = "footer",
    "SENTINEL SMS THREAT ANALYZER // R + SHINY + MULTINOMIAL NAIVE BAYES"
  )
)

# ============================================================
# SERVER
# ============================================================

server <- function(input, output, session) {
  
  # ==========================================================
  # SAMPLE SPAM
  # ==========================================================
  
  observeEvent(
    input$sample_spam,
    {
      
      updateTextAreaInput(
        session,
        "message",
        
        value =
          "Congratulations! You have won a free prize. Click now to claim your reward!"
      )
    }
  )
  
  # ==========================================================
  # SAMPLE HAM
  # ==========================================================
  
  observeEvent(
    input$sample_ham,
    {
      
      updateTextAreaInput(
        session,
        "message",
        
        value =
          "Hey bro, are you coming to college tomorrow?"
      )
    }
  )
  
  # ==========================================================
  # CLEAR
  # ==========================================================
  
  observeEvent(
    input$clear,
    {
      
      updateTextAreaInput(
        session,
        "message",
        value = ""
      )
      result(NULL)
      
    }
  )
  
  # ==========================================================
  
  # ==========================================================
  # ANALYSIS STATE
  # ==========================================================
  
  result <- reactiveVal(NULL)
  
  analysis_counter <- reactiveVal(0)
  
  analysis_history <- reactiveVal(
    data.frame(
      Time = character(),
      Message = character(),
      Prediction = character(),
      Confidence = numeric(),
      stringsAsFactors = FALSE
    )
  )
  
  # ==========================================================
  # CLASSIFICATION
  # ==========================================================
  
  observeEvent(
    input$predict,
    {
      
      req(
        nchar(
          trimws(input$message)
        ) > 0
      )
      
      analysis_result <- classify_message(
        input$message
      )
      
      result(analysis_result)
      
      analysis_counter(
        analysis_counter() + 1
      )
      
      history <- analysis_history()
      
      new_entry <- data.frame(
        Time = format(
          Sys.time(),
          "%H:%M:%S"
        ),
        Message = substr(
          gsub(
            "\\s+",
            " ",
            trimws(input$message)
          ),
          1,
          60
        ),
        Prediction = analysis_result$prediction,
        stringsAsFactors = FALSE
      )
      
      analysis_history(
        head(
          rbind(new_entry, history),
          5
        )
      )
    }
  )
  
  # ==========================================================
  # ANALYSIS COUNTER
  # ==========================================================
  
  output$analysis_count <- renderText({
    analysis_counter()
  })
  
  # CLASSIFICATION RESULT
  # ==========================================================
  
  output$prediction <- renderUI({
    
    req(result())
    
    if (
      result()$prediction == "SPAM"
    ) {
      
      div(
        class = "result-spam",
        
        h2(
          "⚠ THREAT DETECTED // SPAM"
        ),
        
        p(
          "Classification engine has identified this message as SPAM."
        )
      )
      
    } else {
      
      div(
        class = "result-ham",
        
        h2(
          "✓ MESSAGE CLEARED // HAM"
        ),
        
        p(
          "Classification engine has identified this message as legitimate."
        )
      )
    }
  })
  
  # ==========================================================
  # PROBABILITY BARS
  # ==========================================================
  
  output$probabilities <- renderUI({
    
    req(result())
    
    ham <- result()$ham_probability * 100
    spam <- result()$spam_probability * 100
    
    tagList(
      
      div(
        class = "prob-label",
        
        paste(
          "HAM PROBABILITY:",
          round(ham, 2),
          "%"
        )
      ),
      
      div(
        class = "probability-bar",
        
        div(
          class = "ham-bar",
          
          style = paste0(
            "width:",
            ham,
            "%;"
          )
        )
      ),
      
      div(
        class = "prob-label",
        
        paste(
          "SPAM PROBABILITY:",
          round(spam, 2),
          "%"
        )
      ),
      
      div(
        class = "probability-bar",
        
        div(
          class = "spam-bar",
          
          style = paste0(
            "width:",
            spam,
            "%;"
          )
        )
      )
    )
  })
  
  # ==========================================================
  # THREAT LEVEL
  # ==========================================================
  
  output$threat_level <- renderUI({
    
    req(result())
    
    confidence <- result()$confidence
    level <- result()$threat_level
    
    if (confidence >= 0.90) {
      
      div(
        class = "threat-high",
        
        "⚠ HIGH CONFIDENCE CLASSIFICATION"
      )
      
    } else if (confidence >= 0.70) {
      
      div(
        class = "threat-moderate",
        
        "◈ MODERATE CONFIDENCE CLASSIFICATION"
      )
      
    } else {
      
      div(
        class = "threat-low",
        
        "◎ LOW CONFIDENCE // MANUAL REVIEW RECOMMENDED"
      )
    }
    
    br()
    
    p(
      paste(
        "Classification score:",
        round(
          confidence * 100,
          2
        ),
        "%"
      )
    )
    
    p(
      paste(
        "Status:",
        level
      )
    )
  })
  
  # ==========================================================
  
  # ==========================================================
  # THREAT INDICATORS
  # ==========================================================
  
  output$threat_indicators <- renderUI({
    
    req(result())
    
    indicators <- result()$indicators
    
    if (length(indicators) == 0) {
      
      div(
        class = "indicator-safe",
        "✓ NO OBVIOUS SUSPICIOUS KEYWORDS DETECTED"
      )
      
    } else {
      
      tagList(
        div(
          style = "margin-bottom: 8px; color: #9ca3af; font-size: 12px;",
          paste(
            length(indicators),
            "indicator(s) detected:"
          )
        ),
        
        lapply(
          indicators,
          function(term) {
            span(
              class = "indicator-chip",
              paste0("!", toupper(term))
            )
          }
        )
      )
    }
  })
  
  # ==========================================================
  # CLASSIFICATION EXPLANATION
  # ==========================================================
  
  output$classification_reason <- renderUI({
    
    req(result())
    
    prediction <- result()$prediction
    confidence <- result()$confidence
    indicators <- result()$indicators
    
    confidence_percent <- round(confidence * 100, 2)
    
    if (prediction == "SPAM") {
      
      if (length(indicators) > 0) {
        
        indicator_text <- paste(
          toupper(indicators),
          collapse = ", "
        )
        
        div(
          class = "reason-box",
          
          div(
            class = "reason-title",
            "⚠ MODEL DECISION"
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-spam'>",
                "SPAM DETECTED",
                "</span>"
              )
            )
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-stat'>Confidence:</span> ",
                confidence_percent,
                "%"
              )
            )
          ),
          
          p(
            paste(
              "Suspicious indicators detected:",
              indicator_text
            )
          ),
          
          p(
            "These terms are commonly associated with promotional,",
            "financial, verification, or potentially deceptive SMS messages."
          )
        )
        
      } else {
        
        div(
          class = "reason-box",
          
          div(
            class = "reason-title",
            "⚠ MODEL DECISION"
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-spam'>SPAM DETECTED</span>"
              )
            )
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-stat'>Confidence:</span> ",
                confidence_percent,
                "%"
              )
            )
          ),
          
          p(
            "The Naive Bayes model classified this message as SPAM",
            "based on the learned word-frequency patterns in the training data."
          ),
          
          p(
            class = "reason-warning",
            "No obvious suspicious keyword was detected by the rule-based indicator layer."
          )
        )
      }
      
    } else {
      
      if (length(indicators) == 0) {
        
        div(
          class = "reason-box",
          
          div(
            class = "reason-title",
            "✓ MODEL DECISION"
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-ham'>MESSAGE CLEARED // HAM</span>"
              )
            )
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-stat'>Confidence:</span> ",
                confidence_percent,
                "%"
              )
            )
          ),
          
          p(
            "No obvious suspicious keywords were detected.",
            "The Naive Bayes model identified the message as similar",
            "to legitimate messages in the training data."
          )
        )
        
      } else {
        
        div(
          class = "reason-box",
          
          div(
            class = "reason-title",
            "✓ MODEL DECISION"
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-ham'>MESSAGE CLEARED // HAM</span>"
              )
            )
          ),
          
          p(
            HTML(
              paste0(
                "<span class='reason-stat'>Confidence:</span> ",
                confidence_percent,
                "%"
              )
            )
          ),
          
          p(
            "Some potentially suspicious terms were detected,",
            "but the overall Naive Bayes probability favored HAM."
          ),
          
          p(
            class = "reason-warning",
            paste(
              "Detected indicators:",
              paste(toupper(indicators), collapse = ", ")
            )
          )
        )
      }
    }
  })
  
  # ==========================================================
  # ANALYSIS HISTORY
  # ==========================================================
  
  output$analysis_history <- renderUI({
    
    history <- analysis_history()
    
    if (nrow(history) == 0) {
      
      div(
        class = "log-box",
        "[WAITING] No messages analyzed yet..."
      )
      
    } else {
      
      rows <- paste0(
        apply(
          history,
          1,
          function(row) {
            
            prediction_class <- if (
              row[["Prediction"]] == "SPAM"
            ) {
              "history-spam"
            } else {
              "history-ham"
            }
            
            paste0(
              "<tr>",
              "<td>", htmltools::htmlEscape(row[["Time"]]), "</td>",
              "<td>", htmltools::htmlEscape(row[["Message"]]), "</td>",
              "<td class='", prediction_class, "'>",
              htmltools::htmlEscape(row[["Prediction"]]),
              "</td>",
              "<td>",
              htmltools::htmlEscape(
                paste0(row[["Confidence"]], "%")
              ),
              "</td>",
              "</tr>"
            )
          }
        ),
        collapse = ""
      )
      
      HTML(
        paste0(
          "<table class='history-table'>",
          "<thead><tr>",
          "<th>TIME</th>",
          "<th>MESSAGE</th>",
          "<th>CLASS</th>",
          "<th>CONFIDENCE</th>",
          "</tr></thead>",
          "<tbody>",
          rows,
          "</tbody>",
          "</table>"
        )
      )
    }
  })
  
  # ANALYSIS TRACE
  # ==========================================================
  
  output$system_log <- renderUI({
    
    req(result())
    
    tagList(
      
      div(
        class = "log-box",
        
        HTML(
          paste0(
            
            "[OK] PAYLOAD RECEIVED",
            "<br>",
            
            "[OK] TEXT PREPROCESSING COMPLETE",
            "<br>",
            
            "[OK] TOKENIZATION COMPLETE",
            "<br>",
            
            "[OK] VOCABULARY MATCH COMPLETE",
            "<br>",
            
            "[OK] BAYES SCORES CALCULATED",
            "<br>",
            
            "[OK] HAM VS SPAM COMPARISON COMPLETE",
            "<br>",
            
            "[OK] CLASSIFICATION: ",
            result()$prediction,
            "<br>",
            
            "[OK] CONFIDENCE: ",
            round(
              result()$confidence * 100,
              2
            ),
            "%",
            "<br>",
            
            "[OK] THREAT ANALYSIS COMPLETE"
          )
        )
      )
    )
  })
}

# ============================================================
# START APPLICATION
# ============================================================

shinyApp(
  ui = ui,
  server = server
)
