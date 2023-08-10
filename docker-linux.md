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
$ sudo usermod -aG docker USER_NAME
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

