#!/bin/bash
terraform init -input=false
terraform state list
terraform state rm ibm_pi_instance.test-instance
