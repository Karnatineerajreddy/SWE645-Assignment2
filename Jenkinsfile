// Jenkins pipeline for SWE645 Assignment 2
// Replace placeholders (REGISTRY, CREDENTIALS_ID, KUBE_CONFIG_CREDENTIAL_ID) with your values.
pipeline {
  agent any
  environment {
    IMAGE = "YOUR_REGISTRY/swe645-sample:${env.BUILD_NUMBER}"
    REGISTRY_CREDENTIALS = "REGISTRY_CREDENTIALS_ID"
    KUBE_CONFIG = "KUBE_CONFIG_CREDENTIAL_ID"
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
            echo "$REG_PASS" | docker login -u "$REG_USER" --password-stdin YOUR_REGISTRY
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
            # Update the k8s/deployment.yaml image reference and apply
            sed -i "s|YOUR_REGISTRY/swe645-sample:latest|$IMAGE|g" k8s/deployment.yaml || true
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
