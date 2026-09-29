# Wraps the upstream prebuilt image (https://github.com/AstraeLabs/VibraVid, published to
# ghcr.io/astraelabs/vibravid by its docker-publish workflow). Bump this tag together with
# "version" in config.json to update.
FROM ghcr.io/astraelabs/vibravid:v1.3.6

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
