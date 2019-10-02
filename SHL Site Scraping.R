library(tidyverse)
# library(esquisse)
# library(rvest)
# library(Lahman)
# library(reshape2)
# library(ggthemes)

#this code is more administrative, sets up team names, IDs, lookup tables
#for future functions

#vector for team IDs from SHL.se, used to create distinct URLs

## TODO: find these IDs in an automated fashion
## Renamed to use the site<var> pattern
shlTeamIDs <-
  c(
    "f7c8-f7c8isEb3",
    "1ab8-1ab8bfj7N",
    "2459-2459QTs1f",
    "087a-087aTQv9u",
    "752c-752c12zB7Z",
    "3db0-3db09jXTE",
    "f51e-f51eM6sbL",
    "9541-95418PpkP",
    "41c4-41c4BiYZU",
    "1a71-1a71gTHKh",
    "8e6f-8e6fUXJvi",
    "110b-110bJcIAI",
    "dcba-dcbaXSrRU",
    "259b-259bYGVIp",
    "82eb-82ebmgaJ8",
    "ee93-ee93uy4oW",
    "50e6-50e6DYeWM",
    "936a-936aAY8bT",
    "31d1-31d1NbSlR",
    "fe02-fe02mf1FN"
  )

#vector for SHL.se team names, matching up ID from above to frienldy team name
shlTeamNames <-
  c(
    "AIK",
    "Brynäs",
    "Djurgården",
    "Frölunda",
    "Färjestad",
    "HV71",
    "Karlskrona",
    "Leksand",
    "Linköping",
    "Luleå",
    "Malmö",
    "MODO",
    "Mora",
    "Oskarshamn",
    "Örebro",
    "Rögle",
    "Skellefteå",
    "Södertälje",
    "Timrå",
    "Växjö"
  )

#vector for SweHockey team names, team notation from stats.swehocky.se
sweHockeyTeams <-
  c(
    "AIK",
    "Brynäs IF",
    "Djurgårdens IF",
    "Frölunda HC",
    "Färjestad BK",
    "HV 71",
    "Karlskrona HK",
    "Leksands IF",
    "Linköping HC",
    "Luleå HF",
    "IF Malmö Redhawks",
    "MODO Hockey",
    "Mora IK",
    "IK Oskarshamn",
    "Örebro HK",
    "Rögle BK",
    "Skellefteå AIK",
    "Södertälje SK",
    "Timrå IK",
    "Växjö Lakers HC"
  )

#vector for weird SHL.se names, sometimes team names also appear like this
shlDoubleTeamNames <-
  c(
    "AIKAIK",
    "BrynäsBIF",
    "DjurgårdenDIF",
    "FrölundaFHC",
    "FärjestadFBK",
    "HV71HV71",
    "KarlskronaKHK",
    "LeksandLIF",
    "LinköpingLHC",
    "LuleåLHF",
    "MalmöMIF",
    "MODOMODO",
    "MoraMIK",
    "OskarshamnIKO",
    "ÖrebroÖRE",
    "RögleRBK",
    "SkellefteåSKE",
    "xxx",
    "TimråTIK",
    "VäxjöVLH"
  )

#have to make this one for the team reports

## THIS ONE IS IDENTICAL TO shlDoubleTeamNames
## identical(teamLookup %>% pull(shlDoubleTeamNames), teamLookup %>% pull(shlDoubleTeamNames2))

# shlDoubleTeamNames2 <- c("AIKAIK", "BrynäsBIF", "DjurgårdenDIF", "FrölundaFHC", "FärjestadFBK",
#                         "HV71HV71", "KarlskronaKHK", "LeksandLIF", "LinköpingLHC", "LuleåLHF",
#                         "MalmöMIF", "MODOMODO", "MoraMIK", "OskarshamnIKO", "ÖrebroÖRE",
#                         "RögleRBK", "SkellefteåSKE", "xxx", "TimråTIK", "VäxjöVLH")

#my own abbreviations for naming data frames
shlTeamAbbreviations <-
  c(
    "aik",
    "bif",
    "dif",
    "fhc",
    "fbk",
    "hv",
    "khk",
    "lif",
    "lhc",
    "lhf",
    "mif",
    "modo",
    "mik",
    "iko",
    "ohk",
    "rbk",
    "ske",
    "ssk",
    "tik",
    "vax"
  )

## Slapping these all together at the beginning
## First, getting the objects in the workspace that start with swe or shl
teamObjs <- ls(pattern = '(^swe|^shl)')

## This is a heinous one-liner of base R
## Then turning them into a dataframe > tibble
teamLookup <-
  setNames(data.frame(do.call(cbind, lapply(teamObjs, get))), teamObjs) %>% as_tibble()

#lookup table for SHL.se team names and team IDs

## simplifying to a select
# tibble(shlName = shlTeamNames, teamID = teamIDs)
teamIDLookup <-
  teamLookup %>% select(shlName = shlTeamNames, teamID = shlTeamIDs)

#1819 teams lookup table only (to loop through just those URLs without breaking things)

## Use Left Assignment
## Also can collapse sequences
teamIDLookup_1819 <-
  teamIDLookup %>% slice(2:6, 9:11, 13, 15:17, 19, 20)

# teamIDLookup %>%
#   slice(2, 3, 4, 5, 6, 9, 10, 11, 13, 15, 16, 17, 19, 20) -> teamIDLookup_1819

#same thing as above, but for 15/16 teams
#teamIDLookup_1516 <- teamIDLookup %>% slice(2:7, 9:12, 15:17, 20)

## Converting to `select``
#lookup table for SHL team names and SweHockey team names
# teamNameDictionary <- tibble(shlName = shlTeamNames, sweName = sweHockeyTeams)
teamNameDictionary <-
  teamLookup %>% select(shlName = shlTeamNames, sweName = sweHockeyTeams)

#lookup table for the two SHL.se team names
# shlseNameDictionary <- tibble(Lag = shlDoubleTeamNames, shlName = shlTeamNames)
shlseNameDictionary <-
  teamLookup %>% select(Lag = shlDoubleTeamNames, shlName = shlTeamNames)

#lookup table for the two SHL.se team names, have to make this one for team scrapes
# shlseNameDictionary2 <- tibble(Lag2 = shlDoubleTeamNames2, shlName = shlTeamNames)

#abbreviations I'm using
# shlAbbreviationDictionary <- tibble(Lag = shlTeamNames, Abbreviation = shlAbbreviations)
shlAbbreviationDictionary <-
  teamLookup %>% select(Lag = shlTeamNames, Abbreviation = shlTeamAbbreviations)

#abbreviation for just 18/19 season teams
## left align assignments
shlAbbreviations_1819 <- shlAbbreviationDictionary %>%
  slice(2, 3, 4, 5, 6, 9, 10, 11, 13, 15, 16, 17, 19, 20)


## TODO: swap in get_schedule / get_boxscore function

#read in the 18/19 SHL schedule
#probably need to transform date into an actual date

## GET FROM http://stats.swehockey.se/ScheduleAndResults/Schedule/9171
## see ?read_csv and ?cols for explanation for how to do this in one step
## see ?strptime for format spec in col_date()
shl1819_schedule2 <- read_csv(
  "schedule1819.csv",
  col_types = list(
    "date" = col_date(format = "%m/%d/%y"),
    "homeTeam" = col_character(),
    "awayTeam" = col_character(),
    "combinedTeams" = col_character(),
    "Venue" = col_character()
  )
)

## Re: the below
## this failed b/c of `%Y` which expects `1999`
## as opposed to `%y` which would parse `99`
## --------------------------------------------

# shl1819_schedule <- shl1819_schedule %>%
#   mutate(date2 = as.Date(shl1819_schedule$date, "%m/%d/%Y"))

# shl1819_schedule$date2 <- str_replace_all(shl1819_schedule$date2, '00', '20')

#make it date - I think?
# shl1819_schedule$date2 <- as.Date(shl1819_schedule$date2)
