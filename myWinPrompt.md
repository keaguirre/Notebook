# Configuración de Windows Terminal y PowerShell

[Video Base](https://youtu.be/6SGIFVJ5Izs?si=lgTUnGTAOmVHm3gr)
## Tomar de referencia para el archivo JSON de configuracion [este](settings.json) archivo
## Configuración Inicial

1.  **Instalar PowerShell:** Abre la Microsoft Store y busca "PowerShell". Instala la versión más reciente. Esto asegura que tengas la versión más actualizada de PowerShell.

2.  **Establecer PowerShell como perfil predeterminado en Windows Terminal:**
    *   Abre Windows Terminal.
    *   Ve a "Configuración" (Settings) (puedes usar el atajo `Ctrl + ,`).
    *   En la sección "Perfil predeterminado" (Default profile), selecciona "PowerShell" en lugar de "Windows PowerShell".

3.  **Establecer Windows Terminal como la aplicación de terminal predeterminada:**
    *   En la misma ventana de "Configuración", busca la opción "Aplicación de terminal predeterminada" (Default terminal app).
    *   Cambia la opción de "Dejar que Windows decida" (Let Windows decide) a "Windows Terminal".

## Agregar Esquemas de Color

4.  **Añadir esquemas de color al archivo JSON de configuración:**
    *   En la parte inferior izquierda de la ventana de configuración de Windows Terminal, haz clic en "Abrir archivo JSON" (Open JSON file).
    *   Dentro del objeto `"schemes"`, agrega el siguiente objeto (ejemplo con el tema Dracula):

```json
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
```

5.  **Obtener más esquemas de color:** Puedes encontrar más esquemas de color en [Windows Terminal Themes](https://windowsterminalthemes.dev/).

6.  **Activar el nuevo esquema de color:** Una vez reiniciada la terminal, el nuevo esquema de color estará disponible para su selección en la configuración, identificado por el valor del campo `"name"` que definiste en el objeto JSON.

7.  **Activar el efecto acrílico:** En la sección "Apariencia" (Appearance) de la configuración, activa la opción "Usar material acrílico en la fila de pestañas" (Use acrylic material in the tab row) y guarda los cambios.

## Configurar Oh My Posh

8.  **Instalar Oh My Posh:**

      * Asegúrate de tener `winget` instalado. Abre PowerShell y ejecuta `winget --version`. Si no lo tienes, puedes instalarlo desde la Microsoft Store o desde [su página oficial](https://www.google.com/url?sa=E&source=gmail&q=https://www.google.com/url?sa=E%26source=gmail%26q=https://learn.microsoft.com/es-es/windows/package-manager/winget/).
      * Ejecuta el siguiente comando en PowerShell: `winget install JanDeDobbeleer.OhMyPosh -s winget`

9.  **Instalar fuentes:**

      * Abre PowerShell como administrador.
      * Ejecuta el comando `oh-my-posh font install`.
      * Luego, instala una fuente específica con `oh-my-posh font install [nombre-de-la-fuente]`. Se recomienda "Meslo", pero "JetBrains Mono" o "Fira Code" también son excelentes opciones.

10. **Seleccionar la fuente en Windows Terminal:**

      * En la configuración de Windows Terminal, ve a "Predeterminado" -\> "Apariencia" -\> "Fuente" (Default -\> Appearance -\> Font face).
      * Selecciona la fuente que instalaste en el paso anterior.

11. **Verificar la instalación de Oh My Posh:** Ejecuta el comando `oh-my-posh` para verificar que esté instalado y en el PATH correctamente.

12. **Probar temas de Oh My Posh:** Usa el comando `Get-PoshThemes` para ver una lista de temas disponibles.

13. **Configurar el perfil de PowerShell:**

      * Ejecuta `notepad $PROFILE`. Esto intentará abrir el archivo de configuración de tu terminal.
      * Si aparece un error "El sistema no puede encontrar la ruta especificada", cierra el bloc de notas y ejecuta `New-Item -Path $PROFILE -Type File -Force`. Esto creará el archivo.
      * Vuelve a ejecutar `notepad $PROFILE`.
      * Pega el siguiente comando en el archivo y guárdalo: `oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\xtoys.omp.json" | Invoke-Expression`

14. **Cambiar el tema de Oh My Posh:** Para seleccionar otro tema, simplemente reemplaza `"xtoys"` con el nombre del tema que prefieras en el comando anterior.

15. **Activar sugerencias del historial:**

      * Vuelve a ejecutar `notepad $PROFILE`.
      * Debajo del comando anterior, pega lo siguiente: `set-PsReadLineOption -PredictionViewStyle InlineView` y guarda el archivo. Esto activará las sugerencias en línea basadas en tu historial de la consola.

## Instalar Zoxide (Navegación Inteligente)

16. **Instalar Zoxide:** Ejecuta `winget install ajeetdsouza.zoxide`.
17. **Integrar Zoxide con PowerShell:** Añade `Invoke-Expression (& { (zoxide init powershell | Out-String) })` al final de tu archivo `$PROFILE` (usando `notepad $PROFILE`) y reinicia la terminal. Esto integrará Zoxide para una navegación de directorios más inteligente.
