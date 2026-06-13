# Counter Hit

App iOS SwiftUI para contar hits diarios y ver graficas semanal, mensual y anual con widgets.

## Que incluye

- App principal `CounterHit` con boton para agregar hit.
- Modal de confirmacion: `Si, agregar hit` suma el hit del dia; `No, cancelar` no hace nada.
- Dashboard con totales por dia, semana, mes y ano.
- Graficas con Swift Charts:
  - Semanal: abajo dias, arriba hits.
  - Mensual: abajo semanas, arriba hits.
  - Anual: abajo meses, arriba hits.
- Tres widgets WidgetKit: semanal, mensual y anual.
- Al tocar un widget se abre `counterhit://add-hit` y aparece el modal de confirmacion.
- Datos compartidos entre app y widget con App Group.

## Abrir en Xcode

1. Abre `CounterHit.xcodeproj`.
2. En el target `CounterHit`, entra a `Signing & Capabilities` y selecciona tu Team.
3. Repite lo mismo en el target `CounterHitWidget`.
4. En `CounterHit` y `CounterHitWidget`, confirma el App Group:
   `group.com.rmkwz.CounterHit`
5. Si Xcode te pide cambiar bundle id o app group para tu cuenta, usa el mismo valor en:
   - `CounterHit/CounterHit.entitlements`
   - `CounterHitWidget/CounterHitWidget.entitlements`
   - `CounterHit/Shared/HitStore.swift`
6. Corre el esquema `CounterHit` en tu iPhone 13 Pro Max.

Si Xcode muestra `requires a development team`, falta seleccionar tu Apple ID/Team en ambos targets. El proyecto usa firma automatica, pero Apple no permite firmar una app para iPhone sin un Team real.

## Regenerar el proyecto

El proyecto usa XcodeGen. Si cambias `project.yml`, corre:

```sh
xcodegen generate
```

## Verificacion usada

Se genero `CounterHit.xcodeproj` con XcodeGen. En este entorno, `xcodebuild` compila Swift y targets hasta la fase de asset catalog, pero falla porque no hay runtimes de simulador disponibles para `actool`:

```text
No available simulator runtimes for platform iphonesimulator
```

En Xcode local con runtimes instalados, ese error no deberia aparecer.
# counter-hit
