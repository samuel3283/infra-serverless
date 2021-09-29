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

		/*
            sh "aws_account_id = ${env.AWS_ACCOUNT_ID} > terraform.tfvars"
            sh "aws_access_key_id = ${ACCESS} >> terraform.tfvars"
            sh "aws_secret_access_key = ${SECRET} >> terraform.tfvars"
            sh 'aws_region = "${env.AWS_REGION}" > terraform.tfvars'
            sh 'env = "DESARROLLO" >> terraform.tfvars'
            sh 'env_lang = "python3.8" >> terraform.tfvars'
            sh 'tag_ceco = "pgo1007383" >> terraform.tfvars'
      		FILE_VAR = sh (
                script: "cat  $WORKSPACE/terraform.tfvars",
                returnStdout: true
            ).trim()
	*/
            
            def docker_volumen    = "-v ${env.WORKSPACE}:/project/data -w /project/data"
	
            //def comando = "aws configure set aws_access_key_id $ACCESS && aws configure set aws_secret_access_key $SECRET && aws configure set default.region ${env.AWS_REGION} && terraform init && terraform validate && terraform plan && terraform apply -auto-approve"			
            def comando = "aws configure set aws_access_key_id $ACCESS && aws configure set aws_secret_access_key $SECRET && aws configure set default.region ${env.AWS_REGION} && terraform -v "			
            sh "docker run ${docker_volumen} --network=host  ${env.REGISTRY_NAME}:terraform-aws-cli sh -c \"${comando}\""

        }
          
      }
      
}
                    
}



}
