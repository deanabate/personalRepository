# Text Frequency App

This is an application built in R and R Shiny which performs a simple frequency analysis on a user-supplied text document. To see the application in action, click [here!](https://farmersfridgeanalytics.shinyapps.io/TextApp/) 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need to have installed both [R](https://www.r-project.org/) and the [R Studio IDE](https://rstudio.com/).
You will also need a [shinyapps.io](https://www.shinyapps.io/) account to deploy the application to the web. If you are running on your local machine, then
an account is not necessary.

## Deployment

Deploying this application to the web is a simple process with a shinyapps.io account. You will need to navigate to the script and click on the
"publish application" widget next to the "Run App" widget in the [R Studio IDE](https://rstudio.com/). When the application has been successfully uploaded, you will be able to determine if the deployment was successful.

## Using the Application
1. Input a .txt file of your choice by clicking on the "Browse..." UI element on the page.
2. Choose whether to remove stopwords by selecting "Yes" or keep them in the analysis by selecting "No".
3. To begin the process, click the "Go!" button and a DataTable UI element should appear on the page with the top 25 most frequent words in the analysis.
4. Finally, to download the input file, the output DataTable, and the user selected settings, click the "Download" button.

## Built With

Below are the libraries necessary for proper execution of this program.
* [tidyverse](https://www.tidyverse.org/) - R Packages for Data Science
* [DT](https://rstudio.github.io/DT/) - JavaScript DataTables Library
* [textreadr](https://github.com/trinker/textreadr) - Used to read in text data
* [tidytext](https://www.tidytextmining.com/) - Text Mining with R
* [shiny](https://shiny.rstudio.com/) - Deploy Web Applications using R

## Versioning

This is the first version of the application. I hope to eventually build further upon the current platform and include better logic for various functions and more user-friendly UI elements.

## Authors

* **Dean Abate** - *Initial work* - [Github](https://github.com/deanabate)
* Total Hours Spent: ~9 Hours

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
