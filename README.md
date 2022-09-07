# RStudio Openshift

Run [RStudio](https://www.rstudio.com/) integrated development environment and
 [Shiny](https://www.rstudio.com/products/shiny/shiny-server/) application server
 on the Red Hat OpenShift platform. This package is based on the Kubernetes solution from
 <https://github.com/Uninett/helm-charts>

Template for notebooks.csc.fi can be found from [template_imageready -branch](https://github.com/CSCfi/rstudio-openshift/tree/template_imageready)

## How to use this template

Install the template by downloading the rstudio-template.yaml file and import it to
your OpenShift project via a web console. CLI instructions are below.

RStudio default working directory is located on persistent storage. Save all your
work under the default working directory to avoid data loss. Files saved under
other locations will be lost when the pod serving application restarts or changes after
redeployment.

### Variables

All variables are mandatory for the application to be created. When using CSC Rahti
service, consult [Rahti Documentation](https://rahtiapp.fi/) for the details of
computing environment and project quotas.

- **Application Name**: (NAME) Unique identifier for your application. Recommended
 value - your username
- **Username**: (USER) Create a new username for logging into RStudio
- **Password**: (PASSWORD) Create a new password for logging into RStudio
- **Storage Size for Shiny**: (STORAGE_SIZE) Persistent Storage Size (Default 1G)
- **Storage Size for Rstudio work folder**: (STORAGE_SIZE_TMP) Persistent Storage Size for the working directory in (Default 1G)
- **Application Hostname Suffix**: (APPLICATION_DOMAIN_SUFFIX) The exposed hostname
  suffix that will be used to create routes for app (Default when using CSC Rahti
  service: rahtiapp.fi)

The initial quota of 50G is shared by both `STORAGE_SIZE` and `STORAGE_SIZE_TMP`. So the sum of both values cannot be bigger than 50G.

## If running through the Command line

Download the oc client for Openshift and rstudio-template.yaml from GitHub.

- `oc login "openshift-address" --token="token"`
- `oc new-project "project-name"`

Process and apply template using default values from the template and passing your  application specific parameters.

- `oc process -f rstudio-template.yaml -p NAME="application-name" -p USER="your-username" -p PASSWORD="your-password" | oc apply -f -`

### Deleting application and project

- `oc delete all -l app=rstudio`
- `oc delete secret -l app=rstudio`
- `oc delete cm -l app=rstudio`

You might also want to delete the persistent volume created by the setup by

- `oc delete pvc -l app=rstudio`
- `oc delete project "project-name"`

### Using Allas object storage

[How to use Allas from RStudio using AWS credentials and aws.s3 package](https://github.com/CSCfi/rstudio-openshift/blob/master/Allas.md)

## Publish an application to Shiny

Use the terminal in the Rstudio interface to copy your application to /srv/shiny-server/
