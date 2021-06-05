# aci-demo
Te repo contains:
- a sample Hello World application with a 5 minute Task.Delay
- Visual Studio generated Dockerfile
- Powershell script using Az module that:
  - creates a new resource group
  - creates Azure Container Registry
  - builds the demo app Docker image
  - pushes the image to the previously created Container Registry
  - creates Azure Container Instances group with the previously built image
