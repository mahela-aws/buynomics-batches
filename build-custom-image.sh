#! /usr/bin/env sh

ECR_REPO_NAME=""
AWS_ACCOUNT_ID=""
AWS_PROFILE=""

echo ""
read -p "Enter AWS Profile: " AWS_PROFILE
echo ""

export $AWS_PROFILE

echo ""
read -p "Enter ecr repository name that you would like to create [python3.8-repo]: " ECR_REPO_NAME
ECR_REPO_NAME=${ECR_REPO_NAME:-python3.8-repo}
echo ""
read -p  "Enter your aws account id : " AWS_ACCOUNT_ID
echo ""


# Creates ecr repository
echo ""
echo "Creating ecr repository : $ECR_REPO_NAME "
echo ""
aws ecr create-repository \
    --repository-name "$ECR_REPO_NAME" \
    --image-scanning-configuration scanOnPush=true \
    --region us-east-1
  if [ $? -eq 0 ]; then
    echo ""
    echo "Successfully create ecr repository : $ECR_REPO_NAME "
    echo ""
  else
    echo ""
    echo "Failed to create ecr repository !!"
    echo ""
    exit 1
  fi

# Login to ecr repository
echo ""
echo "Logging into ecr repository : $ECR_REPO_NAME "
echo ""
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID".dkr.ecr.us-east-1.amazonaws.com/"$ECR_REPO_NAME"
  if [ $? -eq 0 ]; then
    echo ""
    echo "Login Successfull"
    echo ""
  else
    echo ""
    echo "Failed to Login !!"
    echo ""
    exit 1
  fi

# Build image
echo ""
echo "Building docker image.... "
echo ""
docker build --tag "$ECR_REPO_NAME" .
  if [ $? -eq 0 ]; then
    echo ""
    echo "Docker image build successfull..."
    echo ""
  else
    echo ""
    echo "Failed to build docker image !!"
    echo ""
    exit 1
  fi

# Tag image
echo ""
echo "Tagging docker image with ecr.... "
echo ""
docker tag "$ECR_REPO_NAME":latest "$AWS_ACCOUNT_ID".dkr.ecr.us-east-1.amazonaws.com/"$ECR_REPO_NAME":latest

# Push image to ecr
echo ""
echo "Pushing docker image to ecr.... "
echo ""
docker push "$AWS_ACCOUNT_ID".dkr.ecr.us-east-1.amazonaws.com/"$ECR_REPO_NAME":latest
  if [ $? -eq 0 ]; then
    echo ""
    echo "Docker image pushed to ecr successfull..."
    echo ""
  else
    echo ""
    echo "Failed push docker image to ecr !!"
    echo ""
    exit 1
  fi
echo ""
echo "ecr image uri : "$AWS_ACCOUNT_ID".dkr.ecr.us-east-1.amazonaws.com/"$ECR_REPO_NAME":latest"
echo ""
