@echo off
setlocal enabledelayedexpansion

:MENU
cls
echo 1. Registrarse
echo 2. Iniciar Sesion
echo 3. Salir
set /p seleccion=Seleccione una opcion:
REM Hago que se seleccione las opciones con varios if dentro de if,un call.En caso de que pongas otra opcion te pondra que es invalida
if "%seleccion%"=="1" (
    goto :Registro
) else if "%seleccion%"=="2" (
    goto :InicioSesion
) else if "%seleccion%"=="3" (
    goto Salir
) else (
    echo Opción no valida. Inténtelo de nuevo.  
    pause
    goto MENU
)
:Registro
cls
set /p Nombre=Ingrese su nombre de usuario:
set /p contrasena=Ingrese su contraseña:
set /p contrasena2=Repita su contraseña:
if "%contrasena%" neq "%contrasena2%" (
    echo Las contraseñas no coinciden. Intentelo de nuevo.
    pause
    goto Registro
)
REM creas la base de datos
echo !Nombre!;!contrasena!>> usuarios.txt
echo Registro exitoso.
pause
goto MENU
:InicioSesion
cls
set /p Nombre=Ingrese su nombre de usuario:
set /p contrasena=Ingrese su contraseña:
set "inisesion="
REM aqui pones con token que empiece de izquierda a derecha a leer en la base de datos para que cpincidan los usuarios con sus respectivas contraseñas
for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        if "%%b"=="%contrasena%" (
            set "inisesion=true"
            echo Bienvinido
            pause
            goto :MENU_INICIO
        ) else (
            echo Contraseña incorrecta.
            set "inisesion=false"
            pause
            goto MENU
        )
    )
)
if not defined inisesion (
    echo Nombre de usuario no encontrado.
    pause
    goto MENU
)
:MENU_INICIO
REM Este es el menu de incio de sesion
cls
echo 1. Modificar contraseña
echo 2. Eliminar usuario
echo 3. Cerrar sesion
set /p seleccion=Seleccione una opcion:
if "%seleccion%"=="1" (
    goto :ModificarContraseña
) else if "%seleccion%"=="2" (
    goto :EliminarUsuario
) else if "%seleccion%"=="3" (
    goto MENU
) else (
    echo Opcion no valida. Intentelo de nuevo.
    pause
    goto MENU_INICIO
)
:ModificarContraseña
REM aqui tienes el menú de cambiar contraseña
cls
set /p contrasena3=Nueva contraseña:
(for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        echo %%a;!contrasena3!
    ) else (
        echo %%a;%%b
    ) 
)) > usuarios_nuevo.txt 
del usuarios.txt
rename usuarios_nuevo.txt usuarios.txt
echo Contraseña modificada exitosamente.
pause
goto MENU_INICIO
REM Aqui pones los comandos para borrar el ususario deseado desde  la base de datos
:EliminarUsuario
cls
set cuenta=!nombre!;!contrasena!
rename usuarios.txt usuarios_nuevos.txt
copy nul usuarios.txt >nul
set contador=1
for /f "tokens=%contador%" %%a in (usuarios_nuevos.txt) do (
    if %%a equ !cuenta! (
        echo Usuario eliminado exitosamente.
    ) else (
        echo %%a >>usuarios.txt 
        set /a contador=!contador!+1
    )
)
del usuarios_nuevos.txt
pause
goto MENU
:salir 
