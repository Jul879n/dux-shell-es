# dux-shell-es

Traducción completa al español de [Dux Modular Shell](https://duxlabs.dev) (DMS) 2.1.x.
El archivo `es.json` oficial deja sin traducir ~1850 de 3480 cadenas; este repo las completa
(más 78 de `DCommon`).

## Instalar

```sh
git clone https://github.com/Jul879n/dux-shell-es && cd dux-shell-es && ./install.sh
```

El script copia los JSON a `/usr/share/quickshell/dms`, crea el drop-in de systemd
`DMS_SHELL_DIR` (DMS usa la interfaz embebida en su binario y por defecto ignora esa ruta),
fija `locale: "es"` y reinicia `dms`.

## Actualizaciones

Una actualización del paquete `dms` sobrescribe los archivos: vuelva a ejecutar `./install.sh`.

## Licencia

MIT, igual que DMS. Traducciones generadas con IA y revisadas solo parcialmente;
las correcciones son bienvenidas.
