# bolid-arm-s3000-doc / docker-linux

# АРМ С3000: установка образов Docker в ОС Linux



## Введение
Руководство предназначено для системных администраторов,
выполняющих установку и начальную настройку **АРМ С3000**
с использованием [Docker](https://www.docker.io)
в операционных системах семейства Linux.



## Системные требования
Поддерживаются следующие операционные системы:
- Astra Linux Special Edition 1.7 («Орел», «Воронеж», «Смоленск»)
- Alpine Linux 3.16.2
- Ubuntu Linux 20.04 LTS («Focal Fossa»), 22.04 LTS («Jammy Jellyfish»)

Для каждой из систем предоставляется свой образ `Docker`.



## Установка ПО Docker

### Astra Linux

* Установить пакет `docker.io`:
```sh
$ sudo apt install docker.io
```

* Запустить службу `Docker`:
```sh
$ sudo systemctl start docker
```

* Включить автоматический запуск службы:
```sh
$ sudo systemctl enable docker
```

* При необходимости, разрешить работу с `Docker` непривилегированным
пользователям. Например, для пользователя *USER_NAME*:
```sh
$ sudo usermod -a -G docker USER_NAME
```

* Для использования `Docker` в непривилегированном (*rootless*) режиме
(служба `Docker` запускается без прав суперпользователя, `root`):
    1. Установить пакет `rootless-helper-astra`:
    ```sh
    $ sudo apt install rootless-helper-astra
    ```
    2. Запустить службу `Docker` от имени пользователя *USER_NAME*:
    ```sh
    $ sudo systemctl start rootless-docker@USER_NAME
    ```
    3. Включить автоматический запуск службы от имени пользователя *USER_NAME*:
    ```sh
    $ sudo systemctl start rootless-docker@USER_NAME
    ```

Официальная документация:
[Установка и администрирование Docker в Astra Linux 1.7](https://wiki.astralinux.ru/pages/viewpage.action?pageId=158601444)


### Alpine Linux

* Установить пакет `docker` (находится в [репозитории](https://wiki.alpinelinux.org/wiki/Repositories) «community»):
```sh
# apk add docker
```

* Запустить службу `Docker`:
```sh
# service docker start
```

* Включить автоматический запуск службы:
```sh
# rc-update add docker boot
```

* При необходимости, разрешить работу с `Docker` непривилегированным
пользователям. Например, для пользователя *USER_NAME*:
```sh
# addgroup USER_NAME docker
```

### Ubuntu Linux
Предпочтительно устанавливать `Docker` из официального репозитория.

* Прежде всего, следует удалить пакеты `Docker`, установленные из
репозиториев Ubuntu:
```sh
$ sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

* Установить необходимые пакеты:
```sh
$ sudo apt-get install ca-certificates curl gnupg lsb-release
```

* Загрузить и добавить официальный GPG-ключ репозитория:
```sh
$ sudo mkdir -p /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

* Добавить репозиторий:
```sh
$ echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

После выполнения команды будет создан файл `/etc/apt/sources.list.d/docker.list`
следующего вида (приведён пример для Ubuntu 22.04 LTS «Jammy Jellyfish» на
машине с архитектурой `amd64`):
```
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian jammy stable
```

* Обновить список пакетов:
```sh
sudo apt update
```

* Установить пакеты `Docker`:
```sh
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

В случае успешной установки, служба `docker` будет запущена и добавлена
в автоматическую загрузку. Для проверки следует выполнить следующие
команды и убедиться в соответствии их вывода приведённому ниже:

```sh
$ systemctl status docker

docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2023-08-10 22:35:32 MSK; 22min ago
TriggeredBy: docker.socket
       Docs: https://docs.docker.com
   Main PID: 2054 (dockerd)
      Tasks: 9
     Memory: 43.1M
        CPU: 483ms
     CGroup: /system.slice/docker.service
             └─2054 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sockh

```

```sh
$ systemctl list-unit-files | grep -i docker

docker.service    enabled    enabled
docker.socket     enabled    enabled
```

* При необходимости, разрешить работу с `Docker` непривилегированным
пользователям. Например, для пользователя *USER_NAME*:
```sh
$ sudo usermod -a -G docker USER_NAME
```

