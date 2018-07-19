[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/X360Advance/blob/master/README.md) 
[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/X360Advance/blob/master/README.EN.md) 
# X360Advance (XInput) 
Гироскоп для Xbox геймпада, который позволяет использовать его как руль, а также помогать более точно прицеливаться. Использовать можно любой трекер, поддерживаемый OpenTrack (например, Arduino + GY-85).<br>
![](https://user-images.githubusercontent.com/9499881/27588504-749af800-5b59-11e7-92e4-2b3813428281.png)<br>
Есть 3 режима использования:<br>
1. FPS - смещение стика наклонами гироскопа (LB + RB + BACK)
2. Руль - полная эмуляция левого стика гироскопом (LB + RB + START)
3. По умолчанию - отсуствие использования гироскопа (LB + RB + BACK + START)
## Настройка
Загрузите и установите последнюю версию [OpenTrack](https://github.com/opentrack/opentrack/releases) и запустите её. 
<br><br>
В настройках OpenTrack необходимо выбрать как источник данных ваш трекер (настройте его, если необходимо), например, "FreePie UDP receiver", а выходной интерфейс: "freetrack 2.0 Enhanced". Далее нажать кнопку "Запустить".
<br><br>
Запустите приложение "XInputTest.exe" для проверки XInput библиотеки. Попробуйте наклонить трекер в разные стороны, переключайте режимы. В OpenTrack можно настроить слепые зоны и чувствительность (кривые и фильтр).
<br><br>
Возможно, что вам придется обменять местами Yaw, Pitch или Roll, в настройках профиля OpenTrack. 
<br><br>
В "X360Advance.ini" можно изменить чувствительность руля и вращения камеры для режима FPS.
<br><br>
После настройки необходимо скопировать файлы "xinput1_3.dll" (для 32 битных игр, а для 64 битных скопировать "xinput1_3x64.dll" и переименовать в "xinput1_3.dll") и "X360Advance" в папку с игрой, и запустить игру. Возможно, для некоторых игр придется переименовать "xinput1_3.dll" в одно из названий: "xinput1_4.dll" (Windows 8 / metro apps only), "xinput1_2.dll", "xinput1_1.dll" или "xinput9_1_0.dll".
## Загрузка
>Версия для Windows XP, 7, 8.1, 10.<br>
**[Загрузить](https://github.com/r57zone/X360Advance/releases)**<br>
## Обратная связь
`r57zone[собака]gmail.com`
