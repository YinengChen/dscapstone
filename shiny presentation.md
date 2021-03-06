Natural Language Processing: Predicting the next Word
========================================================
author: Yineng Chen
date: 8/4/2020
autosize: true

Project Overview
========================================================

This is a capstone project for Data Science Specialization, a 10-course sequence developed by John Hopkins University, available in Coursera. The data used in this project was given by SwiftKey company. 


<img src="./Swiftkey/pics/JHU-Logo.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="30%" height="30%" /><img src="./Swiftkey/pics/coursera.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="30%" height="30%" />

Natural Language Processing Model
========================================================
**Packages Used in this project**

- readtext: To read in different types of text data 
- quanteda:  Quantitative text analysis 
- ngram: An n-gram Babbler
- shiny: Web Application Framework for R

**How the data set looks**

The data set is provided by SwiftKey,which includs text from blogs, news and twitter. The text was sampled randomly to built the model. 




How the model works
========================================================
- The next word is predicted based on the previous 1, 2, or 3 words, which is known as N-Gram model, with N=2,3,4,5.

- The probability of a word to appear next is calculated using text sampled from text pools given by SwiftKey. The text pools includs blogs, news and twitter.

- The algorithm try to use the higher N-gram, if it fails it uses the N-1 grams.

- The word 'a' is used when there are no hint for guessing of no pattern is.


Shiny application
========================================================
- The shiny application is available in: https://yinengchen1024.shinyapps.io/DS_capstone_project_Swiftkey/
- You can also download it from github repository:  https://github.com/YinengChen/dscapstone

**Instructions to run it**
- Enter the sentence in the box, clikc "Predict next word..." button. The app will show the next word predicted.

<img src="./Swiftkey/pics/app.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="40%" height="40%" />

