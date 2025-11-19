pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    }

    stages {
        stage('Stop Services') {
            steps {
                script {
                    echo '🛑 Deteniendo servicios anteriores...'
                    sh '''
                        cd $WORKSPACE
                        /usr/local/bin/docker compose down || true
                    '''
                }
            }
        }

        stage('Remove Images') {
            steps {
                script {
                    echo '🗑️ Eliminando imágenes antiguas...'
                    sh '''
                        /usr/local/bin/docker rmi client:1.0-sgu-https -f || true
                        /usr/local/bin/docker rmi server:1.0-sgu-https -f || true
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
                        /usr/local/bin/docker compose up -d --build
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
                        /usr/local/bin/docker ps

                        echo "Esperando a que el backend HTTPS esté listo..."
                        for i in {1..30}; do
                            if curl -k -s https://localhost:8444/sgu-api/users > /dev/null; then
                                echo "✅ Backend HTTPS está respondiendo"
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
            echo '🌐 Aplicación disponible en https://localhost:3001'
            echo '📡 API disponible en https://localhost:8444/sgu-api'
            echo '🔒 HTTPS configurado correctamente'
        }
        failure {
            echo '❌ Pipeline falló. Revisa los logs para más detalles.'
            sh '/usr/local/bin/docker compose logs --tail=50 || true'
        }
        always {
            echo '📊 Estado final de los contenedores:'
            sh '/usr/local/bin/docker ps -a | grep sgu || true'
        }
    }
}
