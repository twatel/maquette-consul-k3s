# maquette-consul-k3s

This repository has goal to install Consul & Kubernetes cluster realy quickly for testing.  

## Create development environment 
### Setup environment 
```shell
sudo make install-python
sudo apt-get install direnv -y
if [ ! "$(grep -ir "direnv hook bash" ~/.bashrc)" ];then echo 'eval "$(direnv hook bash)"' >> ~/.bashrc; fi && direnv allow . && source ~/.bashrc
make env prepare
```

### Setup machines
```shell
make test_vbox
```

### Clean up environment
```shell
make clean
```

### Display makefile helper
```shell
make help
```
