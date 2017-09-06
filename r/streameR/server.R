library(rkafka)
library(plotly)
library(lubridate)
library(jsonlite)
library(dplyr)
library(lazyeval)

source('lib//parse.R')

conn_msg <- ""
main_df <<- data.frame(stringsAsFactors = FALSE)

shinyServer(function(input, output, session) {	
	# This function creates the kafka consumer object
	cons <- reactive ({	
		host_string <- paste(
			input$hostname,
			":",
			input$port,
			sep=""
		)
		tryCatch(
			{
				msg <- paste (
					"Connection to",
					host_string,
					"OK",
					sep=" "				
				)
				rkafka.createConsumer(
					host_string, 
					input$topic,
					zookeeperConnectionTimeoutMs=2000					
				)				
			},			 
			error = function(e) {	
				msg <- paste (
					"Connection to",
					host_string,
					"FAILED",
					sep=" "
				)				
				return ("error")
			},
			finally = {					
				log_df 
			}
		)				
	})	
	
	get_data <- reactive ({
		invalidateLater(1000, session)		
		cons <- cons()
		tryCatch(
			{
				msg <- rkafka.read(cons)
				parsed_msg <- switch(input$source_type,
					"JSON" = parse_json(input$source_type, msg),
					"XML" = parse_xml(input$source_type, msg),
					"Flat text" = parse_flat(input$source_type, msg, input$sep_input)
				)
				print(parsed_msg)
				main_df <<- rbind(main_df, parsed_msg)	
				output$err_conn <- renderText({			
					print ("Processing transactions")			
				})
			},
			error = function(e) {
				output$err_conn <- renderText({			
					print ("No message to parse")			
				})					
			},			
			finally = {					
				max_df <- group_by(main_df) %>% summarise_(
					max = interp ( 
						~ max(x), 
						x = as.name(input$timestamp)
					)
				)		
				last_timestamp <- strptime(max_df$max, "%Y-%m-%d %H:%M:%S")		
				main_df <- main_df %>% filter_(
					interp(
						~ as.POSIXlt(x) > as.POSIXlt(last_timestamp - 1*input$ret*60), 
						x = as.name(input$timestamp)
					)
				)
				rkafka.closeConsumer(cons)	
				return (main_df)
			}
		)
	})
	
	observeEvent(input$connect, {		
		cons <- cons()
		print (cons)
		if (cons == "error") {			
			output$err_conn <- renderText({			
				print ("Connection failed. Check the log")			
			})
		} else {	
			tryCatch(
				{
					msg <- rkafka.read(cons)
					print (msg)
					parsed_msg <- switch(input$source_type,
						"JSON" = parse_json(input$source_type, msg),
						"XML" = parse_xml(input$source_type, msg),
						"Flat text" = parse_flat(input$source_type, msg, input$sep_input)
					)
					output$err_conn <- renderText({			
						print ("Connection established")			
					})
				},
				error = function(e) {
					output$err_conn <- renderText({			
						print ("Read consumer error")			
					})					
				},
				finally = {
					rkafka.closeConsumer(cons)	
					print ("Consumer closed")
				}
			)
			
			tryCatch(
				{
					v_measure <- c()
					v_timestamp <- c()
					v_dim <- c()
					field_no <- length(parsed_msg)						
					main_df <<- rbind(main_df, parsed_msg)
					for (i in 1:ncol(parsed_msg)){						
						if (!is.na(as.Date(as.character(parsed_msg[i]),format="%Y-%m-%d"))) {
							v_timestamp <- append (
								v_timestamp, 
								paste(
									"V", 
									i, 
									sep = ""
								)
							)
						} else if (!is.na(as.numeric(parsed_msg[i]))) {
							v_measure <- append (
								v_measure, 
								paste(
									"V", 
									i, 
									sep = ""
								)
							)
						} else {
							v_dim <- append (
								v_dim, 
								paste(
									"V", 
									i, 
									sep = ""
								)
							)
						}						
					}
										
					output$timestamp_list <- renderUI({			
						selectInput(
							"timestamp", 
							"select timestamp (X axys)", 
							choices = v_timestamp
						)
					})
					output$measure_list <- renderUI({			
						selectInput(
							"measure", 
							"select measure (Y axys)", 
							choices = v_measure
						)
					})
					output$dim_list <- renderUI({			
						selectInput(
							"dimension", 
							"select dimension", 
							choices = v_dim
						)
					})					
					output$build_plot <- renderUI({ 
						actionButton("build", label = "Build plots")	
					})
				},
				error = function(e) {
					output$err_conn <- renderText({			
						print ("No message to parse")			
					})					
				}
			)
		}		
	})
#=============================================================
#==================== Dashboard side =========================
#=============================================================	
	observeEvent(input$build, {			
		output$table1 <- renderTable({				
			df <- get_data()			
			tail(df, n = 10)
		})	
		output$plot1 <- renderPlotly ({				
			df <- get_data()
			df <- select_(
				df, 
				.dots = c(
					input$timestamp, 
					input$measure,
					input$dimension		
				)
			)			
			names(df) <- c("timestamp", "measure", "dimension")
			p <- plot_ly(
				data = df, 
				x = timestamp, 
				y = measure,				
				mode = "lines",
				showlegend = FALSE,
				line = list(
					color = "rgb(132, 132, 132)"
				)	
			) 			
			p <- add_trace(	
				data = df, 
				x = timestamp,
				y = measure,
				mode = "markers",				
				color = as.ordered(dimension)
							
			)			
		})
		output$plot2 <- renderPlotly ({
			df<- get_data()
			df <- select_(
				df, 
				.dots = c(
					input$dimension					
				)
			)			
			names(df) <- c("dimension")
			df <- group_by(df, dimension) %>% summarise(count=n())
			p <- plot_ly(
				df,
				x = dimension,
				y = count,	
				color = as.ordered(dimension),
				type = "bar"				
			)
			p
		})
	
		output$valuebox1 <- renderValueBox({
			df<- get_data()
			df <- select_(
				df, 
				.dots = c(
					input$dimension,
					input$timestamp
				)
			)			
			names(df) <- c("dimension", "timestamp")
			count_df <- group_by(df) %>% summarise(count=n())
			max_df <- group_by(df) %>% summarise(count=max(timestamp))
			valueBox(				
				count_df$count, 
				"Transactions", 
				icon = icon("list"),
				color = "yellow"
			)
			
		})	
		
		output$valuebox2 <- renderValueBox({
			df<- get_data()
			df <- select_(
				df, 
				.dots = c(
					input$dimension,
					input$timestamp
				)
			)	
			names(df) <- c("dimension", "timestamp")						
			max_df <- group_by(df) %>% summarise(max=max(timestamp))
			last_timestamp<- strptime(max_df$max, "%Y-%m-%d %H:%M:%S")			
			valueBox(				
				format(last_timestamp, "%H:%M:%S"),				
				format(last_timestamp, "%Y-%m-%d"), 
				icon = icon("clock-o"),
				color = "green"
			)			
		})	
		
		output$valuebox3 <- renderValueBox({
			df<- get_data()
			df <- select_(
				df, 
				.dots = c(
					input$dimension,
					input$timestamp
				)
			)	
			names(df) <- c("dimension", "timestamp")						
			min_df <- group_by(df) %>% summarise(min=min(timestamp))
			first_timestamp<- strptime(min_df$min, "%Y-%m-%d %H:%M:%S")			
			valueBox(				
				format(first_timestamp, "%H:%M:%S"),				
				format(first_timestamp, "%Y-%m-%d"), 
				icon = icon("clock-o"),
				color = "teal"
			)			
		})	
		
		
	})
})