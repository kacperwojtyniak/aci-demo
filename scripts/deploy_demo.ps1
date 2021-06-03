$rg="rg-long-job" #Resource group name
$location="WestEurope" #Location of all of the resources
$acrName="crlongjobs" #Name of the container registry
$aciName="aci-long-job" #Name of the Azure Container Instances group

#login
Connect-AzAccount

#create resource group
New-AzResourceGroup -Name $rg -Location $location

#create container registry
$registry = New-AzContainerRegistry -ResourceGroupName $rg -Name $acrName -EnableAdminUser -Sku Basic
$loginServer = $registry.LoginServer

#login to the registry
$creds = Get-AzContainerRegistryCredential -Registry $registry
$creds.Password | docker login $registry.LoginServer -u $creds.Username --password-stdin

#set the image name
$imageName = "$loginServer/longjob:latest"

#build the image
docker build .. -f ../long-job/Dockerfile -t $imageName

#push the image to the registy
docker push $imageName

## create ACI
$container = New-AzContainerInstanceObject `
-Name test-container `
-Image $imageName `
-RequestCpu 1 `
-RequestMemoryInGb 1

$imageRegistryCredential = New-AzContainerGroupImageRegistryCredentialObject `
-Server $loginServer `
-Username $creds.Username `
-Password (ConvertTo-SecureString $creds.Password -AsPlainText -Force) 

New-AzContainerGroup `
-ResourceGroupName $rg `
-Name $aciName `
-Location $location `
-Container $container `
-ImageRegistryCredential $imageRegistryCredential `
-RestartPolicy OnFailure