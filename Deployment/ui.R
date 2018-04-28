
shinyUI(navbarPage(
  "Kickstarter",
  tabPanel("Introduction",
           h2("Landscape of Funding for Kickstarter Campaigns"),
           p("The rise of the internet is rapidly changing the world. The minutia of all sectors of industry seem to be undergoing fundamental mutations, and entrepreneurs in these industries are growing more creative in their attempts to bring their ideas to reality. Crowdsourced funding is a growing trend for entrepreneurs as it delivers the funding they need without sacrificing a stake in their company. Or so that's the general idea. But not all endeavors are funded, and the goal of this project is to learn more about the the projects that achieve their funding goals."),
           p("Kickstarter.com is one of the iconic embodiments of a crowdsourced economy. It was one of the first platforms that created an environment for entrepreneurs to share their ideas, and have their ideas funded. This platform operates through 'campaigns', which are pages where an entrepreneur motivates their project. The specific funding goal, total number of 'backers', and quantity of funding already pledged are described on the campaign page along with the descriptions. Each campaign lasts over a period of 30 - 60 days, and backers pledges are only collected if the project is successfully funded. To date, almost 15 million backers have participated to successfully fund over 140,000 projects."),
           p("Kickstarter's historical precedent for online crowdsourcing and abundance of data from 300,000+ campaigns makes it an ideal case study to explore what factors affect whether or not the crowd economy funds a project. Specifically, our goal for this project is the over landscape of funding for kickstarter, i.e. how different factors relate to a project's success. Additionally, we are interested to discover to what degree we can model and predict the outcome of project campaigns."),
           p("Authors: Ibrahim Taher, Anant Jain, Sarthak Kothari, Forrest Hooton")),
  tabPanel("Exploratory Analysis",
           tabsetPanel(
             tabPanel("Overview",
                      fluidRow( 
                        column(width = 8, h3("Funding Landscape"),
                               plotlyOutput("plot22", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("It seems that only 37% of all projects have been funded")
                        )),
                      fluidRow( 
                        column(width = 8, h3("Percentage Funded"),
                               plotlyOutput("plot23", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Most campaigns didn't get funded at all and some almost did. The second peak shows the number of campaigns which successfully got funded. ")
                        ))
             ),
             tabPanel("Currency/Region",
                      fluidRow( 
                      column(width = 8, h3("Number of Campaigns as per each common Currency"),
                             plotlyOutput("plot7", height= 800)),
                      column(width = 4, h3("Analysis"),
                             p("The plot also shows the proportions of each state under that currency. Judging from the plot, type of currency does not affect successes or failures.")
                      )),
                      fluidRow( 
                        column(width = 8, h3("Number of Campaigns as per each Country in Europe"),
                               plotlyOutput("plot8", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("We see that Germany has the most number campaigns in Europe, but again it seems the trend of less successes continues here.")
                        )),
                      fluidRow(
                        column(width = 8, h3("Number of Campaigns as per each State in US"),
                               plotlyOutput("plot9", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("We see that California has the most number campaigns in US, but again it seems the trend of less successes continues here too but New York looks like an exception here, I guess, dreams do come true in New York.")
                        ))
                      ),
             tabPanel("Category",
                      fluidRow(  
                        column(width = 8, h3("Number of Campaigns as per each Category"),
                               plotlyOutput("plot10", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Most Number of Campaigns are under Film and Music.")
                        )),
                      fluidRow(  
                        column(width = 8, h3("Proportion of Successful Campaigns as per each Category"),
                               plotlyOutput("plot13", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Dance, Theatre and Comics seem to have most succcesses.")
                        )),
                      fluidRow( 
                        column(width = 8, h3("Proportion of Failed Campaigns as per each Category"),
                               plotlyOutput("plot14", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Journalism, Food and Fashion seems to have most failures.")
                        )),
                      fluidRow( 
                        column(width = 8, h3("Proportion of Cancelled Campaigns as per each Category"),
                               plotlyOutput("plot15", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Technology and Games seems to have most proportion of cancellations.")
                        )),
                      fluidRow( 
                        column(width = 8, h3("Average Percent Funded"),
                               plotlyOutput("plot19", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("The mean percentage funding for Games and Comics turns out to be more than 600%")
                        )),
                      fluidRow( 
                        column(width = 4, h3("Almost Funded"),
                               plotlyOutput("plot20", height= 800)),
                        column(width = 4, h3("Over-Funded"),
                               plotlyOutput("plot21", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Looks like Games and design are mostly overe-funded. Therefore, Category definitely helps in judging the landscape of funding for KS campaigns")
                        ))
             ),
             tabPanel("Time Period",
                      fluidRow( 
                        column(width = 8, h3("Number of Campaigns launched each Year by Month"),
                               plotlyOutput("plot11", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Looks like earlier the no. of Campaigns increased as we progressed with the year, but now we can see the most no. of Campaigns are at the start and then decreases. Therre seems to be slight spike in July though. Summer Interships probably.")
                        )),
                      fluidRow( 
                        column(width = 8, h3("Proportion of Status of Campaigns each Year by Month"),
                               plotlyOutput("plot12", height= 800)),
                        column(width = 4, h3("Analysis"),
                               p("Looks like trend changed in 2017")
                        ))
             )
           )
           ),
  tabPanel("Text Analysis",
           sidebarLayout(
             sidebarPanel(
               fluidRow(
               radioButtons("radio1", label = h3("Campaign Outcome: "),
                            choices = list("Successful" = 'successful', "Failed" = 'failed'),
                            selected = 'successful'))),
             mainPanel(
               tabsetPanel(
               tabPanel("Word Map", 
                        column(width = 12,
                               plotOutput("plot6", height= 800)
                        )),
               tabPanel("Word Count", 
                        column(width = 12,
                               fluidRow("By Country",
                               plotlyOutput("plot1", height= 800)),hr(),
                               fluidRow("By Category",
                               plotlyOutput("plot2", height= 800))
                        )),
               tabPanel("Word Importance", 
                        column(width = 12,
                               fluidRow("By Country",
                                 plotlyOutput("plot3", height= 800)),hr(),
                               fluidRow("By Category",
                                 plotlyOutput("plot4", height= 800))
                        )),
               tabPanel("Bigram Importance",
                        column(width = 12,
                               fluidRow("By Country",
                                        plotlyOutput("plot16", height= 800)),hr(),
                               fluidRow("By Category",
                                        plotlyOutput("plot17", height= 800))
                        )),
               tabPanel("Sentiment Analysis",
                        column(width = 12,
                               fluidRow("Sentiment Score by Country",
                                        plotlyOutput("plot18_", height=800)),
                               fluidRow("Sentiment Score by Category",
                                        plotlyOutput("plot18", height=800)))
             ))
           )
          )),
  tabPanel("Live Prediction",
           sidebarLayout(
             sidebarPanel(
               fluidRow(
                 selectInput("cat", label = h3("Category: "), 
                             choices = categories, 
                             selected = 1)),
               fluidRow(
                 numericInput("bac", label = h3("Backers Gained: "), value = 1)),
               fluidRow(
                 radioButtons("spo", label = h3("Spotlight: "),
                              choices = list("YES" = TRUE, "NO" = FALSE),
                              selected = FALSE)),
               fluidRow(
                 sliderInput("mon", label = h3("Month: "), min = 1, 
                             max = 12, value = 1)),
               fluidRow(
                 sliderInput("yea", label = h3("Year: "), min = 2000, 
                             max = 2020, value = 2018)),
               fluidRow(
                 numericInput("dl", label = h3("Days Live: "), value = 10))
               ),
             mainPanel(
               tabsetPanel(
                 id = 'prediction',
                 tabPanel("Live Prediction", 
                          column(width = 8,
                                 fluidRow("Result: ",
                                          verbatimTextOutput("p1"))
                          )),
                 tabPanel("Variable Importance", 
                          column(width = 8,
                                 fluidRow(plotlyOutput("plot5", height= 800))
                          ))
               )
             )
           )
           )
)
)
