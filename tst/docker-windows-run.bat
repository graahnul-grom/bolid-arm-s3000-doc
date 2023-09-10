@echo off
::
:: docker-windows-run.bat: пакетный файл запуска контейнера Docker
::
:: Примечание: символ ^ используется для переноса строк
::
docker run ^
    --name arm-s3000 ^
    --volume VOLUME_NAME:/persist ^
    --restart=always ^
    --publish 20080:80 ^
    --publish 20043:443 ^
    arm-s3000-astra-smolensk_1.7:1.01.654.182
