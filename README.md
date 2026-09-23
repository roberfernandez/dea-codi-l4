# DEA Codi L-4

Interfaz Flutter original, estaciones, navegación, icono y regreso a TMB Agent conservados.

## Acceso protegido

La web reutiliza la sesión y la comprobación de autorización de TMB Agent. Sin sesión aprobada redirige al control de acceso común. El backend comprueba en cada consulta que el usuario existe en Supabase Auth y tiene una solicitud aprobada.

Los códigos residen exclusivamente en `dea_private.codes`, con RLS forzada y sin permisos directos para `anon` ni `authenticated`. La función `public.dea_code_for_station` es la única vía de lectura autorizada. Las migraciones contienen únicamente estructura y permisos, nunca datos reales.

La respuesta se conserva solo en memoria mientras se muestra. No se guarda en localStorage, assets ni cachés; la petición usa POST y `no-store`. Al perder sesión, visibilidad o conexión se borra el código. Ante errores no existe alternativa local. Solo se utiliza una clave publishable en el cliente.

La fuente de demostración se conserva para pruebas y no se utiliza al arrancar la aplicación web.

## Build y publicación

Flutter 3.41.9:

```sh
flutter pub get
flutter build web --release --base-href /dea-codi-l4/ --pwa-strategy offline-first --no-web-resources-cdn
```

GitHub Pages publica `build/web` mediante Actions desde `main`. El service worker solo almacena archivos estáticos, sin códigos. El modo PWA generado por esta versión de Flutter está deprecado.

El repositorio público tiene un historial independiente del proyecto local original. Los datos privados se importan fuera del repositorio y del proceso de build.
