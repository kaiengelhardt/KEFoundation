pipeline {
    agent any
    environment {
        SCHEME = 'KEFoundation'
        SCRIPT_PATH = 'Scripts'
        TEST_RESULTS_DIR = 'test-results'
        NUMBER_OF_FAILED_STAGES = 0
    }

    stages {
        stage('Prepare') {
            steps {
                sh "rm -rf ${TEST_RESULTS_DIR}"
                sh "mkdir -p ${TEST_RESULTS_DIR}"
                sh "bundle install"
            }
        }

        stage('Test iOS') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        try {
                            sh "set -o pipefail && ${SCRIPT_PATH}/run_tests.py ${SCHEME} iOS . | bundle exec xcpretty --report junit --output ${TEST_RESULTS_DIR}/iOS.xml"
                        } catch (Exception e) {
                            NUMBER_OF_FAILED_STAGES++
                            error("iOS build failed or tests failed.")
                        } finally {
                            sh "${SCRIPT_PATH}/postprocess_junit_report.py ${TEST_RESULTS_DIR}/iOS.xml iOS"
                        }
                    }
                }
            }
        }

        stage('Test watchOS') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        try {
                            sh "set -o pipefail && ${SCRIPT_PATH}/run_tests.py ${SCHEME} watchOS . | bundle exec xcpretty --report junit --output ${TEST_RESULTS_DIR}/watchOS.xml"
                        } catch (Exception e) {
                            NUMBER_OF_FAILED_STAGES++
                            error("watchOS build failed or tests failed.")
                        } finally {
                            sh "${SCRIPT_PATH}/postprocess_junit_report.py ${TEST_RESULTS_DIR}/watchOS.xml watchOS"
                        }
                    }
                }
            }
        }

        stage('Test tvOS') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        try {
                            sh "set -o pipefail && ${SCRIPT_PATH}/run_tests.py ${SCHEME} tvOS . | bundle exec xcpretty --report junit --output ${TEST_RESULTS_DIR}/tvOS.xml"
                        } catch (Exception e) {
                            NUMBER_OF_FAILED_STAGES++
                            error("tvOS build failed or tests failed.")
                        } finally {
                            sh "${SCRIPT_PATH}/postprocess_junit_report.py ${TEST_RESULTS_DIR}/tvOS.xml tvOS"
                        }
                    }
                }
            }
        }

        stage('Test visionOS') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        try {
                            // Run this only on arm64 test runners. x86 machines cannot build for visionOS.
                            sh '''
                            if [ "$(uname -m)" = "arm64" ]; then
                                set -o pipefail
                                ${SCRIPT_PATH}/run_tests.py ${SCHEME} visionOS . | bundle exec xcpretty --report junit --output ${TEST_RESULTS_DIR}/visionOS.xml
                            else
                                exit 0
                            fi
                            '''
                        } catch (Exception e) {
                            NUMBER_OF_FAILED_STAGES++
                            error("visionOS build failed or tests failed.")
                        } finally {
                            sh '''
                            if [ "$(uname -m)" = "arm64" ]; then
                                ${SCRIPT_PATH}/postprocess_junit_report.py ${TEST_RESULTS_DIR}/visionOS.xml visionOS
                            else
                                exit 0
                            fi
                            '''
                        }
                    }
                }
            }
        }

        stage('Test macOS') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        try {
                            sh "set -o pipefail && ${SCRIPT_PATH}/run_tests.py ${SCHEME} macOS . | bundle exec xcpretty --report junit --output ${TEST_RESULTS_DIR}/macOS.xml"
                        } catch (Exception e) {
                            NUMBER_OF_FAILED_STAGES++
                            error("macOS build failed or tests failed.")
                        } finally {
                            sh "${SCRIPT_PATH}/postprocess_junit_report.py ${TEST_RESULTS_DIR}/macOS.xml macOS"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            junit "${TEST_RESULTS_DIR}/*.xml"
            
            script {
                if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                    currentBuild.result = 'SUCCESS'
                } else {
                    currentBuild.result = 'FAILURE'
                }

                int numberOfFailedStages = NUMBER_OF_FAILED_STAGES.toInteger()
                if (numberOfFailedStages != 0) {
                    sh "echo Number of failed stages = ${NUMBER_OF_FAILED_STAGES}"
                    currentBuild.result = 'FAILURE'
                }
            }
        }
    }
}
