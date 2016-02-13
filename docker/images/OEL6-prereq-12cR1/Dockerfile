FROM s4ragent/oracle-rac:OEL6-prereq-Common
ENV MOUNT_PATH /u01
ENV ORA_ORACLE_BASE /u01/app/oracle
ENV ORA_ORACLE_HOME /u01/app/oracle/product/12.1.0/dbhome_1
ENV GRID_ORACLE_BASE /u01/app/grid
ENV GRID_ORACLE_HOME /u01/app/12.1.0/grid
ENV ORAINVENTORY /u01/app/oraInventory
## .bashrc ###
RUN echo -e "#this is for oracle install#\n\
if [ -t 0 ]; then\n\
        stty intr ^C\n\
fi" >> /home/oracle/.bashrc && \
cat /home/oracle/.bashrc > /home/grid/.bashrc && \
cat /home/oracle/.bashrc > /home/oracleja/.bashrc && \
cat /home/oracle/.bashrc > /home/gridja/.bashrc
## .bash_profile ###
RUN echo -e "### for oracle install ####\n\
export ORACLE_BASE=${ORA_ORACLE_BASE}\n\
export ORACLE_HOME=${ORA_ORACLE_HOME}\n\
" >> /home/oracle/.bash_profile
RUN echo -e "export TMPDIR=/tmp\n\
export TEMP=/tmp\n\
export PATH=\$ORACLE_HOME/bin:\$ORACLE_HOME/jdk/bin:\${PATH}\n\
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib\n\
" >> /home/oracle/.bash_profile && \
cat /home/oracle/.bash_profile > /home/oracleja/.bash_profile
RUN echo -e "### for oracle install ####\n\
export ORACLE_BASE=${GRID_ORACLE_BASE}\n\
export ORACLE_HOME=${GRID_ORACLE_HOME}\n\
" >> /home/grid/.bash_profile
RUN echo -e "export TMPDIR=/tmp\n\
export TEMP=/tmp\n\
export PATH=\$ORACLE_HOME/bin:\$ORACLE_HOME/jdk/bin:\${PATH}\n\
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib\n\
" >> /home/grid/.bash_profile && \
cat /home/grid/.bash_profile > /home/gridja/.bash_profile &&\
echo "export LANG=ja_JP.UTF-8" >> /home/oracleja/.bash_profile &&\
echo "export LANG=ja_JP.UTF-8" >> /home/gridja/.bash_profile
## create oraclehome
RUN  mkdir ${MOUNT_PATH} && \
     chown grid:oinstall ${MOUNT_PATH} && \
     mkdir -p ${GRID_ORACLE_BASE} && \
     mkdir -p ${GRID_ORACLE_HOME} && \
     chown -R grid:oinstall ${MOUNT_PATH} && \
     mkdir -p ${ORA_ORACLE_BASE} && \
     chown oracle:oinstall ${ORA_ORACLE_BASE} && \
     chmod -R 775 ${MOUNT_PATH}
