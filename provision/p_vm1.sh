sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl enable apache2

sudo rm -rf /var/www/html
sudo ln -fs /vagrant /var/www/html
