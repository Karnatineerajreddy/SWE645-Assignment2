// Jenkins pipeline for SWE645 Assignment 2
pipeline {
  agent any
  environment {
    IMAGE = "neerajreddy22/swe645-assignment2-neerajreddykarnati:${env.BUILD_NUMBER}"
    REGISTRY_CREDENTIALS = "dockerhub-creds"
    KUBE_CONFIG = "kubconfig"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t $IMAGE .'
      }
    }
    stage('Push') {
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
            # Update deployment.yaml with the new image version
            sed -i "s|neerajreddy22/swe645-assignment2-neerajreddykarnati:latest|$IMAGE|g" k8s/deployment.yaml || true
            kubectl apply -f k8s/
          '''
        }
      }
    }
  }
  post {
    always {
      echo 'Pipeline finished'
    }
  }
}
