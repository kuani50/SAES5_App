pipeline {
    agent {
        docker { 
            image 'ghcr.io/cirruslabs/flutter:stable'
            args '-v flutter-pub-cache:/pub-cache'
        }
    }

    environment {
        PUB_CACHE = '/pub-cache'
        // Add the global pub cache bin to PATH to run 'tojunit'
        PATH = "/pub-cache/bin:$PATH"
    }

    stages {
        stage('Setup') {
            steps {
                echo 'Checking Flutter environment...'
                sh 'flutter doctor'
                
                echo 'Fetching dependencies (cached)...'
                sh 'flutter pub get'
                
                echo 'Installing JUnit reporter...'
                // Installs the tool to convert JSON test output to XML
                sh 'dart pub global activate junitreport'
            }
        }

        stage('Analyze') {
            steps {
                echo 'Analyzing code...'
                sh 'flutter analyze'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests with JUnit reporting...'
                // 1. Run tests and save JSON output to a file. 
                //    We use '|| true' so the pipeline continues to the next step (reporting) even if tests fail.
                sh 'flutter test --machine > tests.json || true'
                
                // 2. Convert the JSON file to XML
                sh 'cat tests.json | dart pub global run junitreport:tojunit --output test-results.xml'
            }
        }
    }
    
    post {
        always {
            // Pick up the XML report. Jenkins will now display test results.
            junit 'test-results.xml'
            echo 'Pipeline finished.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}