// ========================================
// CONFIGURACIÓN Y DATOS
// ========================================

const MAP_CONFIG = {
    center: [10.47, -84.43],
    zoom: 10,
    minZoom: 8,
    maxZoom: 16
};

const ZOOM_INFO = {
    8: 'Vista: Cantón + DEM + Poblados principales',
    9: 'Vista: Cantón + DEM + Poblados principales',
    10: 'Vista: + Ríos + Carreteras + Distritos',
    11: 'Vista: + HOSPITALES + Parques',
    12: 'Vista: + Zonas verdes + Plazas + Poblados',
    13: 'Vista: + Clínicas + Escuelas + Bancos + Hoteles + Gasolineras',
    14: 'Vista: + Comercios + Máximo detalle',
    15: 'Vista: + Comercios + Máximo detalle',
    16: 'Vista: + Comercios + Máximo detalle'
};

const LEGEND_DATA = {
    salud: {
        title: 'Salud',
        items: [
            { type: 'icon', color: '#D10000', icon: '🏥', label: 'Hospitales' },
            { type: 'icon', color: '#FF6B6B', icon: '⛑️', label: 'Clínicas' }
        ]
    },
    educacion: {
        title: 'Educación',
        items: [
            { type: 'icon', color: '#2980b9', icon: '🎓', label: 'Escuelas Públicas' },
            { type: 'icon', color: '#8e44ad', icon: '🎓', label: 'Escuelas Privadas' },
            { type: 'icon', color: '#27ae60', icon: '🎓', label: 'Escuelas Subvencionadas' }
        ]
    },
    servicios: {
        title: 'Servicios Financieros',
        items: [
            { type: 'icon', color: '#ffffff', icon: '🏦', label: 'Bancos (varios)' }
        ]
    },
    turismo: {
        title: 'Turismo y Combustible',
        items: [
            { type: 'icon', color: '#000000', icon: '🏨', label: 'Hoteles (1-5 estrellas)' },
            { type: 'icon', color: '#2c3e50', icon: '⛽', label: 'Gasolineras' }
        ]
    },
    comercio: {
        title: 'Comercio',
        items: [
            { type: 'icon', color: '#8e44ad', icon: '🏪', label: 'Comercios' }
        ]
    },
    carreteras: {
        title: 'Infraestructura Vial',
        items: [
            { type: 'line', color: '#e67e22', height: '3px', label: 'Carreteras Nacionales' },
            { type: 'line', color: '#f39c12', height: '2px', dashed: true, label: 'Carreteras Cantonales' }
        ]
    },
    hidrografia: {
        title: 'Hidrografía',
        items: [
            { type: 'line', color: '#2980b9', height: '2px', label: 'Ríos' }
        ]
    },
    areasVerdes: {
        title: 'Áreas Verdes',
        items: [
            { type: 'icon', color: '#52C165', icon: '', opacity: '0.5', border: '1px solid #2D8A3E', label: 'Parques' },
            { type: 'icon', color: '#A8E6A3', icon: '', opacity: '0.4', border: '1px solid #7BC977', label: 'Zonas Verdes' },
            { type: 'icon', color: '#FFD93D', icon: '', opacity: '0.5', border: '1px solid #E6B800', label: 'Plazas' }
        ]
    },
    poblados: {
        title: 'Poblados',
        items: [
            { type: 'circle', color: '#8e44ad', size: '12px', border: '1px solid white', label: 'Cabeceras Distritales' },
            { type: 'circle', color: '#27ae60', size: '8px', border: '1px solid white', label: 'Poblados Menores' }
        ]
    }
};

// ========================================
// INICIALIZACIÓN DEL MAPA
// ========================================

let map;

function initMap() {
    // Crear el mapa
    map = L.map('map', {
        center: MAP_CONFIG.center,
        zoom: MAP_CONFIG.zoom,
        minZoom: MAP_CONFIG.minZoom,
        maxZoom: MAP_CONFIG.maxZoom,
        zoomControl: true
    });

    // Agregar tiles personalizados
    const customTiles = L.tileLayer('tiles/{z}/{x}/{y}.png', {
        attribution: 'Dylan Cachón & Victoria Sandí | TEC 2025 | <a href="https://www.openstreetmap.org/copyright">© OpenStreetMap</a>',
        minZoom: MAP_CONFIG.minZoom,
        maxZoom: MAP_CONFIG.maxZoom,
        tileSize: 256,
        errorTileUrl: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='
    }).addTo(map);

    // Manejo de errores
    customTiles.on('tileerror', function(error) {
        console.warn('Error cargando tile:', error);
    });

    // Agregar control de escala
    L.control.scale({
        position: 'bottomright',
        imperial: false,
        metric: true
    }).addTo(map);

    return map;
}

// ========================================
// GENERACIÓN DE LEYENDA DINÁMICA
// ========================================

function generateLegend() {
    const container = document.getElementById('legendContainer');
    let html = '<h4>Leyenda</h4>';

    for (const sectionKey in LEGEND_DATA) {
        const section = LEGEND_DATA[sectionKey];
        html += `
            <div class="legend-section">
                <h5>${section.title}</h5>
        `;

        section.items.forEach(item => {
            if (item.type === 'icon') {
                html += `
                    <div class="legend-item">
                        <div class="legend-icon" style="background: ${item.color}; ${item.opacity ? `opacity: ${item.opacity};` : ''} ${item.border ? `border: ${item.border};` : ''}">
                            ${item.icon || ''}
                        </div>
                        <span>${item.label}</span>
                    </div>
                `;
            } else if (item.type === 'line') {
                const style = item.dashed 
                    ? `border-top: 2px dashed ${item.color}; height: 2px; background: transparent;`
                    : `background: ${item.color}; height: ${item.height};`;
                html += `
                    <div class="legend-item">
                        <div class="legend-line" style="${style}"></div>
                        <span>${item.label}</span>
                    </div>
                `;
            } else if (item.type === 'circle') {
                html += `
                    <div class="legend-item">
                        <div class="legend-circle" style="background: ${item.color}; width: ${item.size}; height: ${item.size}; ${item.border ? `border: ${item.border};` : ''}"></div>
                        <span>${item.label}</span>
                    </div>
                `;
            }
        });

        html += '</div>';
    }

    container.innerHTML = html;
}

// ========================================
// FUNCIONALIDAD DEL PANEL
// ========================================

function togglePanel() {
    const panel = document.getElementById('infoPanel');
    panel.classList.toggle('active');
}

function closePanel() {
    if (window.innerWidth <= 768) {
        const panel = document.getElementById('infoPanel');
        panel.classList.remove('active');
    }
}

// ========================================
// EVENTOS Y LOGÍSTICA
// ========================================

function setupMapEvents() {
    // Mostrar información de zoom en consola
    map.on('zoomend', function() {
        const currentZoom = map.getZoom();
        console.log('Zoom actual:', currentZoom);
        
        if (ZOOM_INFO[currentZoom]) {
            console.log(ZOOM_INFO[currentZoom]);
        }
    });

    // Cerrar panel al hacer clic en el mapa (móvil)
    map.on('click', closePanel);

    // Mostrar coordenadas al hacer clic
    map.on('click', function(e) {
        console.log('Coordenadas:', 
            e.latlng.lat.toFixed(5), ',', 
            e.latlng.lng.toFixed(5)
        );
    });

    // Ajustar tamaño del mapa al redimensionar ventana
    window.addEventListener('resize', function() {
        map.invalidateSize();
    });
}

// ========================================
// LOGO DE BIENVENIDA
// ========================================

function showWelcomeMessage() {
    console.log('═══════════════════════════════════════════════');
    console.log('Mapa de San Carlos cargado correctamente');
    console.log('Proyecto 3 - SIG | TEC Costa Rica 2025');
    console.log('Dylan Cachón & Victoria Sandí');
    console.log('═══════════════════════════════════════════════');
    console.log('Características del mapa:');
    console.log('- DEM con 13 colores hipsométricos');
    console.log('- Hillshade con exageración vertical 3.5x');
    console.log('- 18 capas de información');
    console.log('- Zoom 8-16 (9 niveles)');
    console.log('- Tiles 256x256px');
    console.log('═══════════════════════════════════════════════');
}

// ========================================
// INICIALIZACIÓN COMPLETA
// ========================================

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar mapa
    map = initMap();
    
    // Generar leyenda dinámicamente
    generateLegend();
    
    // Configurar eventos
    setupMapEvents();
    
    // Mostrar mensaje de bienvenida
    showWelcomeMessage();
    
    // Configurar botón toggle
    document.getElementById('togglePanelBtn').addEventListener('click', togglePanel);
    
    // Mostrar que el mapa está listo
    map.whenReady(function() {
        console.log('✓ Mapa listo y funcionando');
        console.log('✓ Centro: San Carlos [10.47, -84.43]');
        console.log('✓ Zoom actual:', map.getZoom());
    });
});