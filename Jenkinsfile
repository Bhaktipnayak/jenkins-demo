pipeline {
    agent any

    environment {
        ECR_REGISTRY = '148598146686.dkr.ecr.ap-south-1.amazonaws.com'
        IMAGE_NAME   = 'jenkins-demo'
        IMAGE        = "${ECR_REGISTRY}/${IMAGE_NAME}:latest"
        AWS_REGION   = 'ap-south-1'
    }

    stages {

        stage('Show Files') {
            steps {
                sh '''
                    echo "Files from GitHub:"
                    ls -la
                    echo "Inside jenkins-demo:"
                    ls -la jenkins-demo
                '''
            }
        }

        stage('Run Tests') {
    steps {
        sh '''
            echo "Running tests using existing virtual environment..."

            ./venv/bin/python -m pytest -v jenkins-demo/test_app.py
        '''
    }
}

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t $IMAGE .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    echo "Logging in to Amazon ECR..."
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    echo "Pushing image to ECR..."
                    docker push $IMAGE
                '''
            }
        }

        stage('Deploy with Docker Compose') {
    steps {
        sh '''
            echo "Removing old container..."
            docker rm -f jenkins-demo 2>/dev/null || true

            echo "Pulling latest image..."
            docker compose pull

            echo "Deploying with Docker Compose..."
            docker compose up -d --remove-orphans

            echo "Running containers:"
            docker compose ps
        '''
    }
}

        stage('Health Check') {
            steps {
                sh '''
                    echo "Checking application health..."
                    sleep 3
                    curl -f http://localhost:5000/health
                    echo ""
                    echo "Health check passed!"
                '''
            }
        }

        stage('AWS Identity') {
            steps {
                sh '''
                    echo "Checking AWS identity..."
                    aws sts get-caller-identity
                '''
            }
        }
    }
}
