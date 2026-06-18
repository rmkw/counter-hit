# Counter Hit

App iOS en SwiftUI para contar hits diarios y visualizar graficos de actividad por semana, mes o ano. Incluye widgets de WidgetKit para acceder rapido desde la pantalla de inicio.

## Funcionalidades

- **Contador diario** — suma o resta hits del dia actual con confirmacion.
- **Graficos de actividad** — chart de barras con Swift Charts para los periodos semanal, mensual y anual.
- **Widgets** — grafica compacta con botones para agregar/restar hits directamente desde la pantalla de inicio.
- **Persistencia** — datos guardados en UserDefaults dentro de un App Group, compartidos entre la app y los widgets.
- **Preferencias sincronizadas** — el periodo seleccionado se comparte entre app y widget.

## Estructura del proyecto

```
CounterHit/
  App/                  # App principal
    ContentView         # Vista principal con card compacto
    HitCompactChart     # Componente de grafica
    HitModel            # ViewModel
    CounterHitApp       # Entry point
  Shared/               # Codigo compartido con el widget
    HitStore            # Persistencia en UserDefaults
    HitAnalytics        # Logica de calculos y buckets
    HitRecord           # Modelo de un hit
    HitBucket           # Modelo de un bucket para el chart
    HitPeriod           # Enum: week, month, year
    HitPreferences      # Periodo seleccionado por el usuario

CounterHitWidget/       # Extension de WidgetKit
  CounterHitWidget      # Definicion y provider del timeline
  CounterHitWidgetView  # Vista del widget
  HitPeriodIntent       # App Intents para botones configurables
```

## Requisitos

- iOS 17.0+
- Xcode 15.0+
- Swift Charts (incluido en iOS 17)

## Abrir en Xcode

1. Abre `CounterHit.xcodeproj`.
2. En el target `CounterHit`, entra a **Signing & Capabilities** y selecciona tu Team.
3. Repite lo mismo en el target `CounterHitWidget`.
4. Confirma que ambos targets tengan el App Group: `group.com.rmkwz.CounterHit`
5. Si Xcode pide cambiar el bundle ID, actualiza:
   - `CounterHit/CounterHit.entitlements`
   - `CounterHitWidget/CounterHitWidget.entitlements`
   - `CounterHit/Shared/HitStore.swift`
6. Corre el esquema `CounterHit`.

## Regenerar el proyecto

El proyecto usa XcodeGen. Si modificas `project.yml`, regenera con:

```sh
xcodegen generate
```

## Tecnologias

- SwiftUI
- WidgetKit
- Swift Charts
- XcodeGen
- App Intents