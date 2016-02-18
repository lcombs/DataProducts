library(magrittr)
library(data.table)
library(tm)
library(ggplot2)
library(wordcloud)
library(memoise)
library(SnowballC)


cc <<- 
        read.csv("Consumer_Complaints.csv", 
                 header = TRUE, na.strings = c("")) %>%
        as.data.table()

# names(cc)
# object.size(cc)
# head(cc)

cc[, Date.received := 
           as.Date(Date.received, 
                   format = "%m/%d/%Y")]

cc[, Date.sent.to.company := 
           as.Date(Date.sent.to.company , 
                   format = "%m/%d/%Y")]

cc[, Consumer.complaint.narrative := 
           as.character(Consumer.complaint.narrative)]

cc[, Consumer.complaint.narrative := 
           as.character(Consumer.complaint.narrative)]

# 
# table(cc$Product) %>%
#         barplot()
# 
# table(cc$Issue) %>%
#         barplot()
# 
# table(cc$Timely.response.)
# 
# range(cc$Date.received)
# 
# setkey(cc, Date.received)
# 
# plot(cc[, .N, 
#         by = Date.received], 
#      type = "l", 
#      lwd = 4, ylim = c(0, 1000),
#      col = "dark green", 
#      main = "Recent Consumer Complaints Over Time", 
#      xlab = "Date", 
#      ylab = "Number of Complaints")
# 
# setkey(cc, Date.sent.to.company)
# 
# lines(cc[, .N, 
#          by = Date.sent.to.company], 
#       type = "l",
#       lwd = 2,
#       col = "green")
# 
# legend("topright", 
#        c("Date Received", "Date Sent to Company"), 
#        lty = 1, 
#        col = c("dark green", "green"))

# Text Mining

# looking at just 2016 so far...
cc <<- 
        cc[Date.received > "2015-12-31"]

getTermMatrix <- memoise(function(product){
        
        text <- cc[Product == product]
        
        myCorpus <- 
                Corpus(VectorSource(text[, Consumer.complaint.narrative]  %>% 
                                            na.omit()))
        # clean up the docs
        
        myCorpus <- 
                tm_map(myCorpus, 
                       removePunctuation)
        
        myCorpus <- 
                tm_map(myCorpus, 
                       removeNumbers)
        
        myCorpus <- 
                tm_map(myCorpus, 
                       content_transformer(tolower))
        
        myCorpus <- 
                tm_map(myCorpus, 
                       removeWords,
                       stopwords("english"))
        
        myCorpus <- 
                tm_map(myCorpus, 
                       stemDocument)
        
        dtm <- 
                DocumentTermMatrix(myCorpus, 
                                   control = list(wordLengths = c(0, Inf)))
        
        # multiple Xs denote undisclosed information - delete these
        
        dtm <- 
                dtm[, -grep("xx+", dtm$dimnames$Terms)]
        
        # remove any NAs
        
        sort(colSums(as.matrix(dtm), na.rm = TRUE), decreasing = TRUE)
        
        
})