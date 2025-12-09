/* ═══════════════════════════════════════════════════════════════
   MAPA DE SAN CARLOS
   Dylan Cachón & Victoria Sandí
   TEC Costa Rica - 2025
   ═══════════════════════════════════════════════════════════════ */

/* ===== FONDO Y CAPAS BASE ===== */
Map {
  background-color: #e8f4f8;
}

#dem_san_carlos_colored {
  raster-opacity: 0.7;
  raster-scaling: bilinear;
}

#hillshade_san_carlos {
  raster-opacity: 0.45;
  raster-scaling: bilinear;
}

/* ═══════════════════════════════════════════════════════════════
   DIVISIÓN ADMINISTRATIVA
   ═══════════════════════════════════════════════════════════════ */

#canton_san_carlos {
  [zoom <= 9] {
    line-color: #000;
    line-width: 2.5;
    line-opacity: 0.9;
    polygon-opacity: 0;
    
    ::label {
      text-name: "'San Carlos'";
      text-face-name: "DejaVu Sans Bold";
      text-size: 16;
      text-fill: #000;
      text-halo-fill: rgba(255, 255, 255, 0.95);
      text-halo-radius: 4;
      text-placement: interior;
      text-allow-overlap: true;
    }
  }
  
  [zoom > 9] {
    line-color: #000;
    line-width: 2;
    line-opacity: 0.7;
    polygon-opacity: 0;
  }
}

#distritos_san_carlos {
  [zoom <= 9] {
    line-color: #666;
    line-width: 1;
    line-opacity: 0.4;
    line-dasharray: 3, 3;
    polygon-opacity: 0;
  }
  
  [zoom = 10] {
    line-color: #333;
    line-width: 1.2;
    line-opacity: 0.6;
    line-dasharray: 4, 2;
    polygon-opacity: 0;
    
    ::label {
      text-name: "[NDISTRITO]";
      text-face-name: "DejaVu Sans Book";
      text-size: 10;
      text-fill: #444;
      text-halo-fill: #fff;
      text-halo-radius: 1;
      text-placement: interior;
      text-min-distance: 50;
      [zoom >= 12] { text-size: 11; }
      [zoom >= 14] { text-size: 12; }
      text-allow-overlap: true;
      text-avoid-edges: false;
      text-min-distance: 0;
    }
  }
  
  [zoom > 10] {
    line-color: #333;
    line-width: 1.2;
    line-dasharray: 4, 2;
    line-opacity: 0.6;
    polygon-opacity: 0;
  }
}

/* ═══════════════════════════════════════════════════════════════
   HIDROGRAFÍA - RÍOS (líneas delgadas)
   ═══════════════════════════════════════════════════════════════ */

#rios_san_carlos {
  [zoom >= 10] {
    line-color: #2980b9;
    line-width: 0.8;
    line-opacity: 0.7;
    
    [zoom >= 12] { line-width: 1; }
    [zoom >= 14] { line-width: 1.2; }
    
    ::label[zoom >= 11] {
      text-name: "[NOMBRE]";
      text-face-name: "DejaVu Sans Oblique";
      text-size: 9;
      text-fill: #1a5276;
      text-placement: line;
      text-spacing: 400;
      text-max-char-angle-delta: 25;
      [zoom >= 13] { text-size: 10; }
      [zoom >= 15] { text-size: 11; }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   INFRAESTRUCTURA VIAL 
   ═══════════════════════════════════════════════════════════════ */

#carreteras_san_carlos {
  [zoom >= 10] {
    /* Base para caminos menores */
    line-color: #7f8c8d;
    line-width: 0.8;
    line-opacity: 0.7;
    
    /* CARRETERAS NACIONALES - Naranja, pero más delgadas */
    [TIPO = "CARRETERA NACIONAL"] {
      line-color: #e67e22;
      line-width: 1.5;
      line-opacity: 0.9;
      [zoom >= 12] { line-width: 2; }
      [zoom >= 14] { line-width: 2.5; }
    }
    
    /* CARRETERAS CANTONALES - Naranja claro punteado */
    [TIPO = "CARRETERA CANTONAL"] {
      line-color: #f39c12;
      line-width: 1;
      line-opacity: 0.8;
      line-dasharray: 6, 3;
      [zoom >= 13] { line-width: 1.2; }
    }
    
    /* Etiquetas para carreteras principales */
    ::label[zoom >= 12] {
      [TIPO = "CARRETERA NACIONAL"],
      [TIPO = "CARRETERA CANTONAL"] {
        text-name: "[CODIGO]";
        text-face-name: "DejaVu Sans Bold";
        text-size: 9;
        text-fill: #e67e22;
        text-halo-fill: #fff;
        text-halo-radius: 2;
        text-placement: line;
        text-spacing: 500;
        [zoom >= 14] { text-size: 10; }
      }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   ÁREAS VERDES - POLÍGONOS
   ═══════════════════════════════════════════════════════════════ */

#parques_san_carlos {
  [zoom >= 11] {
    polygon-fill: #52C165;
    polygon-opacity: 0.4;
    line-color: #2D8A3E;
    line-width: 1;
    
    [zoom >= 13] {
      polygon-opacity: 0.5;
      line-width: 1.2;
    }
    
    ::label[zoom >= 12] {
      text-name: "[name]";
      [name = ""] { text-name: "'Parque'"; }
      text-face-name: "DejaVu Sans Bold";
      text-size: 10;
      text-fill: #1E5F2D;
      text-halo-fill: rgba(255, 255, 255, 0.9);
      text-halo-radius: 2;
      text-placement: interior;
      [zoom >= 14] { text-size: 11; }
    }
  }
}

#zonas_verdes_san_carlos {
  [zoom >= 12] {
    polygon-fill: #A8E6A3;
    polygon-opacity: 0.3;
    line-color: #7BC977;
    line-width: 0.8;
    
    [zoom >= 14] {
      polygon-opacity: 0.4;
      
      ::label {
        text-name: "[name]";
        [name = ""] { text-name: "'Zona Verde'"; }
        text-face-name: "DejaVu Sans Book";
        text-size: 9;
        text-fill: #3D8F37;
        text-halo-fill: rgba(255, 255, 255, 0.8);
        text-halo-radius: 1.5;
        text-placement: interior;
      }
    }
  }
}

#plazas_san_carlos {
  [zoom >= 12] {
    polygon-fill: #FFD93D;
    polygon-opacity: 0.4;
    line-color: #E6B800;
    line-width: 1;
    
    [zoom >= 14] {
      polygon-opacity: 0.5;
      
      ::label {
        text-name: "'Plaza'";
        text-face-name: "DejaVu Sans Bold";
        text-size: 10;
        text-fill: #B38600;
        text-halo-fill: rgba(255, 255, 255, 0.9);
        text-halo-radius: 2;
        text-placement: interior;
      }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   POBLADOS - CON SVG
   ═══════════════════════════════════════════════════════════════ */

#poblprinc_san_carlos {
  [zoom >= 9] {
    marker-file: url("iconos/poblados_principales.svg");
    marker-fill: #8e44ad;
    marker-line-color: #fff;
    marker-line-width: 1.2;
    marker-opacity: 0.9;
    marker-width: 8;
    marker-allow-overlap: false;
    
    [zoom >= 11] { marker-width: 10; }
    [zoom >= 13] { marker-width: 12; }
    
    ::label[zoom >= 10] {
      text-name: "[NOMDISTR]";
      text-face-name: "DejaVu Sans Bold";
      text-size: 11;
      text-fill: #8e44ad;
      text-halo-fill: rgba(255, 255, 255, 0.8);
      text-halo-radius: 2;
      text-dy: -12;
      text-allow-overlap: true;
      [zoom >= 12] { text-size: 12; }
      [zoom >= 14] { text-size: 13; }
    }
  }
}

#poblados_san_carlos {
  [zoom >= 12] {
    marker-file: url("iconos/poblados.svg");
    marker-fill: #27ae60;
    marker-line-color: #fff;
    marker-line-width: 0.6;
    marker-opacity: 0.8;
    marker-width: 5;
    marker-allow-overlap: false;
    
    [CATEGORIA = "Urbano"] {
      marker-fill: #16a085;
      marker-width: 6;
    }
    [CATEGORIA = "Rural"] {
      marker-fill: #27ae60;
      marker-width: 5;
    }
    
    [zoom >= 14] { marker-width: 6; }
    
    ::label[zoom >= 13] {
      text-name: "[NOMBRE]";
      text-face-name: "DejaVu Sans Book";
      text-size: 9;
      text-fill: #2c3e50;
      text-halo-fill: rgba(255, 255, 255, 0.7);
      text-halo-radius: 1;
      text-dy: -8;
      [zoom >= 15] { text-size: 10; }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   SERVICIOS DE SALUD
   ═══════════════════════════════════════════════════════════════ */

#hospitales_san_carlos {
  [zoom >= 11] {
    marker-file: url("iconos/hospitales.svg");
    marker-width: 22; 
    marker-opacity: 1;
    marker-fill: #D10000;
    marker-line-color: #FFFFFF;
    marker-line-width: 2.5;
    
    marker-allow-overlap: true;
    marker-ignore-placement: true;
    marker-clip: false;
    
    [zoom >= 13] { marker-width: 26; }
    [zoom >= 14] { marker-width: 30; }
    [zoom >= 15] { marker-width: 32; }
    
    ::label[zoom >= 12] {
      text-name: "[NOMBRE]";
      text-face-name: "DejaVu Sans Bold";
      text-size: 11;
      text-fill: #D10000;
      text-halo-fill: rgba(255, 255, 255, 1);
      text-halo-radius: 3;
      
      text-allow-overlap: true;
      text-avoid-edges: false;
      text-min-distance: 0;
      
      [zoom >= 14] { 
        text-size: 12;
        text-dy: 28;
      }
      [zoom >= 15] { 
        text-size: 13;
        text-dy: 30;
      }
    }
  }
}

#clinicas_san_carlos {
  [zoom >= 13] {
    marker-file: url("iconos/clinicas.svg");
    marker-width: 16;
    marker-opacity: 0.95;
    marker-fill: #FF6B6B;
    marker-line-color: #FFFFFF;
    marker-line-width: 1.5;
    
    [TIPO = "E.B.A.I.S"] {
      marker-fill: #FF8C8C;
    }
    [TIPO = "C.C.S.S"] {
      marker-fill: #FF6B6B;
    }
    
    [zoom >= 14] { marker-width: 18; }
    [zoom >= 15] { marker-width: 20; }
    
    ::label[zoom >= 14] {
      text-name: "[NOMBRE]";
      text-face-name: "DejaVu Sans Book";
      text-size: 9;
      text-fill: #C10000;
      text-halo-fill: rgba(255, 255, 255, 0.95);
      text-halo-radius: 2;
      text-dy: 18;
      
      [zoom >= 15] { text-size: 10; }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   EDUCACIÓN 
   ═══════════════════════════════════════════════════════════════ */

#escuela_san_carlos {
  [zoom >= 13] {
    marker-file: url("iconos/escuelas.svg");
    marker-width: 12;
    marker-opacity: 0.9;
    marker-allow-overlap: false;
    
    [DEPENDENCI = "PUB"] {
      marker-fill: #2980b9;
      marker-line-color: #1a5276;
    }
    [DEPENDENCI = "PRI"] {
      marker-fill: #8e44ad;
      marker-line-color: #6c3483;
    }
    [DEPENDENCI = "SUB"] {
      marker-fill: #27ae60;
      marker-line-color: #1e8449;
    }
    
    [zoom >= 14] { marker-width: 14; }
    
    ::label[zoom >= 14] {
      text-name: "'ESCUELA '+"[NOMBRE]"";
      text-face-name: "DejaVu Sans Book";
      text-size: 9;
      text-fill: #2c3e50;
      text-halo-fill: rgba(255, 255, 255, 0.8);
      text-halo-radius: 1;
      text-dy: 14;
      
      [DEPENDENCI = "PUB"] { text-fill: #2980b9; }
      [DEPENDENCI = "PRI"] { text-fill: #8e44ad; }
      [DEPENDENCI = "SUB"] { text-fill: #27ae60; }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   SERVICIOS FINANCIEROS
   ═══════════════════════════════════════════════════════════════ */

#agentes_bancarios_san_carlos {
  [zoom >= 13] {
    marker-file: url("iconos/bancos.svg");
    marker-width: 12;
    marker-opacity: 0.9;
    marker-allow-overlap: false;
    
    [BANCO = "BANCO CREDITO AGRICOLA DE CARTAGO"] {
      marker-fill: #27ae60;
      marker-line-color: #1e8449;
    }
    [BANCO = "BANCO NACIONAL DE COSTA RICA"] {
      marker-fill: #3498db;
      marker-line-color: #2980b9;
    }
    [BANCO = "BANCO DE COSTA RICA"] {
      marker-fill: #3498db;
      marker-line-color: #2980b9;
    }
    [BANCO = "BANCO POPULAR"] {
      marker-fill: #f1c40f;
      marker-line-color: #f39c12;
    }
    [BANCO = "MUTUAL ALAJUELA"] {
      marker-fill: #8e44ad;
      marker-line-color: #6c3483;
    }
    [BANCO = "BANCO INTERFIN"] {
      marker-fill: #d35400;
      marker-line-color: #a04000;
    }
    [BANCO = "BANCO BAC-SAN JOSE"] {
      marker-fill: #1abc9c;
      marker-line-color: #16a085;
    }
    
    [zoom >= 14] { marker-width: 13; }
    
    ::label[zoom >= 14] {
      text-name: "'Bancredito'";
      [BANCO = "BANCO NACIONAL DE COSTA RICA"] { text-name: "'BNCR'"; }
      [BANCO = "BANCO DE COSTA RICA"] { text-name: "'BCR'"; }
      [BANCO = "BANCO POPULAR"] { text-name: "'BP'"; }
      [BANCO = "MUTUAL ALAJUELA"] { text-name: "'MUTUAL'"; }
      [BANCO = "BANCO INTERFIN"] { text-name: "'INTERFIN'"; }
      [BANCO = "BANCO BAC-SAN JOSE"] { text-name: "'BAC'"; }
      
      text-face-name: "DejaVu Sans Bold";
      text-size: 8;
      text-fill: #2c3e50;
      text-halo-fill: rgba(255, 255, 255, 0.8);
      text-halo-radius: 1;
      text-dy: 14;
      
      [BANCO = "BANCO CREDITO AGRICOLA DE CARTAGO"] { text-fill: #27ae60; }
      [BANCO = "BANCO NACIONAL DE COSTA RICA"] { text-fill: #3498db; }
      [BANCO = "BANCO DE COSTA RICA"] { text-name: "'BCR'"; text-fill: #3498db; }
      [BANCO = "BANCO POPULAR"] { text-fill: #f39c12; }
      [BANCO = "MUTUAL ALAJUELA"] { text-fill: #8e44ad; }
      [BANCO = "BANCO INTERFIN"] { text-fill: #d35400; }
      [BANCO = "BANCO BAC-SAN JOSE"] { text-fill: #16a085; }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   SERVICIOS TURÍSTICOS
   ═══════════════════════════════════════════════════════════════ */

#hoteles_san_carlos {
  [zoom >= 13] {
    marker-file: url("iconos/hoteles.svg");
    marker-width: 12;
    marker-opacity: 0.9;
    
    [CATEGORIA_ = "1"] {
      marker-fill: #f1c40f;
      marker-width: 10;
    }
    [CATEGORIA_ = "2"] {
      marker-fill: #f39c12;
      marker-width: 11;
    }
    [CATEGORIA_ = "3"] {
      marker-fill: #e67e22;
      marker-width: 12;
    }
    [CATEGORIA_ = "4"] {
      marker-fill: #d35400;
      marker-width: 13;
    }
    [CATEGORIA_ = "5"] {
      marker-fill: #a04000;
      marker-width: 14;
      marker-line-width: 1.5;
    }
    
    [zoom >= 14] { 
      [CATEGORIA_ = "5"] { marker-width: 16; }
    }
    
    ::label[zoom >= 14] {
      text-name: "[NOMBRE]";
      text-face-name: "DejaVu Sans Book";
      text-size: 9;
      text-fill: #7d3c98;
      text-halo-fill: rgba(255, 255, 255, 0.8);
      text-halo-radius: 1;
      text-dy: 16;
    }
  }
}

#gasolineras_san_carlos {
  [zoom >= 13] {
    marker-file: url("iconos/gasolineras.svg");
    marker-width: 12;
    marker-opacity: 0.9;
    marker-fill: #2c3e50;
    marker-line-color: #1c2833;
    
    [zoom >= 14] { marker-width: 14; }
    
    ::label[zoom >= 14] {
      text-name: "[OTRO_NOMBR]";
      [OTRO_NOMBR = "NA"] {
        text-name: "[NOMBRE_REC]";
      }
      text-face-name: "DejaVu Sans Book";
      text-size: 9;
      text-fill: #2c3e50;
      text-halo-fill: rgba(255, 255, 255, 0.8);
      text-halo-radius: 1;
      text-dy: 15;
    }
  }
}

/* ═══════════════════════════════════════════════════════════════
   COMERCIOS
   ═══════════════════════════════════════════════════════════════ */

#comercios_san_carlos {
  [zoom >= 14] {
    marker-file: url("iconos/tiendas.svg");
    marker-width: 10;
    marker-opacity: 0.7;
    marker-fill: #8e44ad;
    marker-line-color: #6c3483;
    marker-line-width: 0.8;
    
    [zoom >= 15] { marker-width: 12; }
    
    ::label[zoom >= 15] {
      text-name: "[name]";
      [name = ""] { text-name: "'Comercio'"; }
      text-face-name: "DejaVu Sans Book";
      text-size: 8;
      text-fill: #6c3483;
      text-halo-fill: rgba(255, 255, 255, 0.7);
      text-halo-radius: 1;
      text-dy: 12;
    }
  }
}
