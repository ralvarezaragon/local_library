library(rkafka)

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
        msg <- paste(
                i,
                Sys.time() + 2*60*60 ,
                sample(brand,1),
                round(runif(1,50,160),1),
                sep = "|"
        )
        rkafka.send(prod,"collectd","sandbox.hortonworks.com:6667",msg)
        Sys.sleep(5)
}

rkafka.closeProducer(prod)
