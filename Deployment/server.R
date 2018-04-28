

# install.packages(plotly, tidyverse, tidytext, ranger, modelr, wordcloud, shiny)
# devtools::install_github('hadley/ggplot2')

library(plotly)
library(tidyverse)
library(tidytext)
library(ranger)
library(modelr)
library(wordcloud)
library(shiny)
load(".RData")

# train <- ks %>% sample_frac(.75)
# test  <- anti_join(ks, train, by = 'ID')
# train <- train %>%
#   select(main_category, backers_count, country, goal, pledged, spotlight, status, Month, Year, days_live, perc_funded)
# test <- test %>%
#   select(main_category, backers_count, country, goal, pledged, spotlight, status, Month, Year, days_live, perc_funded)
# train <- train %>%
#   filter(status == "successful" | status == "failed")
# test <- test %>%
#   filter(status == "successful" | status == "failed")
# testx <- test %>% select(-status)
# testy <- test %>% select(status)
# rm(test)

# rf <- ranger(status ~ main_category + backers_count + spotlight + Month + Year + days_live,
#              data = train,
#              write.forest = TRUE,
#              importance = "impurity")
# 
# pred = predict(rf, testx)
# pred = pred$predictions
# accuracy = mean(pred == testy$status)


predr <- function(bac, cat, spo, mon, yea, dl, pled){
  df <- data_frame(main_category = cat, backers_count = bac, spotlight = spo, Month = mon, Year= yea, days_live = dl)
  p <- predict(rf, df)
  return(p$predictions)
}

shinyServer(function(input, output, session) {
  #Word Count
  output$plot1 <-renderPlotly({
    ggplotly(tidyTextKS %>%
      filter(status==input$radio1) %>%
      mutate(stemmed =factor(stemmed, levels =rev(unique(stemmed)))) %>%
      group_by(country,stemmed) %>%
      summarise(count=n()) %>%
      arrange(desc(count)) %>%
      filter(count>30) %>%
      top_n(10) %>%
      ungroup() %>%
      ggplot() + geom_col(mapping = aes(x=stemmed, y=count, fill=country),
                          show.legend = FALSE) +
      labs(x = NULL, y = "n") + facet_grid(~country, scales='free') + coord_flip())
  })
    output$plot2 <-renderPlotly({
      ggplotly(tidyTextKS %>%
        filter(status==input$radio1) %>%
        mutate(stemmed =factor(stemmed, levels =rev(unique(stemmed)))) %>%
        group_by(main_category,stemmed) %>%
        summarise(count=n()) %>%
        arrange(desc(count)) %>%
        filter(count>30) %>%
        top_n(10) %>%
        ungroup() %>%
        ggplot() + geom_col(mapping = aes(x=stemmed, y=count, fill=main_category),
                            show.legend = FALSE) +
        labs(x = NULL, y = "n") + facet_grid(~main_category, scales='free') + coord_flip())
       })
  
  #Word Importance
  output$plot3 <-renderPlotly({
    ggplotly(tidyTextKS %>%
      filter(status==input$radio1) %>%
      mutate(stemmed =factor(stemmed, levels =rev(unique(stemmed)))) %>%
      group_by(country,stemmed) %>%
      summarise(count=n()) %>%
      bind_tf_idf(stemmed, country, count) %>%
      arrange(desc(tf_idf)) %>%
      top_n(5) %>%
      ungroup() %>%
      ggplot() + geom_col(mapping = aes(x=stemmed, y=tf_idf, fill=country),
                          show.legend = FALSE) +
      labs(x = NULL, y = "n") + facet_grid(~country, scales='free') + coord_flip())
    })
  output$plot4 <-renderPlotly({
    ggplotly(tidyTextKS %>%
        filter(status==input$radio1) %>%
        mutate(stemmed =factor(stemmed, levels =rev(unique(stemmed)))) %>%
        group_by(main_category,stemmed) %>%
        summarise(count=n()) %>%
        bind_tf_idf(stemmed, main_category, count) %>%
        arrange(desc(tf_idf)) %>%
        top_n(5) %>%
        ungroup() %>%
        ggplot() + geom_col(mapping = aes(x=stemmed, y=tf_idf, fill=main_category),
                            show.legend = FALSE) +
        labs(x = NULL, y = "n") + facet_grid(~main_category, scales='free') + coord_flip())
  })
  output$plot5 <-renderPlotly({
    ggplotly(data.frame(as.list(rf$variable.importance)) %>% gather() %>% 
      ggplot(aes(x = reorder(key, value), y = value)) +
      geom_bar(stat = "identity", width = 0.6, fill = "grey") +
      coord_flip() +
      theme_minimal() +
      theme(axis.title.y = element_blank()) )
  })
  output$p1 <- renderPrint({ 
    predr(input$bac, input$cat, input$spo, input$mon, input$yea, input$dl)
    })
  output$plot6 <-renderPlot({
    corpus <- tidyTextKS %>%
      filter(status==input$radio1) %>%
      select(word)
    wordcloud(corpus$word, max.words=400)
  })

  output$plot7 <-renderPlotly({
    ks <- ks %>%
      filter(currency == "USD" | currency == "GBP" | currency == "EUR" | currency == "CAD" | currency == "AUD")

    ggplotly(ggplot(ks, aes(x = currency, fill = status)) +
      geom_bar() +
      coord_flip() +
        ggtitle("Number of Campaigns as per each common Currency"))
  })
  output$plot8 <-renderPlotly({
    ggplotly(ks %>%
      group_by(country,currency,status) %>%
      summarise(n = n()) %>%
      filter(currency == "EUR") %>%
      ggplot(aes(x=country, y=n, fill=status)) +
      geom_col() +
      coord_flip()+         ggtitle("Number of Campaigns as per each Country in Europe"))
  })
  
  output$plot9 <-renderPlotly({
    ggplotly(ks %>%
      filter(country == "US") %>%
      group_by(state_province, status) %>%
      summarise(n = n()) %>%
      filter(n>500) %>%
      ggplot(aes(x=state_province, y=n, fill=status)) +
      geom_col() +
      coord_flip()+         ggtitle("Number of Campaigns as per each State in US"))
  })
  output$plot10 <-renderPlotly({
    ggplotly(ks %>%
      group_by(main_category, status) %>%
      summarise(n = n()) %>%
      ggplot(aes(x=main_category, y=n, fill=status)) +
      geom_col() +
      coord_flip()+         ggtitle("Number of Campaigns as per each Category"))
  })

  output$plot11 <-renderPlotly({
    ggplotly(ks %>%
      group_by(Year, Month, status) %>%
      summarise(n = n()) %>%
      ggplot(aes(x=Month, y=n, fill=status)) +
      geom_col() +
      coord_flip() +
      ggtitle("Number of Campaigns launched each Year by Month") +
      facet_grid(~Year, scales = "free"))
  })
  output$plot12 <-renderPlotly({
    ggplotly(ks %>%
      filter(status == "canceled" | status == "failed" | status == "successful" ) %>%
      group_by(status, Year) %>%
      summarise(n = n()) %>%
      ggplot() +
      geom_col(aes(status,n)) +
      facet_grid(~Year))
  })
  output$plot13 <- renderPlotly({
    df1 <- ks %>%
      group_by(main_category) %>%
      summarise(n = n())

    df2 <- ks %>%
      filter(status == "successful") %>%
      group_by(main_category) %>%
      summarise(n = n())

    df2$prop <- df2$n/df1$n
    
    plot_ly(x = df2$main_category, y = df2$prop, type = 'bar')
  })
  output$plot14 <- renderPlotly({
    df3 <- ks %>%
      filter(status == "failed") %>%
      group_by(main_category) %>%
      summarise(n = n())

    df3$prop <- df3$n/df1$n
    
    plot_ly(x = df3$main_category, y = df3$prop, type = 'bar')
  })
  output$plot15 <- renderPlotly({
    df4 <- ks %>%
      filter(status == "canceled") %>%
      group_by(main_category) %>%
      summarise(n = n())

    df4$prop <- df4$n/df1$n
    
    plot_ly(x = df4$main_category, y = df4$prop, type = 'bar')
  })
  
  #bigram country tf-idf
  output$plot16<-renderPlotly({
    ggplotly(tidyTextKSBigramsNoStop %>%
      unite(stemmed, stem1, stem2, sep=" ") %>%
      filter(status==input$radio1) %>%
      group_by(country,stemmed) %>%
      summarise(count=n()) %>% 
      bind_tf_idf(stemmed, country, count) %>%
      arrange(desc(tf_idf)) %>%
      top_n(5) %>%
      ungroup() %>%
      ggplot() + geom_col(mapping = aes(x=stemmed, y=tf_idf, fill=country),
                          show.legend = FALSE) +
      labs(x = NULL, y = "n") + facet_grid(~country, scales='free') + coord_flip())
  })

#bigrams tf-idf category
output$plot17 <-renderPlotly({
  ggplotly(tidyTextKSBigramsNoStop %>%
    unite(stemmed, stem1, stem2, sep=" ") %>%
    filter(status==input$radio1) %>%
    group_by(main_category,stemmed) %>%
    summarise(count=n()) %>% 
    bind_tf_idf(stemmed, main_category, count) %>%
    arrange(desc(tf_idf)) %>%
    top_n(5) %>%
    ungroup() %>%
    ggplot() + geom_col(mapping = aes(x=stemmed, y=tf_idf, fill=main_category),
                        show.legend = FALSE) +
    labs(x = NULL, y = "n") + facet_grid(~main_category, scales='free') + coord_flip())
})

# sentiments <- sentimentBigrams %>%
#   count(word1, score1, country, main_category, status, sort = TRUE) %>%
#   ungroup() %>%
#   arrange(desc(n)) %>%
#   mutate(word1 = reorder(word1, n)) %>%
#   mutate(contribution = n * score1) %>%
#   arrange(desc(abs(contribution))) %>%
#   mutate(word1 = reorder(word1, contribution))
output$plot18 <-renderPlotly({
  ggplotly(sentiments %>%
             filter(contribution != 0 & status == input$radio1) %>%
             top_n(100, wt=abs(contribution)) %>%
             ggplot(aes(word1, contribution, fill = contribution > 0)) +
             geom_col(show.legend = FALSE) +
             facet_grid(~main_category, scales="free") +
             coord_flip())
})
output$plot18_ <-renderPlotly({
ggplotly(sentiments %>%
           filter(contribution != 0 & status == input$radio1) %>%
           top_n(100, wt=abs(contribution)) %>%
           ggplot(aes(word1, contribution, fill = contribution > 0)) +
           geom_col(show.legend = FALSE) +
           facet_grid(~country, scales="free") +
           coord_flip())
})

output$plot19 <- renderPlotly({
  ks  %>%
    group_by(main_category) %>%
    summarise(p = mean(perc_funded)) %>%
    plot_ly(x = ~main_category, y = ~p, type = 'bar')
})

output$plot20 <- renderPlotly({
  ks  %>%
    filter(perc_funded<1 & perc_funded>0.9) %>%
    group_by(main_category) %>%
    summarise(n = n()) %>%
    plot_ly(labels = ~main_category, values = ~n, type = 'pie')
})

output$plot21 <- renderPlotly({
  ks  %>%
    filter(perc_funded>3) %>%
    group_by(main_category) %>%
    summarise(n = n()) %>%
    plot_ly(labels = ~main_category, values = ~n, type = 'pie')
})

output$plot22 <- renderPlotly({
  ks %>%
    group_by(status) %>%
    summarise(n = n()) %>%
    plot_ly(labels = ~status, values = ~n, type = 'pie')
})

output$plot23 <- renderPlotly({
  ggplotly(ks  %>%
    filter(perc_funded < 3) %>%
    ggplot() + geom_histogram(aes(perc_funded), bins =50) +
    ggtitle("Percentage Funded"))
})

})
