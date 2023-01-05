# EMUZ80-LED
MEZ80LED基板でEMUZ80に増設した7セグメントLEDの制御を追加したファームウェアです。

LED制御レジスタを0xF000 - 0xF01Fに配置します。

![MEZ80LED](https://github.com/satoshiokue/EMUZ80-LED/blob/main/MEZ80LED.jpeg)

MEZ80LED  
https://github.com/satoshiokue/MEZ80LED

LEDを制御するとき、PICは/BUSREQでZ80を停止させます。

## トレースモード
0xF006 Trace modeで表示方法を選択、0xF004 Display modeを0x04にするとトレースモードに入ります。  
LED表示は左から4桁がアドレス、2桁がリードで消灯、ライトでドットが点灯、右2桁がデータです。  
Z80が取得するバスの状態を表示します。Z80が実行中の命令ではありません。  
LED表示のウェイトは150ミリ秒です。  

UARTを選択するとバスの内容が「すべて」取得できます。  
# Display control resistors
レジスタ初期値は0

## 0xF000-0xF003 HEX data

|Address|LED Position|
| --- | --- |
|0xF000|88 -- -- --|
|0xF001|-- 88 -- --|
|0xF002|-- -- 88 --|
|0xF003|-- -- -- 88|

書き込みで即時表示更新

## 0xF004 Display mode

|Code|Description|
| --- | --- |
|0x00| off  
|0x01| Select bank1  
|0x02| Select bank2  
|0x03| hex dump at 0xF000 - 0xF003  
|0x04| Trace mode  
|0xFF| "8.8.8.8. 8.8.8.8."  

## 0xF005 Display brightness
```
0x00(min) - 0x0f(max)  
```

## 0xF006 Trace mode

|Code|Description|
| --- | --- |
|0x00| off  
|0x01| LED Display  
|0x02| UART  
|0x03| LED & UART  

## 0xF010 - 0xF017 No-Decode bank1
1になったデータビットに対応したセグメントが点灯  
0xF004 Display modeに0x01(=Select bank1)を書き込むと表示更新
## 0xF018 - 0xF01F No-Decode bank2
1になったデータビットに対応したセグメントが点灯  
0xF004 Display modeに0x02(=Select bank2)を書き込むと表示更新
