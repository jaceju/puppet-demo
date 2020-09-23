#!/usr/bin/env bash

echo -e "\n192.168.0.103\tpuppet-server.example.com puppet\n192.168.0.104\tpuppet-agent.example.com" | sudo tee -a /etc/hosts