# original docker file from https://github.com/AUTOMATIC1111/stable-diffusion-webui/discussions/5049
FROM public.ecr.aws/lambda/python:3.10-arm64

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    USE_NNPACK=0

# LAMBDA_TASK_ROOT = /var/task
WORKDIR $LAMBDA_TASK_ROOT

RUN python -m pip install --upgrade pip wheel
RUN yum -y update &&\
    yum -y install wget git
RUN yum clean all

# RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /stablediff-web
# torch and torchvision version number refer to
# https://github.com/AUTOMATIC1111/stable-diffusion-webui/blob/master/launch.py
# download torch for cpu version

ENV TORCH_COMMAND="pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu"
RUN python -m $TORCH_COMMAND
RUN python -m pip install mangum

# for psutil
RUN yum -y install gcc

COPY ./stablediff-webui $LAMBDA_TASK_ROOT
# RUN pip install pytorch-lightning

RUN python launch.py --skip-torch-cuda-test --exit
RUN python -m pip install opencv-python-headless

COPY ./stablediff.env /stablediff.env
# ./stablediff-models = checkpoint location
COPY ./stablediff-models /var/task/models/Stable-diffusion

# Temporary method for not as patch file doesn't work
# RUN rm /stablediff-web/webui.py
# COPY ./stablediff-web/webui.py /stablediff-web

# copy patch file
# COPY ./stablediff-web/webui.patch /stablediff-web
# RUN yum -y install patch
# RUN patch -p0 < webui.patch

# to account for lambda ownership thing
# RUN find . -type f -exec chmod 644 "{}" \;
# RUN find . -type d -exec chmod 755 "{}" \;

# 7860 for webui, 7861 for api server
EXPOSE 7860
EXPOSE 7861

ENTRYPOINT []
# CMD ["/var/lang/bin/python", "/stablediff-web/launch.py", "--listen", "--no-half", "--no-half-vae", "--use-cpu", "all", "--skip-torch-cuda-test", "--nowebui", "--skip-prepare-environment"]
CMD ["launch_new.handler"]

# find .git folders and remove them all to save space
