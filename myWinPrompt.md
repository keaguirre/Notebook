# Setup para Windows Terminal & PowerShell
[Video Base](https://youtu.be/6SGIFVJ5Izs?si=lgTUnGTAOmVHm3gr)
1. Ir a MS Store y buscar Powershell e Instalar (Esto bajará la versión de pwshell más actualizada)
2. En Win Terminal ir a Settings y definir Default profile a PowerShell en lugar de Windows PowerShell
3. Cambiar Default terminal app de Let Windows decide por Windows Terminal
4. Para agregar Color schemes puedes ir a Open JSON file abajo a la izquierda y agregar este objeto por ejemplo usando dracula:
```javascript
"schemes": 
    [
        {
            "name": "Dracula",
            "background": "#282A36",
            "black": "#21222C",
            "blue": "#BD93F9",
            "brightBlack": "#6272A4",
            "brightBlue": "#D6ACFF",
            "brightCyan": "#A4FFFF",
            "brightGreen": "#69FF94",
            "brightPurple": "#FF92DF",
            "brightRed": "#FF6E6E",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFFA5",
            "cursorColor": "#F8F8F2",
            "cyan": "#8BE9FD",
            "foreground": "#F8F8F2",
            "green": "#50FA7B",
            "purple": "#FF79C6",
            "red": "#FF5555",
            "selectionBackground": "#44475A",
            "white": "#F8F8F2",
            "yellow": "#F1FA8C"
        }
]
```
5. Podemos obtener diversos ColorSchemes desde [Aquí](https://windowsterminalthemes.dev/)
6. El nuevo ColorScheme que hemos agregado que se encontrará definido con el name que está dentro del objeto una vez reiniciada la terminal.
7. En Appearance activar -> Use acrylic material in the tab row y guardar
8. Ahora iremos a [OhMyPosh](https://ohmyposh.dev/docs/installation/windows) y antes de seguir avanzando asegurate de tener winget instalado con el comando winget --version
9. ingresar -> winget install JanDeDobbeleer.OhMyPosh -s winget
10. Reabrir la terminal como Administrador e ingresar el comando oh-my-posh font install y luego usar el comando oh-my-posh font install [font-name] La recomendada es meslo, pero prefiero JetBrains Mono o Firacode
11. Settings, Default -> Appearance Font face -> Seleccionar la instalada anteriormente
12. volver a validar el comando oh-my-posh para validar que esta activo y en el path con exito
13. Get-PoshThemes para probar y encontrar un tema para nuestro prompt
14. notepad $PROFILE esto intentara abrir el archivo de configuraciones de nuestra terminal por defecto, si lanza un error The system cannot find the path specified Cerraremos el notepad e ingresaremos este nuevo comando New-Item -Path $PROFILE -Type File -Force
15. notepad $PROFILE, una vez abra el notepad, pegaremos este comando y guardaremos el archivo. oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\xtoys.omp.json" | Invoke-Expression
16. para seleccionar otro tema solo basta con que escribamos el nombre del tema de nuestra preferencia reemplazaremos la palabra 'xtoys' con el nombre del tema de nuestra preferencia.
17. Volveremos a ejecutar notepad $PROFILE y pegaremos el siguiente comando debajo del anterior: set-PsReadLineOption -PredictionViewStyle InlineView y guardaremos, esto hara que nos haga sugerencias en base a nuestro historial de la consola.
18. Por ultimo instalaremos zoxide para un cambio de directorios inteligente + las sugerencias en base al historial con `winget install ajeetdsouza.zoxide` y luego agregaremos `Invoke-Expression (& { (zoxide init powershell | Out-String) })` debajo de notepad $PROFILE y reiniciaremos la terminal.
