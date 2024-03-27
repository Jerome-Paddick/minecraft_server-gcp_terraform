TFVARS_FILE = ..\config\vars.tfvars

.PHONY: apply plan destroy

apply:
	terraform apply -var-file="$(TFVARS_FILE)" -auto-approve

plan:
	terraform plan -var-file="$(TFVARS_FILE)"

destroy:
	terraform destroy -var-file="$(TFVARS_FILE)"

apply_with_logs:
	set TF_LOG=DEBUG & set TF_LOG_PATH=./terraform.log 
	$($Env:TF_LOG="DEBUG")
	$($Env:TF_LOG_PATH="./terraform.log")
	$(info    VAR is ${TF_LOG})
	terraform apply -var-file="$(TFVARS_FILE)" -auto-approve
