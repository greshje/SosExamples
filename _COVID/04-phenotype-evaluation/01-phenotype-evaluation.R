# ---
#
# 01-phenotype-evaluation.R
#
# ---

# install.packages("remotes")
# remotes::install_github("OHDSI/CohortGenerator")
# remotes::install_github("OHDSI/CohortDiagnostics")
# remotes::install_github("OHDSI/ROhdsiWebApi")
# remotes::install_github("OHDSI/OhdsiShinyModules")

# ---
#
# libraries
#
# ---

library(CohortGenerator)

# --- R Version ---------------------
R.Version()
# --- Java Version ------------------
system("java -version")
# -----------------------------------

#
# functions to get databricks token (user will be prompted for keyring password)
#

getToken <- function () {
  return (
    keyring::backend_file$new()$get(
      service = "databricks",
      user = "token",
      keyring = "databricks_keyring"
    )
  )
}

getUrl <- function () {
  url <- "jdbc:databricks://nachc-databricks.cloud.databricks.com:443/default;transportMode=http;ssl=1;httpPath=sql/protocolv1/o/3956472157536757/0123-223459-leafy532;AuthMech=3;UID=token;PWD="
  return (
    paste(url, getToken(), sep = "")
  )  
}

# ---
#
# variables for the current execution
#
# ---

baseUrl <- "http://localhost:8080/WebAPI"
atlasCohortIds <- c(4,5)

connectionDetails <- DatabaseConnector::createConnectionDetails (
  dbms = "spark",
  connectionString = getUrl(),
  pathToDriver="D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\drivers\\databricks\\"
)

databaseId <- "covid_ohdsi"
cdmDatabaseSchema <- "covid_ohdsi"
cohortDatabaseSchema <- "covid_ohdsi"

dataFolder <- "D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\04-phenotype-evaluation\\output\\covid_ohdsi\\"
incrementalFolder <- paste("incremental_", databaseId, sep="")

# ---
#
# phenotype evaluation implementation
# 
# ---

# set the working directory
setwd(dataFolder)

# get the cohort
cohortDefinitionSet <- ROhdsiWebApi::exportCohortDefinitionSet(
  baseUrl = baseUrl,
  cohortIds = atlasCohortIds,
  generateStats = TRUE
)

# save the cohort
CohortGenerator::saveCohortDefinitionSet(cohortDefinitionSet)

# load the cohort
# cohortDefinitionSet <- CohortGenerator::getCohortDefinitionSet()

# View(cohortDefinitionSet)

cohorTableNames <- getCohortTableNames(cohortTable = "cohort")

library(CohortGenerator)

cohortTableNames <- getCohortTableNames(cohortTable = "cohort")

library(CohortGenerator)

cohortTableNames <- getCohortTableNames(cohortTable = "cohort")

createCohortTables(
  connectionDetails = connectionDetails,
  cohortDatabaseSchema = cohortDatabaseSchema,
  incremental = TRUE
)

generateCohortSet(
  connectionDetails = connectionDetails,
  cohortDefinitionSet = cohortDefinitionSet,
  cohortTableNames = cohortTableNames,
  incremental = TRUE,
  incrementalFolder = incrementalFolder,
  cdmDatabaseSchema = cdmDatabaseSchema
)

library(CohortDiagnostics)

executeDiagnostics(
  cohortDefinitionSet = cohortDefinitionSet,
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = cohortDatabaseSchema,
  cohortTableNames = cohortTableNames,
  exportFolder = file.path(dataFolder,databaseId),
  databaseId = databaseId,
  incremental = TRUE,
  incrementalFolder = incrementalFolder,
  minCellCount = 5,
  runInclusionStatistics = TRUE,
  runIncludedSourceConcepts = TRUE,
  runOrphanConcepts = TRUE,
  runTimeSeries = TRUE,
  runVisitContext = TRUE,
  runBreakdownIndexEvents = FALSE,
  runIncidenceRate = TRUE,
  runCohortRelationship = TRUE,
  runTemporalCohortCharacterization = TRUE
)

sqliteDbPath <- "SOS_STUDY_COVID_HOMELESS.sqlite"

createMergedResultsFile(
  dataFolder = dataFolder, 
  sqliteDbPath = sqliteDbPath
)

launchDiagnosticsExplorer(sqliteDbPath = sqliteDbPath)


