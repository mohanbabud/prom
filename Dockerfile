FROM ubuntu:focal AS snap-installer

RUN set -eux; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		jq curl ca-certificates squashfs-tools; \
# taken from https://snapcraft.io/docs/build-on-docker
# Alternatively, we can install snapd, and issue `snap download prometheus`
	curl -L -H 'Snap-CDN: none' $(curl -H 'X-Ubuntu-Series: 16'  -H "X-Ubuntu-Architecture: $(dpkg --print-architecture)" 'https://api.snapcraft.io/api/v1/snaps/details/prometheus?channel=20.04/edge' | jq '.download_url' -r) --output prometheus.snap; \
	mkdir -p /snap; \
	unsquashfs -d /snap/prometheus prometheus.snap

FROM ubuntu:focal

ENV TZ UTC

RUN set -eux; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		tzdata ca-certificates; \
	rm -rf /var/lib/apt/lists/*; \
	mkdir -p /prometheus

COPY --from=snap-installer /snap/prometheus/bin/prometheus /usr/bin/prometheus
COPY --from=snap-installer /snap/prometheus/bin/promtool /usr/bin/promtool
COPY --from=snap-installer /snap/prometheus/etc/prometheus/prometheus.yml.example /etc/prometheus/prometheus.yml

# Copy the manifest files from the snap
COPY --from=snap-installer /snap/prometheus/snap/snapcraft.yaml /usr/share/rocks/
COPY --from=snap-installer /snap/prometheus/snap/manifest.yaml /usr/share/rocks/

# Expose port, configure volume and define the entrypoint
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/usr/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus" ]
