# АРМ С3000: установка образов Docker в ОС Windows



## Введение

Руководство предназначено для системных администраторов,
выполняющих установку и начальную настройку **АРМ С3000**
с использованием [Docker](https://www.docker.io)
в операционных системах Windows.



## Соглашения и условные обозначения

- **Полужирным** выделяются названия программных продуктов и аппаратных средств.
- *Курсив* применяется для обозначения технических терминов
  и в иных случаях для выделения частей текста.
- `Моноширинный шрифт` применяется для имен файлов, команд и их параметров,
  а также для примеров выполнения и вывода команд.
- Команды, запускаемые в `Windows PowerShell` показаны
  с приглашением командной строки вида `PS>`.
- **Внимание:** - важные замечания.



## Сокращения

- ОС — операционная система
- ПО — программное обеспечение



## Системные требования

- Windows 10 Home, Pro, Enterprise, Education версии 21H1 (сборка 19044) и выше
- Windows 11 Home, Pro, Enterprise, Education версии 21H1 (сборка 19044) и выше
- WSL (Windows Subsystem for Linux) версии 2
- 64-разрядный процессор с поддержкой SLAT (Second Level Address Translation)
- не менее 4 Гб оперативной памяти
- включенная поддержка аппаратной виртуализации в BIOS



## Подготовка к работе

Включить аппаратную виртуализацию в настройках BIOS.

Установить компоненты «Платформа виртуальной машины»
и «Подсистема Windows для Linux»
в панели управления: *`Программы и компоненты`* →
*`Включение или отключение компонентов Windows`*
(*`Programs and Features`* → *`Turn Windows features on or off`*).

**Внимание:**<br />
Запуск программ установки и выполнение команд `Windows PowerShell`
должны осуществляться от имени *администратора* системы.



## Установка дистрибутива Linux в WSL

Убедиться в наличии подключения к сети Интернет.

Перед началом работы рекомендуется запустить обновление:
```
PS> wsl --update
```

Установить значение используемой версии `WSL`
```
PS> wsl --set-default-version 2
```

Проверить, что значение установлено верно:
```
PS> wsl --status

Версия по умолчанию: 2
...
```

Вывести список доступных дистрибутивов:
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

Запустить установку (используется дистрибутив `Ubuntu`):
```
PS> wsl --install --distribution Ubuntu
```

В новом окне консоли появится предложение создать пользователя Linux.
Следует задать имя и пароль (пароль при вводе не отображается):

```
Installing, this may take a few minutes...
Please create a default UNIX user account.
The username does not need to match your Windows username.
For more information visit: https://aka.ms/wslusers
Enter new UNIX username: myuser
New password:
Retype new password:
```

Проверить успешность установки дистрибутива и его работы
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



## Установка ПО Docker

Загрузить дистрибутив `Docker Desktop for Windows` со страницы
https://docs.docker.com/desktop/install/windows-install.

Выполнить установку, включив параметр `Use WSL 2 instead of Hyper-V`
в окне `Configuration` программы установки.



## Подготовка контейнера

Импортировать образ в локальный репозиторий **Docker**:
```
PS> docker load --input arm-s3000-astra-smolensk_1.7-VERSION.tar.xz
```

Здесь и далее, *VERSION* в имени файла следует заменить на номер
версии образа, с которым фактически происходит работа.
Например, для версии `1.01.654.182`, имя файла будет выглядеть как
`arm-s3000-astra-smolensk_1.7-1.01.654.182.tar.xz`.

Создать том **Docker** для хранения данных контейнера.
`arm-s3000-volume` в команде — произвольное имя тома
(должно быть уникальным в пределах локальной ОС):

```
PS> docker volume create arm-s3000-volume
```



## Запуск контейнера
Команду запуска контейнера удобнее всего поместить в
пакетный файл:

```
PS> cat docker-windows-run.bat

@echo off
::
:: docker-windows-run.bat: пакетный файл запуска контейнера Docker
::
:: Запуск из текущей папки: .\docker-windows-run.bat
:: Примечание: символ ^ используется для переноса строк
::
docker run ^
    --name arm-s3000 ^
    --volume arm-s3000-volume:/persist ^
    --restart=always ^
    --publish 20080:80 ^
    --publish 20043:443 ^
    arm-s3000-astra-smolensk_1.7:VERSION
```

Команде `docker run` передаются следующие параметры:
- `--name arm-s3000`<br />
  Произвольное имя контейнера для использования в командах `docker`.
- `--volume arm-s3000-volume:/persist`<br />
  Имя тома, созданного командой `docker volume create`.
  `/persist` — папка в контейнере, где будет cмонтирован том.
- `--restart=always`<br />
  Автоматический перезапуск контейнера в случае завершения его работы.
- `--publish 20080:80 --publish 20043:443`<br />
  Перенаправление портов TCP. Соединение с портом, указанным до `:`, на локальной
  системе будет перенаправлено на порт, указанный после `:`, в контейнере.
- `arm-s3000-astra-smolensk_1.7:VERSION`<br />
  Имя образа **Docker**. Про `VERSION` см. раздел «Подготовка контейнера» выше.

Запустить пакетный файл на выполнение:

```
PS> .\docker-windows-run.bat

[INFO]: Start all services...
[INFO]: Service container_init exited with: 0 (EXIT OK)
[INFO]: Service container_init entered RUNNING state (by EXIT OK)
[INFO]: Service postgresql entered RUNNING state (by time 3.0)
[INFO]: Service db_update exited with: 0 (EXIT OK)
[INFO]: Service db_update entered RUNNING state (by EXIT OK)
[INFO]: Service adapter entered RUNNING state (by JSON RPC)
[INFO]: Service config_service entered RUNNING state (IMMEDIATELY)
[INFO]: Service log_service entered RUNNING state (IMMEDIATELY)
[INFO]: Service cert_mgr entered RUNNING state (IMMEDIATELY)
[INFO]: Service device_info entered RUNNING state (by JSON RPC)
[INFO]: Service auth entered RUNNING state (by JSON RPC)
[INFO]: Service notificator entered RUNNING state (by JSON RPC)
[INFO]: Service gate entered RUNNING state (by JSON RPC)
[INFO]: Service nginx entered RUNNING state (IMMEDIATELY)
```

Вывод команды, подобный приведенному, говорит об успешном запуске контейнера.

Теперь соединение с системой **АРМ С3000** возможно на всех сетевых
интерфейсах и заданных портах, например:
`http://127.0.0.1:20080` или `https://127.0.0.1:20043`.

<!--
**TODO**: error in *orig manual*: don't close `PS` console!
-->



## Перенаправление портов UDP

<!--
**TODO**: [need it?](docker-compare-toc.md)?
**TODO**: port spec in arm-s3000 web interface
- 20500 - port on localhost (?)
- 60500 - port on s2000-ether
-->

Перенаправление портов UDP может потребоваться:
- При подключении приборов к **АРМ С3000** через устройство **С2000-Ethernet**
  в том случае, если в настройках **С2000-Ethernet** отключен параметр
  «Использовать один UDP-порт на чтение и запись».
- В случае возникновения проблем при использовании NAT.

Для этого необходимо передать команде `docker run` параметр вида
`--publish 20500:60500/udp`. Где до `:` указан порт на локальной
системе, а после `:` — порт в контейнере.

Номера портов на локальной системе могут принимать значения от 2048 до 65535.

