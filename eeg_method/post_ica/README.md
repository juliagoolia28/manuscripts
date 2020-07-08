## Automated Epoching and Artifact Rejection
This script takes data that has already been filtered and cleaned (preferably with ICA) and runs artifact detection, rejection, and epochs the data within individual condition.

Required software installations:
- EEGlab
- ERPlab 

Additional required files:
- Channel locations

Data organization:
- Input structure:
  - Main folder containing all subjects/
    - Subject/
      - Post ICA data.set file
    
- Output structure:
  - Make directory for all output data/
    - Date analysis run/
      - Subject_condition.set file
