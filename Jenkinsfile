pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Bhaktipnayak/jenkins-demo.git'
            }
        }

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

        stage('Run Application') {
            steps {
                sh '''
                    echo "Skipping direct application run..."
                    echo "Application will be run inside Docker."
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    echo "Creating Python virtual environment..."

                    python3 -m venv venv

                    echo "Installing dependencies..."
                    ./venv/bin/pip install -r jenkins-demo/requirements.txt

                    echo "Installing pytest..."
                    ./venv/bin/pip install pytest

                    echo "Running tests..."
                    ./venv/bin/pytest -v jenkins-demo/test_app.py
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t bhakti3435/jenkins-demo:latest .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo "Pushing Docker image to Docker Hub..."
                    docker push bhakti3435/jenkins-demo:latest
                '''
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh '''
                    echo "Deploying application..."

                    docker rm -f jenkins-demo 2>/dev/null || true

                    docker run -d \
                        --name jenkins-demo \
                        -p 5000:5000 \
                        bhakti3435/jenkins-demo:latest

                    docker update --restart unless-stopped jenkins-demo

                    echo "Application deployed!"

                    docker ps
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
