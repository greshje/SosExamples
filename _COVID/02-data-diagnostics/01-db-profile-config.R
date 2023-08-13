# ---
#
# 01-db-profile-config.R
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
# installs and libraries
#

# install.packages("keyring")
# remotes::install_github("OHDSI/CohortGenerator")
# remotes::install_github("OHDSI/DbDiagnostics")

library(DbDiagnostics)

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

#
# configuration
#

connectionDetails <- DatabaseConnector::createConnectionDetails (
  dbms = "spark",
  connectionString = getUrl(),
  pathToDriver="D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\drivers\\databricks\\"
)

# The schema where your CDM-structured data are housed
cdmDatabaseSchema <- "demo_cdm" 

# The schema where your achilles results are or will be housed
resultsDatabaseSchema <- "demo_cdm_ach_res"

# The schema where any missing achilles analyses should be written. 
writeTo <- "demo_cdm_ach_res"

# The schema where your vocabulary tables are housed, typically the same as the cdmDatabaseSchema
vocabDatabaseSchema <- "omop_concepts"

# A unique, identifiable name for your database
cdmSourceName <- "NACHC_DEMO_DB_OHDSI"

# The folder where your results should be written
outputFolder <- "D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\output"

# The version of the OMOP CDM you are currently on, v5.3 and v5.4 are supported.
cdmVersion <- "5.3"

# Whether the function should append existing Achilles tables or create new ones
appendAchilles <- FALSE

# Whether to round to the 10s or 100s place. Valid inputs are 10 or 100, default is 10.
roundTo <- 10

# Vector of concepts to exclude from the output. Note: No patient-level data is pulled as part of the package or included as part of the output
excludedConcepts <- c()

# Whether the DQD should be run as part of the profile exercise
addDQD <- FALSE

