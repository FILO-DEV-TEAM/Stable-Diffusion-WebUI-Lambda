## Stable Diffusion Web UI
[https://github.com/AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)

Script and dockerfile for uploading SD-Webui to AWS Lambda.

Need to do the following

docker build
docker run
docker commit (so that the container has all the caches and dependencies
docker push to ecr

apply image to lambda
test lambda with API gateway event test case.

Progress log (Written in Korean)
https://suwhoanlim.notion.site/SD-on-Lambda-2b202b9d240c4987aa21dd01a0d5d218?pvs=4

