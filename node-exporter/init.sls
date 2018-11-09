{% from 'node-exporter/map.jinja' import node_exporter with context %}

node-exporter-repo-key:
  cmd.run:
    - name: rpm --import https://copr-be.cloud.fedoraproject.org/results/ibotty/prometheus-exporters/pubkey.gpg
    - unless: rpm -qi gpg-pubkey-ba0b8fc6

node-exporter-repo:
  pkgrepo.managed:
    - humanname: Copr repo for prometheus-exporters owned by ibotty
    - baseurl: {{ node_exporter.repo }}
    - gpgcheck: 1
    - gpgkey: https://copr-be.cloud.fedoraproject.org/results/ibotty/prometheus-exporters/pubkey.gpg
    - require:
      - cmd: node-exporter-repo-key

node-exporter:
  pkg.installed:
    - name: golang-github-prometheus-node_exporter
    - require:
      - pkgrepo: node-exporter-repo

  service.running:
    - name: node_exporter
    - enable: True
    - require:
      - pkg: node-exporter
