#Create each 18/19 teams' schedule
#Definitely should create a function to do this and loop through
#instead of manually doing each teams'


# for each team, get the games where that team was home or away
# add a new team name (shlTeamName) based on home|away Team (sweTeamName)
# calculate game number
# add a _schedule column based on shlTeamName and the date2 (now date)
get_team_schedule <- function(sweTeamName) {
  shl1819_schedule %>%
    mutate(scheduleTeam = sweTeamName) %>%
    filter(homeTeam == sweTeamName | awayTeam == sweTeamName) %>%
    left_join(
      teamLookup %>% select(shlScheduleTeam = shlTeamNames, sweHockeyTeams),
      by = c("scheduleTeam" = "sweHockeyTeams")
    ) %>%
    arrange(date) %>% 
    mutate(gameNumber = row_number(),
           team_date = paste0(shlScheduleTeam, date)) %>%
    select(date,
           homeTeam,
           awayTeam,
           combinedTeams,
           Venue,
           date,
           gameNumber,
           team = shlScheduleTeam,
           team_date) 
}

# will be useful for mapping later
team_schedules_list <-
  map(sort(teamLookup$sweHockeyTeams), get_team_schedule) %>%
  set_names(sort(teamLookup$sweHockeyTeams))
  
# more patrical way to look at the data
team_schedules_df <- team_schedules_list %>%
  bind_rows(.id = 'sweTeam')

# 
# #Brynäs
# bif1819_schedule <- subset(shl1819_schedule, grepl("Brynäs IF", shl1819_schedule$combinedTeams))
# 
# bif1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Brynäs") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> bif1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Djurgården
# dif1819_schedule <- subset(shl1819_schedule, grepl("Djurgårdens IF", shl1819_schedule$combinedTeams))
# 
# dif1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Djurgården") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> dif1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Frölunda
# fhc1819_schedule <- subset(shl1819_schedule, grepl("Frölunda HC", shl1819_schedule$combinedTeams))
# 
# fhc1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Frölunda") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> fhc1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Färjestad
# fbk1819_schedule <- subset(shl1819_schedule, grepl("Färjestad BK", shl1819_schedule$combinedTeams))
# 
# fbk1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Färjestad") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> fbk1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #HV71
# hv1819_schedule <- subset(shl1819_schedule, grepl("HV 71", shl1819_schedule$combinedTeams))
# 
# hv1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "HV71") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> hv1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Linköping
# lhc1819_schedule <- subset(shl1819_schedule, grepl("Linköping HC", shl1819_schedule$combinedTeams))
# 
# lhc1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Linköping") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> lhc1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Luleå
# lhf1819_schedule <- subset(shl1819_schedule, grepl("Luleå HF", shl1819_schedule$combinedTeams))
# 
# lhf1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Luleå") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> lhf1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Malmö
# mif1819_schedule <- subset(shl1819_schedule, grepl("Malmö Redhawks", shl1819_schedule$combinedTeams))
# 
# mif1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Malmö") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> mif1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Mora
# mik1819_schedule <- subset(shl1819_schedule, grepl("Mora IK", shl1819_schedule$combinedTeams))
# 
# mik1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Mora") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> mik1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Örebro
# ohk1819_schedule <- subset(shl1819_schedule, grepl("Örebro HK", shl1819_schedule$combinedTeams))
# 
# ohk1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Örebro") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> ohk1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Rögle
# rbk1819_schedule <- subset(shl1819_schedule, grepl("Rögle BK", shl1819_schedule$combinedTeams))
# 
# rbk1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Rögle") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> rbk1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Skellefteå
# ske1819_schedule <- subset(shl1819_schedule, grepl("Skellefteå AIK", shl1819_schedule$combinedTeams))
# 
# ske1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Skellefteå") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> ske1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Timrå
# tik1819_schedule <- subset(shl1819_schedule, grepl("Timrå IK", shl1819_schedule$combinedTeams))
# 
# tik1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Timrå") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> tik1819_schedule
# 
# #--------------------------------------------------------------------
# 
# #Växjö
# vax1819_schedule <- subset(shl1819_schedule, grepl("Växjö Lakers", shl1819_schedule$combinedTeams))
# 
# vax1819_schedule %>%
#   mutate(gameNumber = row_number()) %>%
#   mutate(team = "Växjö") %>%
#   mutate(team_date = paste(team, date2, sep = '')) -> vax1819_schedule

