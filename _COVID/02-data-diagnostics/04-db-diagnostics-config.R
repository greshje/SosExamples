# ---
#
# 04-db-diagnostics-config.R
#
# ---

# --- R Version ---------------------
R.Version()
# --- Java Version ------------------
system("java -version")
# -----------------------------------"

# first set your output location
outputFolder <- "D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\output\\NACHC_DEMO_DB_OHDSI\\dbDiagnosticsOuput-EUNOMIA"

# create the settings for the study

homelessConcepts <- c(
  4053088,4147554,40519180,44794577,40519187,44812921,40329696,21498856,4139934,40299198,
  3552499,3552820,3552819,3553101,8672,42628011,44788302,44788283,4019973,40299199,4190815,
  4307308,4192297,4307307,4193277,40299200,4052051,35225199,36309593,36310234,36662349,
  35609191,42690497,45765559,44810341,3560142,40329696,3557438,40318572,4091008,4137393,
  4144274,3557354,40299203,4058157,37079289,44831984
)

notHomelessConcepts <- c(
  45877171,4059641,4052321,44804220,37079501,36311105,4046991,36308356,36308730,40329714,
  40299805,40300329,36309786,40545298,40299223,4052157,46285980,3561367,44802044,4019978,
  4019977,4207170,2618142,2618143
  
)

analysisSettings1 <- DbDiagnostics::createDataDiagnosticsSettings(
  analysisId = 1,
  analysisName = "Homelessness and COVID Vaccination Rate",
  minAge = 18,
  maxAge = NULL,
  genderConceptIds = NULL,
  raceConceptIds = NULL,
  ethnicityConceptIds = NULL,
  studyStartDate = "201901",
  studyEndDate = "202301",
  requiredDurationDays = 365,
  requiredDomains = c("condition","drug"),
  desiredDomains = NULL,
  requiredVisits = NULL,
  desiredVisits = c("IP"),
  targetName = "Homeless",
  targetConceptIds = homelessConcepts,
  comparatorName = "Not Homeless",
  comparatorConceptIds = notHomelessConcepts,
  outcomeName = "At least One COVID Vaccination",
  outcomeConceptIds = c()
)

# IMPORTANT! You need to pass a list of all settings to the executeDbDiagnostics function. It is common for this function to 
# be used to evaluate multiple studies at one time so you need to add them all to one list like below, even if you only have
# one analysis.

settingsList <- list(analysisSettings1)

