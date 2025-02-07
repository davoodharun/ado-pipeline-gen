const fs = require('fs');
const process = require('process');
const axios = require('axios');
const path = require('path');
// Get environment variables and command line arguments
if (process.argv.length < 4) {
    console.error('Usage: node get-pipeline-config.js <repository-name> <project-name>');
    process.exit(1);
}

// Constants from environment variables and arguments
const organization = process.env.AZURE_DEVOPS_ORG_URL;
const personalAccessToken = process.env.AZURE_DEVOPS_TOKEN;
const repository = process.argv[2]; // First argument is repository name
const project = process.argv[3]; // Second argument is project name

if (!organization || !personalAccessToken) {
    console.error('Required environment variables AZURE_DEVOPS_ORG_URL and AZURE_DEVOPS_TOKEN must be set');
    process.exit(1);
}

// Set default file path for pipeline config
const filePath = '.azuredevops/pipelines.json';
const branch = 'main';



// Configuration

const outputFilePath = path.join(__dirname, path.basename(filePath));

// Encode personal access token for authentication
const auth = Buffer.from(`:${personalAccessToken}`).toString('base64');

// Azure DevOps API URL for file contents
const url = `https://dev.azure.com/${organization}/${project}/_apis/git/repositories/${repository}/items?path=${encodeURIComponent(filePath)}&versionDescriptor.versionType=branch&versionDescriptor.version=${branch}&api-version=7.1-preview.1`;

// Fetch file and save it locally
async function downloadFile() {
    try {
        const response = await axios.get(url, {
            headers: {
                'Authorization': `Basic ${auth}`,
                'Accept': 'application/octet-stream'
            },
            responseType: 'arraybuffer' // Ensures binary data is handled properly
        });

        fs.writeFileSync(outputFilePath, response.data);
        console.log(`File downloaded successfully: ${outputFilePath}`);
    } catch (error) {
        console.error('Error downloading file:', error.response ? error.response.data : error.message);
    }
}

// Execute function
downloadFile();
