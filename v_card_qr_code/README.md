# ProfileApp
Solução Profile App.<br/>
Aplicação é capaz de gerar um qr code para compartilhar um virtual card gerado a partir de dados, podendo ser inputados via apliação ou colhidos de um contato da agenda do dispositivo.

## App Info
Enviroment:<br/>
[✓] Flutter (Channel stable, 3.19.5, on macOS 14.5 23F79 darwin-arm64, locale en-BR)<br/>
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)<br/>
[✓] Xcode - develop for iOS and macOS (Xcode 15.4)<br/>
[✓] Chrome - develop for the web<br/>
[✓] Android Studio (version 2024.1)<br/>
[✓] VS Code (version 1.90.2)<br/>

## VSCode launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "v_card_qr_code",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "v_card_qr_code (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile"
        },
        {
            "name": "v_card_qr_code (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release"
        }
    ]
}