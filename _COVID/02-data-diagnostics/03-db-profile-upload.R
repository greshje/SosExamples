# ---
#
# 03-db-profile-upload.R
#
# ---

#
# Versions of R and Java
#

# --- R Version ---------------------
R.Version()
# --- Java Version ------------------
system("java -version")
# -----------------------------------"

#
# functions to get databricks token (user will be prompted for keyring password) and url with token as password
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
# start configuration
#
# ---

# set the location of the results that were generated from executeDbProfile
resultsLocation <- "D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\output\\NACHC_DEMO_DB_OHDSI\\20190525"
metaDataFileRelLocation <- "\\..\\NACHC_DEMO_DB_OHDSI_metadata.csv"
cdmSourceRelLocation <- "\\NACHC_DEMO_DB_OHDSI_20190525_cdm_source.csv"

# create the connectionDetails for the database where the results should be uploaded. It is likely this will be different than the database where the dbProfile was run
connectionDetails <- DatabaseConnector::createConnectionDetails (
  dbms = "spark",
  connectionString = getUrl(),
  pathToDriver="D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\drivers\\databricks\\"
)

# set the achilles results schema
resultsSchema <- "demo_cdm_ach_res"

# ---
#
# end configuration
#
# ---

# set a parameter detailing if the DQD was run
addDQD <- FALSE

# add dbId and prep output files for writing into the results schema
db_profile_results <- read.csv(paste0(resultsLocation,"/db_profile_results.csv"), stringsAsFactors = F, colClasses = c("stratum1"="character"))

# make sure the columns are read in as characters to facilitate dbDiagnostics execution
db_profile_results$STRATUM_1 <- as.character(db_profile_results$stratum1)
db_profile_results$STRATUM_2 <- as.character(db_profile_results$stratum2)
db_profile_results$STRATUM_3 <- as.character(db_profile_results$stratum3)
db_profile_results$STRATUM_4 <- as.character(db_profile_results$stratum4)
db_profile_results$STRATUM_5 <- as.character(db_profile_results$stratum5)

# read in the metadata

db_metadata <- read.csv(paste0(resultsLocation, metaDataFileRelLocation), stringsAsFactors = F)

# read in the cdm_source table

db_cdm_source <- read.csv(paste0(resultsLocation,cdmSourceRelLocation), stringsAsFactors = F)

# determine which tables should be uploaded based on if the DQD was included
if (addDQD) {
  
  dqdJsonDf <- jsonlite::fromJSON(
    paste0(outputFolder,"/",dbId,"_DbProfile.json"),
    simplifyDataFrame = TRUE)
  
  dqd_overview     <- as.data.frame(dqdJsonDf$Overview)
  dqd_checkresults <- as.data.frame(dqdJsonDf$CheckResults)
  
  dqd_checkresults$THRESHOLD_VALUE <- as.character(dqd_checkresults$THRESHOLD_VALUE)
  
  tablesToUpload <- c("db_profile_results","db_metadata","db_cdm_source","dqd_checkresults","dqd_overview")
} else {
  tablesToUpload <- c("db_profile_results","db_metadata","db_cdm_source")
}

conn <- DatabaseConnector::connect(connectionDetails)

# When the schema is empty, use createTable = TRUE
for (tableName in tablesToUpload) {
  DatabaseConnector::insertTable(
    connection        = conn,
    tableName         = tableName,
    databaseSchema    = resultsSchema,
    data              = eval(parse(text=tableName)),
    dropTableIfExists = FALSE,
    createTable       = TRUE,
    tempTable         = FALSE,
    progressBar       = TRUE)
}

DatabaseConnector::disconnect(conn)