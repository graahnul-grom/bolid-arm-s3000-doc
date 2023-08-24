# bolid-arm-s3000-doc / docker-windows

# АРМ С3000: установка образов Docker в ОС Windows



## Введение

Руководство предназначено для системных администраторов,
выполняющих установку и начальную настройку **АРМ С3000**
с использованием [Docker](https://www.docker.io)
в операционных системах Windows.



## Соглашения и условные обозначения

* **Полужирным** выделяются названия программных продуктов и аппаратных средств.
* *Курсив* используется для обозначения технических терминов и параметров,
  задаваемых пользователем.
* `Моноширинный шрифт` применяется для имен файлов, команд и их параметров,
  а также для примеров выполнения и вывода команд.
* Команды, запускаемые в `Windows PowerShell` предваряются
  приглашением командной строки вида `PS>`.



## Сокращения

ОС — операционная система<br />
ПК — персональный компьютер<br />
ПО — программное обеспечение



## Системные требования

- Windows 10 Home, Pro, Enterprise, Education версии 21H1 (сборка 19044) и выше
- Windows 11 Home, Pro, Enterprise, Education версии 21H1 (сборка 19044) и выше
- WSL (Windows Subsystem for Linux) версии 2
- 64-разрядный процессор с поддержкой SLAT
- 4 Гб оперативной памяти
- включенная поддержка аппаратной виртуализации в BIOS



## Подготовка среды WSL

*
```
PS> wsl --update
```

*
```
PS> wsl --set-default-version 2
```

*
```
PS> wsl --status
Версия по умолчанию: 2
...
...
```

*
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

*
```
PS> wsl --install --distribution Ubuntu
```
// // in another console window:
```
Installing, this may take a few minutes...
Please create a default UNIX user account. The username does not need to match your Windows username.
For more information visit: https://aka.ms/wslusers
Enter new UNIX username: bot
New password:
Retype new password:
```

*
```
PS> wsl --list --verbose

  NAME      STATE           VERSION
* Ubuntu    Running         2
```



## Установка ПО Docker

* download
https://docs.docker.com/desktop/install/windows-install
