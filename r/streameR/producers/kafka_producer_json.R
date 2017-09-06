library(rkafka)
library(jsonlite)

brand <- c(
        "Renault",
        "Fiat",
        "Mercedes",
        "Audi",
        "Ford",
        "Citroen"
)

prod <- rkafka.createProducer("sandbox.hortonworks.com:6667")
i <- 0
while (1==1) {
        i = i + 1       
		msg <- list(
			timestamp=Sys.time() + 2*60*60,
			name=sample(brand,1),
			speed=round(runif(1,100,160),1)
		)
		msg1 <- toJSON(msg, flatten = TRUE)
        rkafka.send(prod,"collectd","sandbox.hortonworks.com:6667",msg1)
		print (msg1)
        Sys.sleep(1)
}

rkafka.closeProducer(prod)