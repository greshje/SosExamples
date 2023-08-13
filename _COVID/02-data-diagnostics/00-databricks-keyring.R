# ---
#
# 00-databricks-keyring.R
#
# Store token in a key ring
#
# base on:
# https://ras44.github.io/blog/2019/01/19/keeping-credentials-secret-with-keyrings-in-r.html 
#
# Use this script to store your secret information in an encrypted file. 
# Enter a new password you can remember when propted for Keyring Password. 
# Enter your secret information (token) when prompted for a password.  
#
# ---

# installs
# install.packages("keyring")

# library
library(keyring)

# --- R Version ---------------------
R.Version()
# --- Java Version ------------------
system("java -version")
# -----------------------------------"

# parameters
kb <- keyring::backend_file$new()
krName <- "databricks_keyring"

# delete the key ring if it exists
result = tryCatch({
  kb$keyring_delete(krName)
}, warning = function(w) {
  print(paste("Warning trying to delete keyring: ", w))
}, error = function(e) {
  print("Did not delete keyring (it probably did not exist)")
}, finally = {
})


kb$keyring_create(krName)
kb$set("databricks", username="token", keyring = krName)
kb$keyring_lock(krName)

# usage
getToken <- function () {
  return (
    keyring::backend_file$new()$get(
      service = "databricks",
      user = "token",
      keyring = "databricks_keyring"
    )
  )
}






