// Jenkins pipeline for SWE645 Assignment 2
pipeline {
  agent any
  environment {
    // DockerHub repo - image will be tagged with BUILD_NUMBER
    IMAGE = "neerajreddy22/swe645-assignment2-neerajreddykarnati:${env.BUILD_NUMBER}"

    // Jenkins credential IDs
    REGISTRY_CREDENTIALS = "dockerhub-creds"   // DockerHub username+password
    KUBE_CONFIG = "kubconfig"                  // kubeconfig file from Rancher
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE .'
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'REG_USER', passwordVariable: 'REG_PASS')]) {
          sh '''
            echo "$REG_PASS" | docker login -u "$REG_USER" --password-stdin
            docker push $IMAGE
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: env.KUBE_CONFIG, variable: 'KUBECONFIG_FILE')]) {
          sh '''
            export KUBECONFIG=$KUBECONFIG_FILE
            # update deployment.yaml image reference
            sed -i "s|image:.*|image: $IMAGE|g" deployment.yaml
            kubectl apply -f deployment.yaml
            kubectl apply -f service.yaml
            kubectl rollout status deployment/student-survey-deployment
          '''
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished ✅'
    }
  }
}
