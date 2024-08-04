# bark-simple-webui
GNU/Linux installer and launcher for Suno's [Bark TTS](https://github.com/suno-ai/bark) with simple webui from [Fictiverse](https://github.com/Fictiverse/bark).

# Manual Usage
1. Install [miniconda](https://docs.anaconda.com/miniconda/#quick-command-line-install).
1. Clone this repo: `git clone https://github.com/inimrod/bark-simple-webui.git && cd bark-simple-webui`.
1. Update vars in `run.sh` and add execute permission: `chmod +x run.sh`.
1. Run: `./run.sh`.

# Running as `systemd` service

Edit `systemd` service file as appropriate:

```shell
USERNAME=$USER
INSTALL_DIR="/home/$USERNAME/src/bark-simple-webui"

sudo tee /etc/systemd/system/bark.service > /dev/null <<EOF
[Unit]
Description=bark-ai daemon
After=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=10
User=$USERNAME
Group=$USERNAME
WorkingDirectory=$INSTALL_DIR
Environment=RUNNING_IN_SYSTEMD=1
ExecStart=/usr/bin/bash run.sh
KillSignal=SIGINT
SyslogIdentifier=BARK
TimeoutStopSec=10

[Install]
WantedBy=default.target
EOF

systemctl enable bark.service
systemctl daemon-reload
systemctl start bark.service
```

Monitor logs with:
```shell
sudo journalctl -f -u bark.service -n100
```

Stop service with:
```shell
sudo systemctl stop bark.service
```