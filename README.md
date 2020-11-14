## Table of contents
* [General info](#general-info)
* [Features](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This project is the source code of the sem-covid platform used for the health system in some cities in Colombia

## Features
* Public access to the people who wants to know the results of a test
* Private profile to share information about the tests between the labs, hospitals, medical centers.
* API integration with an external platform where the labs reports the results of the tests.
* Display reports and dashboards with data about the positive, negative and pending tests.
* A user can add more information to a patient, to keep the patient updated with the steps of the desease.
	
## Technologies
Project is created with:
* RAILS 5.1.4
* POSTGRESQL
* JQUERY + JAVASCRIPT
* SASS
* JWT FOR API ENDPOINT
* RESQUE
* WEB SOCKETS
* THIRD PARTY API INTEGRATION
	
## Setup
To run this project, do the following steps:

```
$ git clone https://github.com/hed911/semcolombia.git
$ cd /semcolombia
$ bundle install
$ > application.yml
```
Fill the application.yml file with the following variables

```
url_api_sem
token_api_sem
xmpp_url
url_sismuestra_api
cloudinary_development_cloud_name
cloudinary_development_api_key
cloudinary_development_api_secret
cloudinary_production_cloud_name
cloudinary_production_api_key
cloudinary_production_api_secret
cloudinary_test_cloud_name
cloudinary_test_api_key
cloudinary_test_api_secret
google_drive_project_id
google_drive_private_key_id
google_drive_private_key
google_drive_client_email
google_drive_client_id
google_drive_client_x509_cert_url
production_database_name
production_database_host
production_database_username
production_database_password
production_database_port
development_database_name
development_database_host
development_database_username
development_database_password
development_database_port
test_database_name
test_database_host
test_database_username
test_database_password
test_database_port
```
