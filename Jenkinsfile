pipeline{
    agent 'devlopment'
    stages{
        stage('master')
        {
            steps{
                sh '''sh test-prod.sh'''
                input id: '12', message: 'name ', parameters: [choice(choices: ['$1', '$2'], description: '', name: 'choise')]
            }
        }
    }
}
