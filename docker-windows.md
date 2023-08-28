# bolid-arm-s3000-doc / docker-windows

# АРМ С3000: установка образов Docker в ОС Windows



## Введение

Руководство предназначено для системных администраторов,
выполняющих установку и начальную настройку **АРМ С3000**
с использованием [Docker](https://www.docker.io)
в операционных системах Windows.

- **TODO**: exe runs - as admin
- **TODO**: all `PS>` commands - in admin `PS`.



## Соглашения и условные обозначения

- **Полужирным** выделяются названия программных продуктов и аппаратных средств.
- *Курсив* используется для обозначения технических терминов и параметров,
  задаваемых пользователем.
- `Моноширинный шрифт` применяется для имен файлов, команд и их параметров,
  а также для примеров выполнения и вывода команд.
- Команды, запускаемые в `Windows PowerShell` предваряются
  приглашением командной строки вида `PS>`.
- **TODO**: win gui breadcrumbs
- **TODO**: web interface breadcrumbs



## Сокращения

ОС — операционная система<br />
ПО — программное обеспечение



## Системные требования

- Windows 10 Home, Pro, Enterprise, Education версии 21H1 (сборка 19044) и выше
- Windows 11 Home, Pro, Enterprise, Education версии 21H1 (сборка 19044) и выше
- WSL (Windows Subsystem for Linux) версии 2
- 64-разрядный процессор с поддержкой SLAT
- не менее 4 Гб оперативной памяти
- включенная поддержка аппаратной виртуализации в BIOS



## Подготовка к работе: **TODO**

- [x] virt tech in BIOS (chk in task mgr)
- control panel->programs and features->turn windows features on or off
  - [x] virt machine platform
  - [x] wsl

### NB
```
PS adm> Get-WindowsOptionalFeature -Online

FeatureName : Microsoft-Windows-Subsystem-Linux
State       : Enabled

FeatureName : VirtualMachinePlatform
State       : Enabled
```



## Установка дистрибутива Linux в WSL

- Убедиться в наличии подключения к сети Интернет

- Перед началом работы рекомендуется запустить обновление:
```
PS> wsl --update
```

- Установить значение используемой версии `WSL`
```
PS> wsl --set-default-version 2
```

- Убедиться, что значение установлено верно:
```
PS> wsl --status

Версия по умолчанию: 2
...
```

- Вывести список доступных дистрибутивов:
```
PS> wsl --list --online

NAME            FRIENDLY NAME
Ubuntu          Ubuntu
Debian          Debian GNU/Linux
kali-linux      Kali Linux Rolling
openSUSE-42     openSUSE Leap 42
SLES-12         SUSE Linux Enterprise Server v12
Ubuntu-16.04    Ubuntu 16.04 LTS
Ubuntu-18.04    Ubuntu 18.04 LTS
Ubuntu-20.04    Ubuntu 20.04 LTS
```

- Использоваться будет `Ubuntu`; запустить установку:
```
PS> wsl --install --distribution Ubuntu
```

В новом окне консоли появится предложение создать
пользователя Linux. Следует задать имя и пароль (пароль при вводе не отображается):

```
Installing, this may take a few minutes...
Please create a default UNIX user account. The username does not need to match your Windows username.
For more information visit: https://aka.ms/wslusers
Enter new UNIX username: myuser
New password:
Retype new password:
```

- Проверить успешность установки дистрибутива и его работы
командой `wsl --list --verbose`, а также непосредственным запуском,
указав имя дистрибутива в качестве команды (`Ubuntu`):
```
PS> wsl --list --verbose

  NAME      STATE           VERSION
* Ubuntu    Running         2
```

```
PS> Ubuntu

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

myuser@myhost:~$
```



## Установка ПО Docker: **TODO**

- Загрузить дистрибутив `Docker Desktop for Windows` со страницы
https://docs.docker.com/desktop/install/windows-install **TODO**: check version?

- Выполнить установку, включив параметр `Use WSL 2 instead of Hyper-V`
  в окне `Configuration` программы установки.

- autorun:
  - **TODO**: there's an entire "autorun" section in orig:
  - `[x]` in docker settings + `--restart=always` in `docker run`



## Подготовка контейнера

- Импортировать образ в локальный репозиторий **Docker**:
```
PS> docker load --input arm-s3000-astra-smolensk_1.7-VERSION.tar.xz
```
Здесь и далее, *VERSION* в имени файла следует заменить на номер
версии образа, с которым фактически происходит работа.
Например, для версии `1.01.654.182`, имя файла будет выглядеть как
`arm-s3000-astra-smolensk_1.7-1.01.654.182.tar.xz`.

- Создать том **Docker** для хранения данных контейнера.
  `arm-s3000-volume` в команде — произвольное имя тома
  (должно быть уникальным в пределах локальной ОС):

```
PS> docker volume create arm-s3000-volume
```



## Запуск контейнера

Для запуска контейнера удобнее всего поместить команду `docker run`
в файл `BAT` (`^` используется для переноса строки):

```
PS> cat docker-windows-run.bat

@echo off
docker run ^
    --name arm-s3000 ^
    --volume VOLUME_NAME:/persist ^
    --restart=always ^
    --publish 20080:80 ^
    --publish 20043:443 ^
    arm-s3000-astra-smolensk_1.7:1.01.654.182
```

Команде `docker run` передаются следующие параметры:
* `--name arm-s3000`
  Произвольное имя контейнера для использования в командах `docker(1)`.
* `--volume VOLUME_NAME:/persist`
  Имя тома (*VOLUME_NAME*), созданного командой `docker volume create`
  (см. раздел «Подготовка контейнера» выше).
  `/persist` — папка в контейнере, где будет cмонтирован том.
* `--restart=always`
  Автоматический перезапуск контейнера в случае завершения его работы.
* `--publish 20080:80 --publish 20043:443`
  Перенаправление портов TCP. Соединение с портом, указанным до `:`, на локальной
  системе будет перенаправлено на порт, указанный после `:`, в контейнере.
* `arm-s3000-astra-smolensk_1.7:VERSION`
  Имя образа **Docker**.

Запустить файл `BAT`:

```
PS> .\docker-windows-run.bat

2023.08.25 17:20:49.953 MAIN [INFO]: Start all services...
2023.08.25 17:20:50.622 MAIN [INFO]: Service container_init exited with: 0 (EXIT OK)
2023.08.25 17:20:50.623 MAIN [INFO]: Service container_init entered RUNNING state (by EXIT OK)
2023.08.25 17:20:53.632 MAIN [INFO]: Service postgresql entered RUNNING state (by time 3.0)
2023.08.25 17:20:54.346 MAIN [INFO]: Service db_update exited with: 0 (EXIT OK)
2023.08.25 17:20:54.346 MAIN [INFO]: Service db_update entered RUNNING state (by EXIT OK)
2023.08.25 17:20:56.608 MAIN [INFO]: Service adapter entered RUNNING state (by JSON RPC)
2023.08.25 17:20:56.617 MAIN [INFO]: Service config_service entered RUNNING state (IMMEDIATELY)
2023.08.25 17:20:56.617 MAIN [INFO]: Service log_service entered RUNNING state (IMMEDIATELY)
2023.08.25 17:20:56.617 MAIN [INFO]: Service cert_mgr entered RUNNING state (IMMEDIATELY)
2023.08.25 17:20:57.081 MAIN [INFO]: Service device_info entered RUNNING state (by JSON RPC)
2023.08.25 17:20:57.087 MAIN [INFO]: Service auth entered RUNNING state (by JSON RPC)
2023.08.25 17:20:59.029 MAIN [INFO]: Service notificator entered RUNNING state (by JSON RPC)
2023.08.25 17:20:59.746 MAIN [INFO]: Service gate entered RUNNING state (by JSON RPC)
2023.08.25 17:20:59.748 MAIN [INFO]: Service nginx entered RUNNING state (IMMEDIATELY)
```

Вывод команды, подобный приведенному выше, говорит об успешном запуске контейнера.

Теперь соединение с системой **АРМ С3000** возможно на всех сетевых
интерфейсах и портах, указанных выше, например:
`http://127.0.0.1:20080` или `https://127.0.0.1:20043`.

**NB**: error in *orig manual*: don't close `PS` console!



## Перенаправление портов UDP - **TODO**: port spec. in arm-s3000 web iface

Перенаправление портов UDP может потребоваться:
1. При подключении приборов к **АРМ С3000** через устройство **С2000-Ethernet**
   в том случае, если в настройках **С2000-Ethernet** отключен параметр
   «Использовать один UDP-порт на чтение и запись».
2. В случае возникновения проблем при использовании NAT.

Для этого необходимо передать команде `docker run` параметр следующего
вида: `--publish 20497:64497/udp`. Где до `:` указан порт на локальной
системе, а после `:` — порт в контейнере.

Номера портов на локальной системе могут принимать значения от 2048 до 65535.
