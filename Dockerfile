# Poor man's remote WSL
FROM ubuntu:lunar as base_env

ARG group=serviceuser
ARG user=devuser
ARG home=/home/devuser

USER root

# Things we want or pyenv wants
RUN apt update && apt install -y openssh-server git curl build-essential \
zlib1g-dev libssl-dev ncurses-dev libffi-dev libreadline-dev \
sqlite3 libsqlite3-dev tk-dev libbz2-dev liblzma-dev

# Configure ssh
RUN ssh-keygen -A -v
RUN sed -i "s|#PermitEmptyPasswords no|PermitEmptyPasswords yes|g" /etc/ssh/sshd_config
RUN service ssh start

# Install our user

RUN groupadd -g 1004 $group && useradd $user -u 7777 -g 1004 -m -s /bin/bash
RUN passwd -d $user

USER $user

# Install pyenv
RUN curl https://pyenv.run | bash
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"\ncommand -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"\neval "$(pyenv init -)"' >> ~/.bashrc
RUN touch $HOME/.hushlogin

# Install latest python
# RUN $HOME/.pyenv/bin/pyenv install 3.11


# Nice to have
WORKDIR $home

RUN echo `whoami`
RUN echo `pwd`

RUN git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt
RUN cd sexy-bash-prompt
WORKDIR $home/sexy-bash-prompt
RUN make install



USER root
RUN rm -rf $home/sexy-bash-prompt
WORKDIR /

EXPOSE 8000
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]


