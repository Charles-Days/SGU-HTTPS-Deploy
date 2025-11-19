pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    echo 'Codigo obtenido del repositorio'
                    sh 'pwd && ls -la'
                }
            }
        }

        stage('Stop Services') {
            steps {
                script {
                    echo 'Deteniendo servicios anteriores...'
                    sh '/usr/local/bin/docker compose down || true'
                }
            }
        }

        stage('Remove Images') {
            steps {
                script {
                    echo 'Eliminando imagenes antiguas...'
                    sh '''
                        /usr/local/bin/docker rmi client:1.0-sgu-https -f || true
                        /usr/local/bin/docker rmi server:1.0-sgu-https -f || true
                    '''
                }
            }
        }

        stage('Build and Deploy') {
            steps {
                script {
                    echo 'Construyendo imagenes y desplegando servicios...'
                    sh '/usr/local/bin/docker compose up -d --build'
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo 'Verificando estado de los servicios...'
                    sh '''
                        sleep 15
                        /usr/local/bin/docker ps

                        echo "Esperando a que el backend HTTPS este listo..."
                        for i in {1..30}; do
                            if curl -k -s https://localhost:8444/sgu-api/users > /dev/null; then
                                echo "Backend HTTPS esta respondiendo"
                                break
                            fi
                            echo "Intento $i/30..."
                            sleep 2
                        done
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline ejecutado exitosamente!'
            echo 'Aplicacion disponible en https://localhost:3001'
            echo 'API disponible en https://localhost:8444/sgu-api'
            echo 'HTTPS configurado correctamente'
        }
        failure {
            echo 'Pipeline fallo. Revisa los logs para mas detalles.'
            sh '/usr/local/bin/docker compose logs --tail=50 || true'
        }
        always {
            echo 'Estado final de los contenedores:'
            sh '/usr/local/bin/docker ps -a | grep sgu || true'
        }
    }
}
