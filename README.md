# Mapa Interactivo de San Carlos, Alajuela

## 👥 Integrantes del Grupo

- **Dylan Cachón**
- **Victoria Sandí**

---

## 📍 Área de Estudio

**Cantón:** San Carlos  
**Provincia:** Alajuela, Costa Rica  
**Área:** ~3,348 km²  
**Coordenadas del bounding box:**
- Norte: 10.996163
- Sur: 10.246342
- Este: -84.161061
- Oeste: -84.862638

---

## 🌐 Mapa Publicado

**URL del mapa:** [PENDIENTE - Se actualizará después de la publicación]

---

## 🎯 Objetivo del Proyecto

Crear un mapa interactivo en mosaico (tile map) del cantón de San Carlos utilizando datos geográficos de diversas fuentes, procesados mediante herramientas GIS profesionales y publicado en la web mediante GitHub Pages.

El mapa incluye:
- Modelo de elevación digital (DEM) con colores hipsométricos
- Relieve sombreado (hillshade)
- División administrativa (cantón y distritos)
- Infraestructura vial e hidrográfica
- Servicios públicos y comerciales
- Áreas verdes y puntos de interés

---

## 📊 Fuentes de Datos

### 1. Capas Base del IGN (Instituto Geográfico Nacional)

Archivos shapefile de cobertura nacional de Costa Rica proporcionados en el repositorio del curso:

| Capa | Archivo | Geometría | Descripción |
|------|---------|-----------|-------------|
| Cantones | `geo_cantones.shp` | Polígono | División cantonal de Costa Rica |
| Distritos | `geo_distritos.shp` | Polígono | División distrital de Costa Rica |
| Carreteras | `geo_carreter.shp` | Línea | Red vial nacional |
| Ríos | `geo_rios.shp` | Línea | Red hidrográfica |
| Poblados | `geo_poblados.shp` | Punto | Centros poblados |
| Poblados principales | `geo_poblprinc.shp` | Punto | Cabeceras distritales |
| Hitos de elevación | `geo_hitos.shp` | Punto | 7,504 puntos con elevación (campo ELEVACION) |

### 2. Datos de OpenStreetMap

Datos descargados mediante **Overpass Turbo** (https://overpass-turbo.eu/) usando el bounding box de San Carlos.

**Proceso de descarga:**
1. Uso de consultas Overpass QL para filtrar elementos específicos
2. Exportación en formato GeoJSON
3. Conversión a shapefile mediante QGIS cuando fue necesario
4. Recorte espacial usando MapWindow

**Capas descargadas:**

| Capa | Origen | Formato Original | Procesamiento |
|------|--------|------------------|---------------|
| Parques | OSM - Overpass Turbo | GeoJSON | Convertido a SHP en QGIS |
| Plazas | OSM - Overpass Turbo | GeoJSON | Convertido a SHP en QGIS |
| Zonas verdes | OSM - Overpass Turbo | GeoJSON | Convertido a SHP en QGIS |
| Comercios | OSM - Overpass Turbo | GeoJSON | Convertido a SHP en QGIS |
| Hospitales | TecDigital / OSM | Shapefile | Recorte espacial |
| Clínicas | TecDigital / OSM | Shapefile | Recorte espacial |
| Escuelas | TecDigital / OSM | Shapefile | Recorte espacial |
| Bancos | TecDigital / OSM | Shapefile | Recorte espacial |
| Gasolineras | TecDigital / OSM | Shapefile | Recorte espacial |
| Hoteles | TecDigital / OSM | Shapefile | Recorte espacial |

---

## 🛠️ Metodología

### Fase 1: Preparación de Datos

#### 1.1 Recorte Espacial con MapWindow

**Software:** MapWindow 5

**Proceso:**
1. **Carga de capas base:** Se cargaron los shapefiles del IGN (ríos, carreteras, poblados, hitos, etc.) junto con el shapefile del cantón de San Carlos.

2. **Selección espacial (Spatial Query):**
   - Herramienta: `Spatial Query` en MapWindow
   - Criterio: Seleccionar elementos que intersectan con el polígono de San Carlos
   - Capas procesadas:
     - Ríos → `rios_san_carlos.shp`
     - Carreteras → `carreteras_san_carlos.shp`
     - Poblados → `poblados_san_carlos.shp`
     - Poblados principales → `poblprinc_san_carlos.shp`
     - Hitos de elevación → `hitos_san_carlos.shp`
     - Distritos → `distritos_san_carlos.shp`
     - Servicios (hospitales, escuelas, clínicas, bancos, gasolineras, hoteles)
     - Áreas verdes (parques, plazas, zonas verdes)

3. **Exportación de selecciones:**
   - Herramienta: `Export Selection` en MapWindow
   - Formato: ESRI Shapefile
   - CRS: EPSG:4326 (WGS84)
   - Resultado: Shapefiles recortados exclusivamente al área de San Carlos

#### 1.2 Conversión de GeoJSON a Shapefile (QGIS)

**Software:** QGIS 3.x

Para las capas descargadas de OpenStreetMap en formato GeoJSON:

1. Abrir QGIS
2. Cargar archivo GeoJSON (arrastrar y soltar)
3. Clic derecho → `Export` → `Save Features As...`
4. Formato: `ESRI Shapefile`
5. CRS: `EPSG:4326 - WGS 84`
6. Guardar con nombre descriptivo (ej: `parques_san_carlos.shp`)

**Capas convertidas:**
- `parques_san_carlos.shp`
- `plazas_san_carlos.shp`
- `zonas_verdes_san_carlos.shp`
- `comercios_san_carlos.shp`

---

### Fase 2: Generación del Modelo de Elevación Digital (DEM)

**Responsable:** Victoria Sandí  
**Software:** GDAL (Geospatial Data Abstraction Library)

#### 2.1 Interpolación TIN (Triangulated Irregular Network)

**Archivo de entrada:** `hitos_san_carlos.shp` (7,504 puntos de elevación)

**Comando GDAL:**
```bash
gdal_grid -zfield ELEVACION \
  -a linear:radius=-1.0 \
  -txe -84.862638 -84.161061 \
  -tye 10.246342 10.996163 \
  -outsize 2500 2500 \
  -of GTiff -ot Float32 \
  -co "COMPRESS=LZW" \
  -co "TILED=YES" \
  -co "BIGTIFF=IF_SAFER" \
  hitos_san_carlos.shp \
  dem_san_carlos.tif
```

**Parámetros:**
- `-zfield ELEVACION`: Campo con valores de elevación
- `-a linear:radius=-1.0`: Interpolación lineal (TIN) sin límite de radio
- `-txe` / `-tye`: Extensión geográfica del área (bounding box)
- `-outsize 2500 2500`: Resolución de ~30m por píxel
- `-of GTiff`: Formato GeoTIFF
- `-ot Float32`: Valores en punto flotante
- Compresión LZW para reducir tamaño de archivo

**Resultado:** `dem_san_carlos.tif` (modelo en escala de grises)

#### 2.2 Aplicación de Rampa de Color

**Paleta de colores hipsométrica personalizada:**

Archivo `color_ramp.txt` con 13 rangos de elevación:

```
# Elevación   R   G   B     Color HEX    Descripción
8.484         8   81  156   #08519c      Azul marino (mínimo - valles)
200           64  125 186   #407dba      Azul medio
400           107 174 214   #6baed6      Azul claro
600           158 202 225   #9ecae1      Azul muy claro
800           199 233 192   #c7e9c0      Verde-azulado (transición)
1000          161 217 155   #a1d99b      Verde claro
1200          116 196 118   #74c476      Verde medio
1400          65  171 93    #41ab5d      Verde oscuro
1600          254 217 118   #fed976      Amarillo-naranja (transición)
1800          253 174 97    #fdae61      Naranja claro
2000          227 26  28    #e31a1c      Rojo
2100          215 48  39    #d73027      Rojo oscuro
2264.139      128 0   38    #800026      Rojo vino (máximo - picos)
```

**Comando GDAL:**
```bash
gdaldem color-relief \
  dem_san_carlos.tif \
  color_ramp.txt \
  dem_san_carlos_colored.tif
```

**Resultado:** `dem_san_carlos_colored.tif` (DEM coloreado)

#### 2.3 Generación de Hillshade (Relieve Sombreado)

**Comando GDAL:**
```bash
gdaldem hillshade \
  -z 3.5 \
  -s 111120 \
  -az 315 \
  -alt 45 \
  -combined \
  -compute_edges \
  -co "COMPRESS=LZW" \
  dem_san_carlos.tif \
  hillshade_san_carlos.tif
```

**Parámetros:**
- `-z 3.5`: Factor de exageración vertical (mayor relieve visual)
- `-s 111120`: Factor de escala (metros por grado, latitud ~10°)
- `-az 315`: Azimut de iluminación (noroeste, 315°)
- `-alt 45`: Altitud del sol (45° sobre horizonte)
- `-combined`: Combina hillshade con pendiente para mejor efecto
- `-compute_edges`: Calcula bordes correctamente

**Resultado:** `hillshade_san_carlos.tif` (relieve sombreado en escala de grises)

---

### Fase 3: Diseño Cartográfico en TileMill

**Software:** TileMill 0.10.1  
**Lenguaje de estilos:** CartoCSS

#### 3.1 Configuración del Proyecto

1. Crear nuevo proyecto en TileMill: `san_carlos_map`
2. Configurar sistema de coordenadas: `WGS84` (EPSG:4326)
3. Establecer centro del mapa: `[10.47, -84.43]`
4. Establecer zoom inicial: `10`
5. Establecer rango de zoom: `8-16`

#### 3.2 Carga de Capas

**Orden de capas (de abajo hacia arriba):**

1. **DEM coloreado** (`dem_san_carlos_colored.tif`)
   - Opacidad: 0.7
   - Escalado: bilinear

2. **Hillshade** (`hillshade_san_carlos.tif`)
   - Opacidad: 0.45
   - Escalado: bilinear

3. **Cantón** (`canton_san_carlos.shp`)
   - Borde negro (line-width: 2.5 en zoom ≤9, 2.0 en zoom >9)
   - Etiqueta "San Carlos" en zoom ≤ 9

4. **Distritos** (`distritos_san_carlos.shp`)
   - Bordes punteados (dasharray: 4, 2)
   - Etiquetas desde zoom 10

5. **Ríos** (`rios_san_carlos.shp`)
   - Color: #2980b9 (azul)
   - Line-width: 0.8-1.2px
   - Aparece desde zoom 10

6. **Carreteras** (`carreteras_san_carlos.shp`)
   - Nacionales: #e67e22 (naranja), width 1.5-2.5px
   - Cantonales: #f39c12 (naranja claro), punteado
   - Caminos: #7f8c8d (gris), width 0.8px
   - Aparece desde zoom 10

7. **Áreas verdes:**
   - Parques (`parques_san_carlos.shp`) - desde zoom 11, #52C165
   - Zonas verdes (`zonas_verdes_san_carlos.shp`) - desde zoom 12, #A8E6A3
   - Plazas (`plazas_san_carlos.shp`) - desde zoom 12, #FFD93D

8. **Poblados:**
   - Principales (`poblprinc_san_carlos.shp`) - desde zoom 9, #8e44ad (morado)
   - Normales (`poblados_san_carlos.shp`) - desde zoom 12, #27ae60 (verde)

9. **Servicios de salud:**
   - Hospitales - desde zoom 11, #D10000 (rojo intenso), width 22-32px
   - Clínicas - desde zoom 13, #FF6B6B (rojo claro), width 16-20px

10. **Educación:**
    - Escuelas - desde zoom 13, width 12-14px
      - Públicas: #2980b9 (azul)
      - Privadas: #8e44ad (morado)
      - Subvencionadas: #27ae60 (verde)

11. **Servicios financieros:**
    - Bancos - desde zoom 13, width 12-13px
      - Colores específicos por entidad (BNCR/BCR: azul, BP: amarillo, etc.)

12. **Servicios turísticos:**
    - Hoteles - desde zoom 13, width 10-16px
      - Clasificados por categoría (1-5 estrellas) con gradiente amarillo-marrón
    - Gasolineras - desde zoom 13, #2c3e50 (gris oscuro), width 12-14px

13. **Comercios:**
    - Comercios - desde zoom 14, #8e44ad (morado), width 10-12px

#### 3.3 Estilos CartoCSS

**Archivo:** `tilemill_style.mss`

**Características principales:**
- Fondo: #e8f4f8 (azul muy claro)
- Opacidades optimizadas: DEM 0.7, Hillshade 0.45
- Líneas delgadas para infraestructura (ríos 0.8-1.2px, carreteras 1.5-2.5px)
- Hospitales con máxima prioridad visual (aparecen en zoom 11, tamaño 22-32px)
- Jerarquía clara de colores y tamaños
- Etiquetas con halos blancos para legibilidad
- SVG icons para todos los servicios

**Paleta de colores principal:**

| Elemento | Color | Hex | Uso |
|----------|-------|-----|-----|
| Hospitales | Rojo intenso | #D10000 | Máxima prioridad |
| Clínicas | Rojo claro | #FF6B6B | Salud secundaria |
| Escuelas públicas | Azul | #2980b9 | Educación pública |
| Escuelas privadas | Morado | #8e44ad | Educación privada |
| Escuelas subv. | Verde | #27ae60 | Educación subvencionada |
| Gasolineras | Gris oscuro | #2c3e50 | Combustible |
| Comercios | Morado | #8e44ad | Comercio general |
| Carreteras nacionales | Naranja | #e67e22 | Vías principales |
| Carreteras cantonales | Naranja claro | #f39c12 | Vías secundarias |
| Ríos | Azul | #2980b9 | Hidrografía |
| Parques | Verde | #52C165 | Áreas verdes |
| Zonas verdes | Verde claro | #A8E6A3 | Áreas verdes secundarias |
| Plazas | Amarillo dorado | #FFD93D | Espacios públicos |
| Poblados principales | Morado | #8e44ad | Cabeceras |
| Poblados normales | Verde | #27ae60 | Poblados menores |

**Jerarquía de zoom:**
```
ZOOM 8-9:   Cantón + DEM + Hillshade + Fondo azul claro
ZOOM 9:     + Poblados principales (morado)
ZOOM 10:    + Ríos + Carreteras + Distritos (etiquetas)
ZOOM 11:    + HOSPITALES (rojo intenso, 22px) + Parques
ZOOM 12:    + Zonas verdes + Plazas + Poblados normales
ZOOM 13:    + Clínicas + Escuelas + Bancos + Hoteles + Gasolineras
ZOOM 14:    + Comercios
ZOOM 15:    + Mayor detalle en todas las etiquetas
```

**Características especiales del estilo:**
- **Hospitales:** `marker-allow-overlap: true`, `marker-ignore-placement: true` para forzar visibilidad
- **Infraestructura delgada:** Ríos y carreteras con líneas finas para no opacar el DEM
- **SVG icons:** Todos los servicios usan iconos vectoriales escalables
- **Etiquetas optimizadas:** Halos blancos, tamaños progresivos según zoom

Ver archivo completo: `tilemill_style.mss`

---

### Fase 4: Exportación de Tiles

#### 4.1 Configuración de Exportación

**En TileMill:**
1. Clic en `Export` → `MBTiles`
2. Configurar parámetros:
   - **Nombre:** `san_carlos`
   - **Formato:** MBTiles
   - **Zoom mínimo:** 8
   - **Zoom máximo:** 16
   - **Centro:** `10.47, -84.43`
   - **Límites:** Bounding box de San Carlos

3. Exportar → `san_carlos.mbtiles`

#### 4.2 Conversión a Tiles PNG

**Script Python:** `mbtiles_to_tiles.py`

```bash
python mbtiles_to_tiles.py san_carlos.mbtiles tiles/
```

**Resultado:** Carpeta `tiles/` con estructura:
```
tiles/
├── 8/
├── 9/
├── 10/
...
└── 16/
```

**Formato de tiles:**
- Formato: PNG con transparencia
- Tamaño: 256 × 256 píxeles
- Nomenclatura: `{z}/{x}/{y}.png`
- Proyección: Web Mercator (EPSG:3857)

---

### Fase 5: Desarrollo Web

#### 5.1 Página HTML

**Archivo:** `index.html`

**Tecnología:** Leaflet.js 1.9.4

**Características:**
- Mapa interactivo centrado en San Carlos [10.47, -84.43]
- Tiles personalizados desde carpeta `tiles/`
- Controles de zoom y escala
- Panel de información lateral con leyenda completa
- Diseño responsive (adaptable a móvil/tablet/escritorio)
- Créditos y atribuciones

Ver archivo completo: `index.html`

---

### Fase 6: Publicación en GitHub Pages

#### 6.1 Estructura del Repositorio

```
mapa_san_carlos/
├── index.html
├── tiles/
│   ├── 8/
│   ├── 9/
│   ├── 10/
│   └── ... (hasta 16)
├── README.md
├── tilemill_style.mss
└── docs/
    └── [documentación adicional]
```

#### 6.2 Comandos Git

```bash
# Inicializar repositorio
git init

# Agregar archivos
git add .

# Commit inicial
git commit -m "Proyecto 3: Mapa de San Carlos"

# Conectar con GitHub
git remote add origin https://github.com/[usuario]/mapa_san_carlos.git

# Subir cambios
git push -u origin main
```

#### 6.3 Activar GitHub Pages

1. Ir a repositorio en GitHub
2. `Settings` → `Pages`
3. Source: `Deploy from a branch`
4. Branch: `main` / `root`
5. Save

**URL resultante:** `https://[usuario].github.io/mapa_san_carlos/`

---

## 📈 Estadísticas del Proyecto

### Datos Procesados

| Tipo de Dato | Cantidad |
|--------------|----------|
| Puntos de elevación | 7,504 |
| Ríos | 68 |
| Distritos | 13 |
| Capas de servicios | 10 |
| Capas totales en mapa | 18 |
| Rango de elevación | 8.5 m - 2,264 m |
| Niveles de zoom | 9 (8-16) |
| Resolución DEM | ~30 m |

### Archivos Generados

| Archivo | Tamaño Aprox. | Descripción |
|---------|---------------|-------------|
| `dem_san_carlos.tif` | ~25 MB | DEM en escala de grises |
| `dem_san_carlos_colored.tif` | ~75 MB | DEM coloreado |
| `hillshade_san_carlos.tif` | ~25 MB | Relieve sombreado |
| `san_carlos.mbtiles` | Variable | Tiles comprimidos |
| Carpeta `tiles/` | Variable | Tiles PNG expandidos |

---

## 🛠️ Herramientas Utilizadas

| Software | Versión | Uso |
|----------|---------|-----|
| MapWindow | 5.x | Análisis espacial y recorte de capas |
| QGIS | 3.x | Conversión GeoJSON → Shapefile |
| GDAL | 3.x | Generación de DEM y hillshade |
| Overpass Turbo | Web | Descarga de datos OpenStreetMap |
| TileMill | 0.10.1 | Diseño cartográfico y generación de tiles |
| Leaflet.js | 1.9.4 | Visualización web interactiva |
| Python | 3.x | Conversión MBTiles → PNG tiles |
| Git/GitHub | - | Control de versiones y hosting |
| GitHub Pages | - | Publicación web |

---

## 📚 Referencias

### Datos
- Instituto Geográfico Nacional (IGN) de Costa Rica
- OpenStreetMap Contributors (https://www.openstreetmap.org/copyright)
- Overpass API (https://overpass-turbo.eu/)

### Software
- MapWindow GIS (https://www.mapwindow.org/)
- QGIS (https://qgis.org/)
- GDAL (https://gdal.org/)
- TileMill (https://tilemill-project.github.io/tilemill/)
- Leaflet.js (https://leafletjs.com/)

### Documentación
- GDAL Documentation (https://gdal.org/programs/)
- Overpass QL Guide (https://wiki.openstreetmap.org/wiki/Overpass_API)
- CartoCSS Reference (https://cartocss.readthedocs.io/)
- Leaflet Documentation (https://leafletjs.com/reference.html)

---

## 🚀 Cómo Usar Este Proyecto

### Requisitos Previos
- Navegador web moderno (Chrome, Firefox, Safari, Edge)
- Conexión a internet (para cargar Leaflet.js)

### Visualización Local

1. Clonar el repositorio:
```bash
git clone https://github.com/[usuario]/mapa_san_carlos.git
cd mapa_san_carlos
```

2. Iniciar servidor local:
```bash
# Con Python 3
python -m http.server 8000

# Con Node.js
npx http-server
```

3. Abrir en navegador:
```
http://localhost:8000
```

### Visualización Online

Acceder directamente a:
```
https://[usuario].github.io/mapa_san_carlos/
```

---

## 🔧 Personalización

### Modificar Estilos

Editar `tilemill_style.mss` en TileMill:
- Cambiar colores de capas
- Ajustar tamaños de símbolos
- Modificar niveles de zoom de aparición
- Personalizar etiquetas

Luego re-exportar los tiles.

### Cambiar Centro del Mapa

En `index.html`, modificar:
```javascript
const map = L.map('map').setView([LAT, LON], ZOOM);
```

### Agregar Capas Adicionales

1. Obtener shapefile
2. Recortar con MapWindow (Spatial Query)
3. Agregar a TileMill
4. Definir estilos en CartoCSS
5. Re-exportar tiles

---

## 🎓 Lecciones Aprendidas

### Desafíos Encontrados

1. **Recorte espacial de múltiples capas:**
   - Solución: Uso de MapWindow con Spatial Query para procesar todas las capas de forma consistente

2. **Conversión de formatos:**
   - Problema: Datos OSM en GeoJSON
   - Solución: Pipeline de conversión con QGIS

3. **Generación de DEM:**
   - Desafío: Interpolación adecuada desde puntos dispersos
   - Solución: GDAL con método TIN (linear) y resolución optimizada

4. **Balance visual en el mapa:**
   - Problema: DEM muy opaco, líneas muy gruesas
   - Solución: Opacidades reducidas (DEM 0.7, hillshade 0.45) y líneas delgadas (0.8-2.5px)

5. **Visibilidad de hospitales:**
   - Problema: Hospitales no se veían claramente
   - Solución: Zoom de aparición más temprano (11), tamaño mayor (22-32px), `marker-allow-overlap: true`

### Conocimientos Adquiridos

- Flujo de trabajo completo de cartografía digital
- Uso avanzado de GDAL para procesamiento raster
- Diseño cartográfico con TileMill y CartoCSS
- Balance entre visibilidad de capas base y temáticas
- Integración de múltiples fuentes de datos geoespaciales
- Publicación de mapas web interactivos
- Control de versiones con Git para proyectos GIS

---

## 📝 División de Trabajo

### Dylan Cachón
- Descarga de datos de OpenStreetMap (Overpass Turbo)
- Conversión de GeoJSON a Shapefile (QGIS)
- Documentación del proyecto
- Desarrollo web (HTML/CSS/JavaScript)

### Victoria Sandí
- Recorte espacial de capas (MapWindow)
- Generación del DEM (GDAL)
- Aplicación de colores hipsométricos (GDAL)
- Generación de hillshade (GDAL)
- Configuración y estilizado en TileMill

### Trabajo Conjunto
- Diseño de la paleta de colores
- Definición de jerarquía de zoom
- Ajustes de opacidades y tamaños
- Pruebas y ajustes del mapa
- Publicación en GitHub Pages
- Documentación final

---

## 📦 Archivos Entregables

### Obligatorios
- ✅ `README.md` - Este documento
- ✅ `tilemill_style.mss` - Estilos CartoCSS
- ✅ `index.html` - Página web del mapa

### Opcionales (Disponibles en el repositorio)
- Shapefiles recortados de San Carlos
- Scripts de procesamiento
- Archivos de configuración de TileMill
- Documentación adicional

---

## 📧 Contacto

**Institución:** Tecnológico de Costa Rica  
**Curso:** Sistemas de Información Geográfica  
**Año:** 2025  
**Semestre:** II

**Integrantes:**
- Dylan Cachón
- Victoria Sandí

---

## 📄 Licencia

Este proyecto fue desarrollado con fines académicos para el Tecnológico de Costa Rica.

**Datos:**
- OpenStreetMap: © OpenStreetMap contributors, ODbL 1.0
- IGN Costa Rica: Datos públicos del Instituto Geográfico Nacional

**Código:**
- Desarrollado por Dylan Cachón y Victoria Sandí
- Libre para uso educativo

---

**Fecha de entrega:** [FECHA]  
**Proyecto 3 - Sistemas de Información Geográfica**  
**Tecnológico de Costa Rica - 2025**
