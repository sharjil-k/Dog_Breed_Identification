FROM python:3.7-slim

#ENV http_proxy http://proxy-chain.xxx.com:911/
#ENV https_proxy http://proxy-chain.xxx.com:912/

# install the notebook package
RUN pip install --no-cache --user --upgrade pip && \
    pip install --no-cache notebook
RUN python -m pip install jupyterlab

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_SRC=/src \
    PIPENV_HIDE_EMOJIS=true \
    PIPENV_COLORBLIND=true \
    PIPENV_NOSPIN=true

RUN python -m pip install pipenv


# create user with a home directory
ARG NB_USER=sharjil
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
WORKDIR ${HOME}
USER ${USER}

COPY Pipfile .
COPY Pipfile.lock .
RUN pipenv install --deploy --ignore-pipfile --dev


ENTRYPOINT ["pipenv", "run"]