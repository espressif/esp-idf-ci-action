FROM espressif/idf:latest

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT export IDF_TARGET="${INPUT_TARGET}"; /entrypoint.sh
