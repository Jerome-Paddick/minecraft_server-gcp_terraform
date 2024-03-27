TFVARS_FILE = ..\shared\shared_variabled.tfvars


PROJECT_ID = "mc-server-416313"
DOCKER_IMAGE_NAME = "jjmc_image"
REGISTRY_REGION = "eu"

.PHONY: apply plan destroy zip_world zip_server up exec log

apply:
	set TF_LOG=DEBUG & set TF_LOG_PATH=./terraform.log 
	$($Env:TF_LOG="DEBUG")
	$($Env:TF_LOG_PATH="./terraform.log")
	$(info    VAR is ${TF_LOG})
	terraform apply -var-file="$(TFVARS_FILE)" -auto-approve

plan:
	terraform plan -var-file="$(TFVARS_FILE)"

destroy:
	terraform destroy -var-file="$(TFVARS_FILE)"

# build:
# 	docker build -t ${DOCKER_IMAGE_NAME} .

# tag:
# 	docker tag ${DOCKER_IMAGE_NAME}:latest  ${REGISTRY_REGION}.gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_NAME}:latest

# push:
# 	docker push ${REGISTRY_REGION}.gcr.io/${PROJECT_ID}/${DOCKER_IMAGE_NAME}:latest

zip_world:
	powershell -c "Compress-Archive -Path ".\files\world" -DestinationPath ".\files\zips\world.zip" -Force"

zip_server:
	powershell -c "Compress-Archive -Path ".\files\server" -DestinationPath ".\files\zips\server_files.zip" -Force"

up:
	docker-compose up -d --build

exec:
	docker exec -it local sh

log:
	docker logs local -f