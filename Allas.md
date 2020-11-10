# How to use Allas from RStudio using AWS credentials and aws.s3 package

Below are instructions to list, download and upload data from/to [Allas](https://docs.csc.fi/data/Allas/). These instructions assume user has AWS access key and AWS secret key. 
If you have access to Puhti or Mahti, instructions how to setup Allas can be found [here](https://docs.csc.fi/data/Allas/accessing_allas/). After setup, credentials can be found from `~/.aws/credentials` file.

Creating credentials can be done using https://github.com/CSCfi/allas-cli-utils#installing-allas-cli-utils guide to create connection from users own workstation. 
Credentials can be found from `~/.s3cfg` or `~/.aws/credentials` file.

### Setup and basic commands
install aws.s3 package
```
install.packages("aws.s3", repos = c("cloudyr" = "http://cloudyr.github.io/drat"))'
```

load aws.s3
```
library("aws.s3")
```

set up environment variables for connection. AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY should be added here
```
Sys.setenv("AWS_ACCESS_KEY_ID" = "<access_key>","AWS_SECRET_ACCESS_KEY" = "<secret_key>","AWS_S3_ENDPOINT" = "a3s.fi","AWS_DEFAULT_REGION" = "")
```

List available buckets
```
bucketlist(region='')
```

Get datafile and save it locally to `local_data.csv` file
```
save_object("local_data.csv", file = "data.csv", bucket = "<your_bucket_name>", region = '') 
```

Load it to variable and print
```
data <- read.csv("local_data.csv")
data
```

To upload local `local_data.csv` file into the Allas bucket
```
put_object(file = "local_data.csv", object = "new_data.csv", bucket = "<your_bucket_name>", region = '')
```
---
More info about aws.s3 can be found from [aws.s3 documentation](https://github.com/cloudyr/aws.s3) 

More info about Allas can be foun from [Allas documentation](https://docs.csc.fi/data/Allas/)