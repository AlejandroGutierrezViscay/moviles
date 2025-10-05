# Taller Segundo Plano - Demo

Este directorio contiene ejemplos didácticos para manejar asincronía y concurrencia en Flutter, demostrando el uso de `Future`/`async-await`, `Timer` (cronómetro) e `Isolate` (tarea pesada).

## Funcionalidades Implementadas

### 1. Asincronía con Future / async / await (`/async`)
- Servicio simulado `AsyncService` con tres endpoints:
  - `fetchProductos()`: Simula consulta con delay 2-3s y 30% de error aleatorio
  - `getVersion()`: Consulta simulada siempre exitosa (2s)
  - `simulateError()`: Operación que siempre falla (2s)
- Estados en pantalla: Cargando / Éxito / Error
- Mensajes en consola: "ANTES" / "DURANTE" / "DESPUÉS"
- UI con tarjetas separadas para cada operación
- Manejo de errores con retry

### 2. Timer (Cronómetro) (`/timer`)
- Cronómetro profesional con precisión de 100ms
- Display estilo LED con formato MM:SS.D
- Controles:
  - Iniciar/Pausar (botón contextual)
  - Reiniciar
- Características:
  - Fondo con gradiente usando colores del tema
  - Display grande estilo marcador digital
  - Indicador de estado (en marcha/detenido)
  - Limpieza automática de recursos

### 3. Demo Completa (`/demo`)
- Integración de Future, Timer e Isolate en una sola vista
- Isolate para tarea CPU-bound:
  - Suma grande (1 a N) en hilo separado
  - Comunicación via SendPort/ReceivePort
  - Timeout de seguridad
  - UI no bloqueante

## Rutas y Navegación

El proyecto usa `go_router` para la navegación. Rutas disponibles:
- `/`: Pantalla principal
- `/async`: Demo de operaciones asíncronas
- `/timer`: Cronómetro profesional
- `/demo`: Vista que integra todas las demos
- `/ciclo_vida`: Demo del ciclo de vida
- `/future`: Ejemplo de Future
- `/isolate`: Ejemplo de Isolate
- `/paso_parametros`: Demo de navegación con parámetros

## Estructura del Proyecto

```
lib/taller_segundo_plano/
├── main.dart           # Punto de entrada
├── routes/
│   └── app_router.dart # Configuración de rutas
├── services/
│   ├── async_service.dart  # Servicio para demo async
│   └── data_service.dart   # Servicio general
├── themes/
│   └── app_theme.dart  # Tema personalizado
├── views/
│   ├── async/         # Demo de async/await
│   ├── timer/         # Cronómetro
│   └── demo/          # Demo integrada
└── widgets/
    ├── base_view.dart    # Layout base
    └── custom_drawer.dart # Menú de navegación
```

## Cómo ejecutar
```powershell
cd 'c:\Users\Alejandro Gutierrez\Documents\GitHub\moviles'
flutter clean           # Limpia build anterior
flutter pub get        # Actualiza dependencias
flutter run           # Ejecuta la app
```

## Guía de Uso

1. **Demo Async** (`/async`):
   - Prueba las tres operaciones diferentes
   - Observa los mensajes en consola
   - Experimenta con errores y retries

2. **Cronómetro** (`/timer`):
   - Usa los botones de control
   - Observa la precisión de 100ms
   - Verifica que se limpia al salir

3. **Demo Completa** (`/demo`):
   - Prueba la integración de todas las funcionalidades
   - Experimenta con el Isolate



Archivos principales:
- `lib/taller_segundo_plano/views/async/async_demo_screen.dart`
- `lib/taller_segundo_plano/views/timer/timer_screen.dart`
- `lib/taller_segundo_plano/services/async_service.dart`
