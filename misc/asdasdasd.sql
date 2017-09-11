INSERT INTO `esme_numbers_storage`.`hlr_storage` (
`msisdn`, `timestamp`, `daystamp`, `monthstamp`, `network`, `checked`, `callback`, `application`, `targetstack`, `oldnetwork`, `state`, `location`, `countryname`, `countrycode`, `organisation`, `networkname`, `networktype`, `ported`, `method`) VALUES (33666846914,1505126619,1505080800,1504216800,20801,0,0,0,0,0,2,null,'France','FRA','Orange France','Orange F','GSM 900/1800','yes','passthrough') ON DUPLICATE KEY UPDATE `oldnetwork`=`network`, `timestamp`=1505126619, `daystamp`=1505080800, `monthstamp`=1504216800,`network`=20801, `checked`=0, `state`=2, `ported`='yes', `method`='passthrough'



