# DEA Codi L-4 · Web de demostración

Interfaz Flutter original, estaciones, navegación e icono conservados.
La versión pública muestra `C + ---- + X`, identificado como demostración.
No proporciona códigos reales ni permite abrir receptáculos con ese ejemplo.

## Datos protegidos (pendiente de implementar)

`DeaCodeSource` separa la interfaz de la obtención de códigos. La app pública
usa exclusivamente `DemoDeaCodeSource`. `BackendDeaCodeSource` ofrece un punto
de conexión para el futuro transporte autenticado, sin endpoint ni credenciales.
No hay todavía backend, login o autorización implementados.

Al conectar el login común de TMB Agent, el servidor deberá validar la sesión
y la aprobación del usuario en cada consulta. Un login en la pantalla no protege
datos incorporados al JavaScript: los códigos solo pueden residir en el backend.
Las respuestas deberán llevar `Cache-Control: no-store`; no se deben almacenar
en assets, JSON estáticos, logs, localStorage ni cachés del service worker.
Ante denegación o error la interfaz elimina el resultado anterior y muestra
que el código no está disponible. No existe fallback a códigos locales.

## Build y publicación

Flutter 3.41.9, misma versión del proyecto original:

```sh
flutter pub get
flutter build web --release --base-href /dea-codi-l4/ --pwa-strategy offline-first --no-web-resources-cdn
```

GitHub Pages publica `build/web` mediante Actions desde `main`.
La caché PWA generada por Flutter contiene solo la demostración estática.
El modo PWA de esta versión de Flutter está deprecado; antes de actualizar el
SDK o conectar el backend habrá que revisar explícitamente su caché.

El repositorio público parte de un historial limpio. No contiene el commit
local histórico que incluía los datos originales.
