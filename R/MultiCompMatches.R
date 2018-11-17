##Multi Competition Matches Function.
MultiCompMatches <- function(username, password, competitionmatrix){
  strt<-Sys.time()
  cl <- makeCluster(detectCores())
  registerDoParallel(cl)
  events <- tibble()
  for(i in 1:dim(competitionmatrix)[1]){
    matches <- tibble()
    competition_id <- as.numeric(competitionmatrix[i, 1])
    season_id <- as.numeric(competitionmatrix[i, 2])
    matches.url <- paste0("https://data.statsbombservices.com/api/v1/competitions/", competition_id,
                          "/seasons/", season_id, "/matches")
    raw.match.api <- GET(url = matches.url, authenticate(username, password))
    matches.string <- rawToChar(raw.match.api$content)
    matches <- fromJSON(matches.string, flatten = T)
    events <- bind_rows(events, matches)
  }
  stopCluster(cl)
  print(Sys.time()-strt)
  return(events)
}


##Pull Competitions From the API
#comps <- competitions(username, password)
##Filter for the competitions you want
#EuropeComps <- comps %>% filter(country_name == "Europe")
##Create a matrix of the competition and season ids
#competitionmatrix <- as.matrix(EuropeComps[,1:2])
##Pull all of the events.
#Events <- MultiCompMatches(username, password, competitionmatrix)