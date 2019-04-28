node('node1') { 
  def DockerImage = "noamshmueli/projectimage"
  def ContainerName = "project_container"

  stage('Pre') { // Run pre-build steps
    cleanWs()
    sh "docker rm -f ${ContainerName} || true"
  }

  
  stage('Git') { // Get code from GitLab repository
    git branch: 'master',
      url: 'http://github.com/Noamshmueli/middleproject-app.git'
  }
  
  stage('Build') { // Run the docker build
    sh "docker image build -t ${DockerImage} ."
  }
  
  stage('Run') { // Run the built image
    sh "docker run -d --name ${ContainerName} --rm -p 8081:5000 ${DockerImage}; sleep 5"
  }
  
  stage('Test') { // Run tests on container
    def dockerOutput = sh (
        script: 'curl http://172.17.0.1:8081/goaway',
        returnStdout: true
        ).trim()
    sh "docker rm -f ${ContainerName}"
    
    if ( dockerOutput == 'GO AWAY!' ) {
        currentBuild.result = 'SUCCESS'
    } else {
        currentBuild.result = 'FAILURE'
        sh "echo ${ContainerName} returned ${dockerOutput}"
    }
    return
  }


  stage('Push') { // Push the image to repository
   withDockerRegistry([ credentialsId: "docker-hub-credentials", url: "" ]) {
         sh "docker push ${DockerImage}"
       }
   sh "docker rmi ${DockerImage}"
   return
 }




  stage('Deploy on kubernetes') {
   kubernetesDeploy(
      kubeconfigId: 'kubeconfig',
      configs: 'k8s/*',
      enableConfigSubstitution: true
     )
}


}
