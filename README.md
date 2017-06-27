# Гироскоп для Xbox геймпада (XInput) (Ru)
Гироскоп для Xbox геймпада, который позволяет использовать его как руль, а также помогать более точно прицеливаться. Использовать можно любой трекер, поддерживаемый OpenTrack (например, Arduino + GY-85).<br>
![](https://user-images.githubusercontent.com/9499881/27588504-749af800-5b59-11e7-92e4-2b3813428281.png)<br>
Есть 3 режима использования:<br>
1. FPS - смещение стика наклонами гироскопа (LB + RB + BACK)
2. Руль - полная эмуляция левого стика гироскопом (LB + RB + START)
3. По умолчанию - отсуствие использования гироскопа (LB + RB + BACK + START)
## Настройка
Загрузите и установите последнюю версию [OpenTrack](https://github.com/opentrack/opentrack/releases) и запустите её. 
<br><br>
В настройках OpenTrack необходимо выбрать как источник данных ваш трекер (настройте его, если необхимо), а выходной интерфейс: "UDP over network". Далее нажать кнопку "Запустить".
<br><br>
Запустите приложение "XInputTest.exe" для проверки, из загруженного архива. Попробуйте наклонить трекер в разные стороны, переключайте режимы. В OpenTrack можно настроить слепые зоны и чувствительность (кривые и фильтр).
<br><br>
Возможно, что вам придется обменять местами Yaw, Pitch или Roll, в настройках профиля OpenTrack. 
<br><br>
В "WheelSetup.ini" можно изменить угол вращения руля. 
<br><br>
После настройки необходимо скопировать файлы "xinput1_3.dll" и "WheelSetup.ini" в папку с игрой, и запустить игру. Возможно, для некоторых старых игр, придется переименовать "xinput1_3.dll" в одно из названий: "xinput1_4.dll" (Windows 8 / metro apps only), "xinput1_2.dll", "xinput1_1.dll" или "xinput9_1_0.dll".
## Загрузка
>Версия для Windows XP, 7, 8.1, 10.<br>
**[Загрузить](https://github.com/r57zone/Xbox-contoller-with-gyroscope)**<br>
## Обратная связь
`r57zone[собака]gmail.com`

# Gyroscope for Xbox controller (XInput) (En)
Gyroscope for the Xbox gamepad that allows you to use it as a steering wheel, and also help you more accurately aim. You can use any tracker supported by OpenTrack (for example, Arduino + GY-85).<br>
There are 3 modes of use:<br>
1. FPS - offset of the stick by gyro slopes (LB + RB + BACK)
2. Steering wheel - complete emulation of the left stick by the gyro (LB + RB + START)
3. By default - no gyro use (LB + RB + BACK + START)
## Setup
Download and install the latest version of [OpenTrack](https://github.com/opentrack/opentrack/releases) and run it.
<br><br>
In OpenTrack settings, you must select you tracker (and setup if need), and the output interface: "UDP over network". Then click the "Run" button.
<br><br>
Run the application "XInputTest.exe" to check, from the downloaded archive. Try tilting the tracker in different directions, switch modes. In OpenTrack, you can configure blind zones and sensitivity (curves and filter).
<br><br>
It is possible that you will have to exchange Yaw, Pitch or Roll in the OpenTrack profile settings.
<br><br>
In the "WheelSetup.ini" you can change the angle of rotation of the rudder.
<br><br>
After the configuration, you need to copy the files "xinput1_3.dll" and "WheelSetup.ini" to the folder with the game, and run the game. Perhaps for some older games, you will have to rename "xinput1_3.dll" to one of the names: "xinput1_4.dll" (Windows 8 / metro apps only), "xinput1_2.dll", "xinput1_1.dll" or "xinput9_1_0.dll" .
<br><br>
After starting the game, press "F9" and run the FreePie application for Android, enter the IP address of the computer and press the button. The "F10" button turns off the steering wheel.
## Download
>Version for Windows XP, 7, 8.1, 10.<br>
**[Download](https://github.com/r57zone/Xbox-contoller-with-gyroscope)**<br>
## Feedback
`r57zone[at]gmail.com`
