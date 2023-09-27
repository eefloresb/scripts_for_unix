# Qué es PowerShell?

PowerShell (PS) es una avanzada interfaz de línea de comandos (CLI) que permite la ejecución de scripts para la administración y automatización de tareas multiplataforma, contando con un lenguaje de scripting propio. A diferencia de otras CLI que solo devuelven texto, PS interactúa y devuelve objetos de .NET, gracias a su base en .NET CLR, proporcionando salidas más ricas y detalladas. Además, es extensible, permitiendo a los usuarios diseñar y añadir cmdlets personalizados, y admite el uso de alias para facilitar su adaptación a comandos familiares.

## Comandos Basicos

```powershell
# Obtiene el estado de todos los servicios del sistema.
Get-Service

# Muestra la ayuda básica del cmdlet Get-Service.
Get-Help Get-Service

# Actualiza los archivos de ayuda de todos los cmdlets.
Update-Help

# Muestra la ayuda completa, incluyendo detalles y parámetros, del cmdlet Get-Service.
Get-Help Get-Service -Full

# Muestra solo los ejemplos de uso del cmdlet Get-Service.
Get-Help Get-Service -Examples

# Abre una ventana independiente mostrando la ayuda del cmdlet Get-Service.
Get-Help Get-Service -ShowWindow

# Abre una ventana GUI que permite ver y especificar los parámetros para el cmdlet Get-Service.
Show-Command Get-Service

# Obtiene el estado de todos los servicios del sistema en la computadora con nombre "LON-DC.adatum.com".
Get-Service -ComputerName LON-DC.adatum.com

```

ComandLets:

```powershell
# Obtiene el estado de todos los servicios del sistema.
Get-Service

# Devuelve la fecha y hora actuales.
Get-Date

# Obtiene una lista de todos los comandos disponibles y la muestra con paginación.
Get-Command | more

# Obtiene una lista de todos los cmdlets disponibles.
Get-Command -CommandType Cmdlet

# Cuenta la cantidad de cmdlets disponibles en el sistema.
Get-Command -CommandType Cmdlet | Measure-Object

# Cuenta la cantidad de funciones disponibles en el sistema.
Get-Command -CommandType Function | Measure-Object

# Cuenta la cantidad de alias disponibles en el sistema.
Get-Command -CommandType Alias | Measure-Object

# Obtiene una lista de todos los comandos que empiezan con el verbo "Get".
Get-Command -Verb Get

# Muestra información sobre las actualizaciones y parches aplicados al sistema.
Get-Hotfix

# Obtiene una lista de comandos relacionados con procesos (utilizando un patrón).
Get-Command -Noun Process*

# Muestra los comandos disponibles en el módulo AppLocker.
Get-Command -Module AppLocker

# Obtiene una lista de comandos que tratan específicamente con procesos.
Get-Command -Noun Process

# Inicia el programa Notepad.
Start-Process notepad.exe

# Obtiene información sobre todos los procesos de Notepad en ejecución.
Get-Process -Name *notepad*
```
