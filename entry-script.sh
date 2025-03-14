#!/bin/bash
sudo set -e  # Stoppt das Skript, falls ein Fehler auftritt

# System Update und Docker Installation
sudo yum update -y
sudo yum install -y docker

# Docker starten und beim Booten aktivieren
sudo systemctl start docker
sudo systemctl enable docker

# Benutzer zur Docker-Gruppe hinzufügen
sudo usermod -aG docker ec2-user

# Wartezeit, um sicherzustellen, dass Docker vollständig läuft
sudo sleep 10

# Nginx-Container starten
sudo docker run -d -p 8080:80 --name nginx-container nginx

# Terraform Debugging: Schreibe Log-Dateien
echo "Docker Installation abgeschlossen" >> /var/log/user-data.log
