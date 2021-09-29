#!groovy?
def FILE_VAR = ""

node {
deleteDir()

stage('Descargar Fuentes') {
checkout scm
}

stage('Desplegando Imagen ') {

script {
      withDockerRegistry([ credentialsId: "credentialDockerRegistry", url: "https://${env.REGISTRY_URL}" ]){            

        withCredentials([usernamePassword(credentialsId: 'AWS_KEY', passwordVariable: 'SECRET', usernameVariable: 'ACCESS')]) {
            
            sh "sed -i 's/#{AWS_ACCOUNT_ID}/${env.AWS_ACCOUNT_ID}/g' $WORKSPACE/terraform.tfvars"
            sh "sed -i 's/#{AWS_ACCESS_KEY_ID}/${ACCESS}/g' $WORKSPACE/terraform.tfvars"
            sh "sed -i 's/#{AWS_SECRET_ACCESS_KEY}/${SECRET}/g' $WORKSPACE/terraform.tfvars"
            sh "sed -i 's/#{AWS_REGION}/${env.AWS_REGION}/g' $WORKSPACE/terraform.tfvars"

            //def docker_volumen    = "-v ${env.WORKSPACE}:/project/data -w /project/data"
            def docker_volumen    = "-v ${env.WORKSPACE}:/workspace -w /workspace"
	
            //def comando = "aws configure set aws_access_key_id $ACCESS && aws configure set aws_secret_access_key $SECRET && aws configure set default.region ${env.AWS_REGION} && terraform init && terraform validate && terraform plan && terraform apply -auto-approve"			
            def comando = "aws configure set aws_access_key_id $ACCESS && aws configure set aws_secret_access_key $SECRET && aws configure set default.region ${env.AWS_REGION} && pwd && chmod -R 755 /workspace/*.tf && ls -l && terraform -v && terraform init "
            sh "docker run ${docker_volumen} --network=host  ${env.REGISTRY_NAME}:terraform-0.14.11-aws-cli-1.20.41 sh -c \"${comando}\""

        }
          
      }
      
}
                    
}



}
