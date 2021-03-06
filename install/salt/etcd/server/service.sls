{% if pillar.etcd.server.enabled %}

pull-etcd-image:
  cmd.run:
    - name: docker pull {{ pillar.etcd.server.get('image', 'rainbond/etcd:v3.2.13') }}

etcd-env:
  file.managed:
    - source: salt://etcd/install/envs/etcd.sh
    - name: {{ pillar['rbd-path'] }}/etc/envs/etcd.sh
    - template: jinja
    - makedirs: Ture
    - mode: 644
    - user: root
    - group: root

etcd-script:
  file.managed:
    - source: salt://etcd/install/scripts/start.sh
    - name: {{ pillar['rbd-path'] }}/etcd/scripts/start.sh
    - makedirs: Ture
    - template: jinja
    - mode: 755
    - user: root
    - group: root

/etc/systemd/system/etcd.service:
  file.managed:
    - source: salt://etcd/install/systemd/etcd.service
    - template: jinja
    - user: root
    - group: root

etcd:
  service.running:
    - enable: True
  cmd.run:
    - name: systemctl restart etcd
    - watch:
      - file: {{ pillar['rbd-path'] }}/etcd/scripts/start.sh
      - file: {{ pillar['rbd-path'] }}/etc/envs/etcd.sh
      - cmd: pull-etcd-image
    - require:
      - file: /etc/systemd/system/etcd.service
      - file: etcd-script
      - file: etcd-env
      - cmd: pull-etcd-image
  

{% endif %}

