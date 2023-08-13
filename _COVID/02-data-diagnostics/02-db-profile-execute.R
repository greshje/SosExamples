  # ---
  #
  # 02-db-profile-execute.R
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
  # Run DbDiagnostics::executeDbProfile
  #
  
  DbDiagnostics::executeDbProfile (
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    resultsDatabaseSchema = resultsDatabaseSchema,
    writeTo = writeTo,
    vocabDatabaseSchema = vocabDatabaseSchema,
    cdmSourceName = cdmSourceName,
    outputFolder = outputFolder,
    cdmVersion = cdmVersion,
    appendAchilles = appendAchilles,
    roundTo = roundTo,
    excludedConcepts = excludedConcepts,
    addDQD = addDQD
  )
  
  
  
  
