# 1 - Apply for EE ====

# Go to https://code.earthengine.google.com/
# 
# If you don’t have a Google account, click ‘create account’, 
# otherwise login with your Google account.
# 
# Earth Engine will now request access to your Google account. Click ‘allow’.
# 
# Click the link to go to the registration page and fill out the application. 
# 
# After you receive your ‘Welcome to Google Earth Engine!’ email, you will be 
# able to login using your Google account on https://code.earthengine.google.com/

# 2 - Set up rgee to interact with EE ====
install.packages("rgee")

# Required dependencies:
#   Google account with Earth Engine activated
#   Python >= v3.5
#   EarthEngine Python API (Python package)
#   
#   Run the following to install Miniconda, set up Python environment, and 
#   install the Earth Engine API and numpy:

library(rgee)

ee_install(py_env = "rgee")

# Credentials dependencies:
#   Not required, but recommended to move data from Earth Engine into your
#   local R environment. Authentication allows access to 
#   Google Drive/Cloud Storage. Only needs to be completed ONCE.
#   
#     Option 1: Initialize Earth Engine and Google Drive (recommended)
ee_Initialize(user = 'your_email_here@gmail.com', drive = TRUE)
      
#     When Google Drive is verified, you will be directed to an 
#     authentication token. Copy the token and paste it in the R console.
      
#     Option 2: Initialize Earth Engine and Google Cloud Storage
ee_Initialize(user = 'your_email_here@gmail.com', gcs = TRUE)
      
#     Google Cloud Storage credentials must be set up manually at 
#     https://code.markedmondson.me/googleCloudStorageR/articles/googleCloudStorageR.html
#     
#   When you're finished, check that everything worked properly:
#   
ee_check_python()
ee_check_credentials()
ee_check_python_packages()

