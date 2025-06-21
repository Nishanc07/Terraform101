# set the subscription
export ARM_SUBSCRIPTION_ID="a584d13d-2dd5-4bbf-85ff-b0c51f60baca"



# set the application / environment
export TF_VAR_application_name="linuxvm"
export TF_VAR_environment_name="dev"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-terraform-state-dev"
export BACKEND_STORAGE_ACCOUNT="stb66hggfsdv"
export BACKEND_CONTAINER_NAME="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name



# run terraform

terraform init \
      -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
      -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
      -backend-config="container_name=${BACKEND_CONTAINER_NAME}" \
      -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform #after running ur core workflow clean the hidden dir of tfstate in env to not get Error: backend config changed