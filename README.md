# rstudio-openshift
Run [RStudio](https://www.rstudio.com/) integrated development environment and [Shiny](https://www.rstudio.com/products/shiny/shiny-server/) application server on Red Hat OpenShift platform. This package is based on Kubernetes solution from https://github.com/Uninett/helm-charts

Template for notebooks.csc.fi can be found from [template_imageready -branch](https://github.com/CSCfi/rstudio-openshift/tree/template_imageready)

## How to use this template:

This template creates one deployment that uses two Docker builds. The other is for creating password hash as initcontainer before actual application container starts.
Install template by downloading the rstudio-template.yaml file and import it to your OpenShift project via web console. CLI instructions below.

RStudio default working directory is located on persisten storage. Save all your work under the default working directory to avoid data loss. Files saved under other locations will be lost when pod serving application restarts or changes after redeployment.

### Variables:
All variables are mandatory for application to be created. When using CSC Rahti service, consult [Rahti Documentation](https://rahtiapp.fi/) for the details of computing environment and project quotas.

- **Application Name**: (NAME) Unique identifier for your application. Recommended value - your username
- **Username**: (USERNAME) Create a new username for logging into RStudio
- **Password**: (PASSWORD) Create a new password for logging into RStudio
- **Memory Limit**: (MEMORY_LIMIT) Maximum amount of memory the application can use (Default 2G, Max 8G)
- **Storage Size**: (STORAGE_SIZE) Persistent Storage Size (Default 1G, max 50G)
- **Application Hostname Suffix**: (APPLICATION_DOMAIN_SUFFIX) The exposed hostname suffix that will be used to create routes for app (Default when using CSC Rahti service: rahtiapp.fi)

## If running through the Command line:

Download the oc client for openshift and rstudio-template.yaml from GitHub.
* *oc login "openshift-address" --token="token"*
* *oc new-project "project-name"*

Process and apply template using default values from template and passing you application specific parameters
* *oc process -f rstudio-template.yaml -p NAME="application-name" -p USERNAME="your-username" -p PASSWORD="your-password" | oc apply -f -*

### Deleting application and project

* *oc delete all -l app=rstudio*
* *oc delete secret -l app=rstudio*
You might also want to delete the persistent volume created by the setup by 
* *oc delete pvc -l app=rstudio*
* *oc delete project "project-name"*

### Using with Allas object storage

[How to use Allas from RStudio using AWS credentials and aws.s3 package](https://github.com/CSCfi/rstudio-openshift/blob/master/Allas.md)
