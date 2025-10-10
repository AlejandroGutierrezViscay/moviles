# Taller HTTP - Chuck Norris Jokes App

## 📱 Descripción del Proyecto

Esta aplicación Flutter consume la API pública de Chuck Norris (https://api.chucknorris.io/) para mostrar chistes divertidos. Es un ejercicio completo de consumo de APIs HTTP con navegación, manejo de errores y una interfaz moderna.

## 🚀 Características Principales

### ✅ Consumo de API HTTP
- **API Base**: `https://api.chucknorris.io/jokes`
- **Endpoints utilizados**:
  - `GET /random` - Obtener chiste aleatorio
  - `GET /random?category={category}` - Chiste por categoría
  - `GET /categories` - Listar todas las categorías
  - `GET /search?query={query}` - Buscar chistes

### ✅ Navegación con go_router
- **Rutas nombradas**: Navegación declarativa y segura
- **Parámetros de ruta**: ID del chiste en la URL
- **Query parameters**: Texto y categoría del chiste
- **Navegación programática**: Push/Pop con contexto

### ✅ Manejo de Errores Robusto
- **SnackBars informativos**: Feedback visual al usuario
- **Estados de error**: Pantallas dedicadas con opciones de reintento
- **Manejo de excepciones**: Try-catch en todas las llamadas HTTP
- **Timeouts y reconexión**: Gestión de problemas de red

### ✅ UI/UX Moderno
- **Material Design 3**: Colores y componentes actualizados
- **SliverAppBar**: Barra de aplicación expansible con efectos
- **Estados de carga**: Indicadores visuales elegantes
- **Responsive design**: Adaptable a diferentes tamaños de pantalla

## 📂 Estructura del Proyecto

```
lib/taller_http/
├── main.dart                    # Punto de entrada de la aplicación
├── routes/
│   └── app_routes.dart         # Configuración de rutas con go_router
├── models/
│   └── chuck_norris_joke.dart  # Modelo de datos para los chistes
├── services/
│   └── chuck_norris_service.dart # Cliente HTTP para la API
├── views/
│   └── jokes/
│       ├── jokes_list_view.dart    # Vista principal con lista de chistes
│       └── joke_detail_view.dart   # Vista de detalle del chiste
├── widgets/
│   └── joke_card.dart          # Widget reutilizable para mostrar chistes
└── README.md                   # Este archivo
```

## 🛠️ Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^16.2.4    # Navegación declarativa
  http: ^1.1.0          # Cliente HTTP
  cupertino_icons: ^1.0.8
```

## 📋 Funcionalidades Implementadas

### 1. **Lista de Chistes** (`JokesListView`)
- Muestra chistes obtenidos de múltiples fuentes
- Filtros por categorías dinámicas
- Pull-to-refresh para actualizar contenido
- Navegación táctil a vista de detalle

### 2. **Detalle del Chiste** (`JokeDetailView`)
- Vista expandida del chiste seleccionado
- Información adicional (ID, categoría, longitud)
- Funciones de copia al portapapeles
- Botón de regreso a la lista

### 3. **Servicio HTTP** (`ChuckNorrisService`)
- Métodos estáticos para todas las operaciones de API
- Manejo centralizado de errores HTTP
- Parsing automático de JSON a modelos Dart
- Funciones mixtas para variedad de contenido

### 4. **Modelo de Datos** (`ChuckNorrisJoke`)
- Mapeo completo de la respuesta JSON de la API
- Métodos `fromJson` y `toJson` para serialización
- Propiedades tipadas y validadas

## 🎯 Flujo de Navegación

```
┌─────────────────┐    ┌─────────────────┐
│   Lista de      │───▶│   Detalle del   │
│   Chistes       │    │   Chiste        │
│                 │◀───│                 │
└─────────────────┘    └─────────────────┘
```

### Rutas Configuradas:
- **`/`** (jokes_list) → `JokesListView`
- **`/joke/:id`** (joke_detail) → `JokeDetailView`

## 🔧 Manejo de Estados

### Estados de la Aplicación:
1. **Loading**: Spinner con mensaje informativo
2. **Success**: Datos cargados y mostrados
3. **Error**: Mensaje de error con opción de reintento
4. **Empty**: Estado cuando no hay datos disponibles

### Gestión de Errores:
- **Errores de red**: Timeout, sin conexión
- **Errores de API**: Códigos de estado HTTP
- **Errores de parsing**: JSON malformado
- **Errores de UI**: Estados inválidos

## 📱 Cómo Ejecutar

### Prerrequisitos:
- Flutter SDK 3.9.2+
- Dispositivo físico o emulador configurado
- Conexión a internet

### Comandos:
```bash
# Obtener dependencias
flutter pub get

# Ejecutar en dispositivo/emulador
flutter run lib/taller_http/main.dart

# Ejecutar en web (Chrome/Edge)
flutter run lib/taller_http/main.dart -d chrome
```

### Para VS Code:
1. Abrir el proyecto en VS Code
2. Seleccionar dispositivo (Ctrl + Shift + P → "Flutter: Select Device")
3. Abrir `lib/taller_http/main.dart`
4. Presionar F5 para debuguear

## 🧪 Testing de la API

La aplicación consume estos endpoints de la API de Chuck Norris:

### Ejemplo de Respuesta:
```json
{
  "categories": [],
  "created_at": "2020-01-05 13:42:19.324003",
  "icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
  "id": "example123",
  "updated_at": "2020-01-05 13:42:19.324003",
  "url": "https://api.chucknorris.io/jokes/example123",
  "value": "Chuck Norris doesn't debug, he just stares at the code until it confesses."
}
```

## 🎨 Diseño y Temática

- **Colores principales**: Naranja y tonos complementarios
- **Iconografía**: Material Design Icons
- **Tipografía**: Roboto (por defecto en Material 3)
- **Layout**: Responsive con Cards y espaciado consistente

## 🚧 Mejoras Futuras

- [ ] Implementar función de compartir real
- [ ] Agregar favoritos locales con SQLite
- [ ] Búsqueda en tiempo real
- [ ] Modo oscuro/claro
- [ ] Animaciones de transición
- [ ] Caché offline de chistes

## 👨‍💻 Arquitectura

Este proyecto sigue principios de **Clean Architecture**:
- **Separación de responsabilidades**: Models, Services, Views, Widgets
- **Inyección de dependencias**: Servicios estáticos reutilizables
- **Manejo de estado local**: setState para simplicidad
- **Navegación declarativa**: go_router para rutas tipadas

---

**Desarrollado como ejercicio educativo de Flutter y consumo de APIs HTTP** 🚀