pipeline {
    agent any

    environment {
       
        IMAGE_NAME = 'my-python-app'
        IMAGE_TAG = 'latest' 
        CONTAINER_NAME = 'python-app-container'  
        DOCKER_CREDENTIALS_ID = 'dockerhub' 
        DOCKER_USERNAME = 'premdatagrokr' 
        DOCKER_REPO = 'premdatagrokr/my-python-app'  
    }

    stages {
        stage('Checkout Code') {
            steps {
                
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                   
                    echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    
                    echo "Running Docker container with name: ${CONTAINER_NAME}"
                    sh "docker run --name ${CONTAINER_NAME} -d ${IMAGE_NAME}:${IMAGE_TAG}"
                    sleep(5)

                    
                    echo 'Container logs:'
                    sh "docker logs ${CONTAINER_NAME}"
                }
            }
        }


        stage('Tag Docker Image') {
            steps {
                script {
                    
                    echo "Tagging image for Docker Hub"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REPO}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    
                    echo "Pushing Docker image to Docker Hub"
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        sh "docker push ${DOCKER_REPO}:${IMAGE_TAG}"
                    }
                }
                
            }
        }
        stage('Clean Up') {
            steps {
                script {
                    try {
                        
                        echo "Cleaning up Docker images and containers"
                        sh "docker stop ${CONTAINER_NAME} || true" 
                        sh "docker rm ${CONTAINER_NAME} || true" 
                        sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"  
                        sh "docker rmi ${DOCKER_REPO}:${IMAGE_TAG} || true" 
                    } catch (Exception e) {
                        error "Failed to clean up Docker resources: ${e.message}"
                    }
                }
            }
        }
    }

    

    post {
        success {
            echo "Build, tests, and Docker push were successful"
        }

        failure {
            echo "Build, tests, or Docker push failed"
        }
    }
}
