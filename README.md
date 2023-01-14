# EMUZ80-LED
MEZ80LED基板でEMUZ80に増設した7セグメントLEDの制御を追加したファームウェアです。
オリジナルのEMUZ80ファームウェアに機能を追加しました。

LED制御レジスタを0xF000 - 0xF01Fに配置します。

![MEZ80LED](https://github.com/satoshiokue/EMUZ80-LED/blob/main/MEZ80LED.jpeg)

MEZ80LED  
https://github.com/satoshiokue/MEZ80LED

PICはZ80を/BUSREQで停止させてLEDを制御します。  

ソースコードは電脳伝説さんのEMUZ80用main.cを元に改変してGPLライセンスに基づいて公開するものです。

## ファームウェア
emuz80_led.cをEMUZ80で配布されているフォルダemuz80.X下のmain.cと置き換えて使用してください。  
ターゲットのPICを適切に変更してビルドしてください。  


## アドレスマップ
```
ROM   0x0000 - 0x3FFF 16Kbytes
RAM   0x8000 - 0x8FFF 4Kbytes (0x9FFF 8Kbytes:PIC18F47Q84,PIC18F47Q83)

UART  0xE000   Data REGISTER
      0xE001   Control REGISTER

LED   0xF000 - 0xF01F
```

## PICプログラムの書き込み
EMUZ80技術資料8ページにしたがってPICに適合するemuz80led_Qxx.hexファイルを書き込んでください。  

またはArduino UNOを用いてPICを書き込みます。  
https://github.com/satoshiokue/Arduino-PIC-Programmer

BASIC  
PIC18F47Q43 emuz80led_Q43.hex  
PIC18F47Q83 emuz80led_Q8x.hex  
PIC18F47Q84 emuz80led_Q8x.hex  

DEMO LEDトレースモードでBASICを起動します  
PIC18F47Q43 emuz80led_DEMO_Q43.hex  
PIC18F47Q83 emuz80led_DEMO_Q8x.hex  
PIC18F47Q84 emuz80led_DEMO_Q8x.hex  

Universal Monitor Z80  
PIC18F47Q43 emuz80led_unimon_Q43.hex  
PIC18F47Q83 emuz80led_unimon_Q8x.hex 
PIC18F47Q84 emuz80led_unimon_Q8x.hex  

MITライセンスのUniversal MonitorをEMUZ80用に改変してhexファイル化しました。  
Universal Monitor  
https://electrelic.com/electrelic/node/1317

変更点はunimon_z80フォルダを参照してください。  

## Z80プログラムの改編
バイナリデータをテキストデータ化してファームウェアの配列rom[]に格納するとZ80で実行できます。

テキスト変換例
```
xxd -i -c16 foo.bin > foo.txt
```

## トレースモード
0xF006 Trace modeで表示方法を選択、0xF004 Display modeを0x04にするとトレースモードに入ります。  
Z80が取得するバスの状態を表示します。Z80が実行中の命令ではありません。  
LED表示は左から4桁がアドレス、2桁がリードで消灯、ライトでドットが点灯、右2桁がデータです。  

LED表示のウェイトは150ミリ秒です。  
ウェイトはソースコードの130行目で指定しています。  
```
#define WAIT_LED_TRACE 150	// 150 msec
```

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
|Bit|7|6|5|4|3|2|1|0|
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Segment Line|DP|A|B|C|D|E|F|G|
## 0xF018 - 0xF01F No-Decode bank2
1になったデータビットに対応したセグメントが点灯  
0xF004 Display modeに0x02(=Select bank2)を書き込むと表示更新
|Bit|7|6|5|4|3|2|1|0|
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Segment Line|DP|A|B|C|D|E|F|G|

## BASICによる制御例

LED全点灯、消灯
```
POKE &HF000,255
POKE &HF000,0
```

&HF000-&HF003の値をLEDに表示
```
POKE &HF004,3
POKE &HF000,&h12
POKE &HF001,&h34
POKE &HF002,&hAB
POKE &HF003,&hCD
```

## 参考）EMUZ80
EUMZ80はZ80CPUとPIC18F47Q43のDIP40ピンIC2つで構成されるシンプルなコンピュータです。

![EMUZ80](https://github.com/satoshiokue/EMUZ80-6502/blob/main/imgs/IMG_Z80.jpeg)

電脳伝説 - EMUZ80が完成  
https://vintagechips.wordpress.com/2022/03/05/emuz80_reference  

EMUZ80専用プリント基板 - オレンジピコショップ  
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-051.html
