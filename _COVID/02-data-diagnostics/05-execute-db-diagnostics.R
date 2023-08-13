# ---
#
# 05-execute-db-diagnostics.R
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

dbProfileConnectionDetails <- DatabaseConnector::createConnectionDetails (
  dbms = "spark",
  connectionString = getUrl(),
  pathToDriver="D:\\_YES_2023-05-28\\workspace\\SosExamples\\_COVID\\02-data-diagnostics\\drivers\\databricks\\"
)

dbDiagnosticResults <- DbDiagnostics::executeDbDiagnostics(
  connectionDetails = dbProfileConnectionDetails,
  resultsDatabaseSchema = "demo_cdm_ach_res",
  resultsTableName = "",
  outputFolder = outputFolder,
  dataDiagnosticsSettingsList = settingsList
)

