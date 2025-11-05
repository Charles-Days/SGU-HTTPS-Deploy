pipeline {
    agent any

    stages {
        stage('Stop Services') {
            steps {
                script {
                    echo '🛑 Deteniendo servicios anteriores...'
                    sh '''
                        cd $WORKSPACE
                        docker compose down || true
                    '''
                }
            }
        }

        stage('Remove Images') {
            steps {
                script {
                    echo '🗑️ Eliminando imágenes antiguas...'
                    sh '''
                        docker rmi client:1.0-sgu -f || true
                        docker rmi server:1.0-sgu -f || true
                    '''
                }
            }
        }

        stage('Pull from SCM') {
            steps {
                script {
                    echo '📥 Obteniendo últimos cambios del repositorio...'
                    sh '''
                        cd $WORKSPACE
                        git pull origin main || true
                    '''
                }
            }
        }

        stage('Build and Deploy') {
            steps {
                script {
                    echo '🏗️ Construyendo imágenes y desplegando servicios...'
                    sh '''
                        cd $WORKSPACE
                        docker compose up -d --build
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo '🏥 Verificando estado de los servicios...'
                    sh '''
                        sleep 10
                        docker ps

                        echo "Esperando a que el backend esté listo..."
                        for i in {1..30}; do
                            if curl -s http://localhost:8081/sgu-api/users > /dev/null; then
                                echo "✅ Backend está respondiendo"
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
            echo '✅ ¡Pipeline ejecutado exitosamente!'
            echo '🌐 Aplicación disponible en http://localhost:3000'
            echo '📡 API disponible en http://localhost:8081/sgu-api'
        }
        failure {
            echo '❌ Pipeline falló. Revisa los logs para más detalles.'
            sh 'docker compose logs --tail=50'
        }
        always {
            echo '📊 Estado final de los contenedores:'
            sh 'docker ps -a | grep sgu || true'
        }
    }
}
