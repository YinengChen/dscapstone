library(shiny)
library(tidyverse)
library(stringi)
library(tidyverse)
library(stringr)

############################
### 1.  read word pools ###
###########################

n_2 = read_csv('./grams/n2_grams.csv')
n_3 = read_csv('./grams/n3_grams.csv')
n_4 = read_csv('./grams/n4_grams.csv')
n_5 = read_csv('./grams/n5_grams.csv')

#####################################
###2. Function to clean sentance ###
####################################

Clean_Sentences <- function(text_blob) {
    # swap all sentence ends with code 'ootoo'
    text_blob <- gsub(pattern=';|\\.|!|\\?', x=text_blob, replacement='ootoo')
    
    # remove all non-alpha text (numbers etc)
    text_blob <- gsub(pattern="[^[:alpha:]]", x=text_blob, replacement = ' ')
    # remove Non-English Words
    text_blob <- iconv(text_blob,"latin1","ASCII",sub = "")
    
    # force all characters to lower case
    text_blob <- tolower(text_blob)
    
    # remove any small words {size} or {min,max}
    # text_blob <- gsub(pattern="\\W*\\b\\w{1,2}\\b", x=text_blob, replacement=' ')
    
    # Restore instances of e.g. "can't" when not appropriately converted   
    text_blob <- gsub("\u0092", "'", text_blob)
    text_blob <- gsub("\u0093|\u0094", "", text_blob)
    
    # To avoid the conversion of e.g. "U.S."" to "us"
    text_blob <- gsub(pattern="U.S.A.| U.S.A | U.S | U.S.| U S | U.S | u s | u.s | u.s.a |united states |United States", x=text_blob, replacement='USA')
    
    # remove contiguous spaces
    text_blob <- gsub(pattern = "\\s+", x=text_blob, replacement=' ')
    
    # split sentences by split code
    sentence_vector <- unlist(strsplit(x=text_blob, split='ootoo',fixed = TRUE))
    return(sentence_vector)
}



#######################################
### 3.  function ot get last words ###
#######################################

Get_last_words = function(sentance){
    word = Clean_Sentences(sentance) 
    sentence_split<- strsplit(word," ")[[1]]
    
    for (i in c(1,2,3,4)) {
        last_words = tail(sentence_split,i) 
        if(i==1) {
            last_1word =paste0(last_words[1]," ") 
        } else if(i==2) {
            last_2words =paste0(last_words[1]," ",last_words[2]," ")
        } else if(i==3) {
            last_3words = paste0(last_words[1]," ",last_words[2],
                                 " ",last_words[3]," ")
        } else if(i==4) {
            last_4words = paste0(last_words[1]," ",last_words[2],
                                 " ",last_words[3]," ",last_words[4]," ")
        }
        
    }
    
    last_nwords = c(last_4words,last_3words,last_2words,last_1word)
    
    return(last_nwords)
}

##################################################
### 4. Function to get next word in a given pool #
##################################################

next_word_n = function(a_word,all_element){
    
    ## 1. find exact matches
    matches <- c()
    for (sentence in all_element) {
        # find exact match with double backslash and escape
        if (grepl(paste0('\\<',a_word), sentence)) {
            # print(sentence)
            matches <- c(matches, sentence)
        }
    }
    
    
    if (is.null(matches)){
        return('a')
    }
    
    ## 2. extract the second part after key words in all matches
    next_part_match <- c()
    for (a_match in matches) {
        next_part_match <- c(next_part_match,
                             strsplit(x = a_match, split = a_word)[[1]][[2]])
        next_part_match =  raster::trim(next_part_match)
    }
    
    
    
    #3.  split second part by spaces and pick first word
    next_word_match = c()
    for(a_part in next_part_match){
        if (str_count(a_part, '\\w+') == 1){
            next_word_match <- c(next_word_match,a_part)
        } else {
            next_word_match <- c(next_word_match,
                                 strsplit(x = a_part, split = " ")[[1]][[1]]) 
        }
    }
    
    ##4.  count the frequency of all next words  
    word_count = aggregate(data.frame(count = next_word_match), 
                           list(value = next_word_match), length)
    ##5.  find the word appear most frequently
    word_maxcount = sample(word_count$value[word_count$count == max(word_count$count)], size = 1) 
    
    word_maxcount
}

##################################################
## 5. Function to get next word given sentence ###
##################################################

next_word = function(sentence){
    
    word = Clean_Sentences(sentence) 
    sentence_split<- strsplit(word," ")[[1]]
    qwords<-length(sentence_split)
    last_words = Get_last_words(sentence)
    
    if(qwords ==1) { ##use bigram find out next_word
        all_element <- c()
        for (sentence in n_2) {all_element <- c(all_element, sentence)}                
        next_word_list<-next_word_n(last_words[4],all_element)
    }  else if(qwords==2) { ##use trigram find out next_word
        all_element <- c()
        for (sentence in n_3) {all_element <- c(all_element, sentence)} 
        next_word_list<-next_word_n(last_words[3],all_element)
    }else if(qwords == 3) {
        all_element <- c()
        for (sentence in n_4) {all_element <- c(all_element, sentence)} 
        next_word_list<-next_word_n(last_words[2],all_element)
    } else if(qwords >= 4) {
        all_element <- c()
        for (sentence in n_5) {all_element <- c(all_element, sentence)}
        next_word_list<-next_word_n(last_words[1],all_element)
    }
    
    return(next_word_list)
}

########################################
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$value <- renderPrint({ 
        sentence = paste0(input$text, " ")
        next_word(sentence)
        })

})
