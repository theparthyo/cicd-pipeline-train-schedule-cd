pipeline{
    agent any
    stages{
        stage('master')
        {
            steps{
                
                input message: 'image ', ok: 'image name', parameters: [string(defaultValue: 'Centos', description: '', name: '$1', trim: false)]
                sh '''sh test-prod.sh'''
            }
        }
    }
}
