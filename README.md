# dg-ddns
Dynamic IP host update for GoDaddy hosted domain.

## Requirements
Script require 'jq' to be installed pririor run.
Please visit 'jq' project webiste https://stedolan.github.io/jq/ for installation instructions.

Additionally you have to create GoDaddy API Key/Secure to be able to access GoDaddy API. To do this, go to https://developer.godaddy.com/getstarted, login with your GoDaddy account details, go to 'API Keys' and generate API Key & Secure for production environment.

## Installation & Configuration
* Clone this repository or just copy/paste RAW source of gd-ddns.sh.
* Update required details in source to reflect your login details and DNS record.
* Run manualy to check if there is no errors
* Setup cron job to run script. Remember to not run it from root account.
