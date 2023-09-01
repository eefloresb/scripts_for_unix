#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Edwin Enrique Flores Bautista
# Email: eflores@canvia.com

#Script que comparte 2 valores para ver si están identicos durante el copiado
rm archivos_faltantes.txt archivos_copiados_correctamente.txt archivos_copiados_con_error.txt
DirOrigen=/backup/BKP_TALMABD_31032023
DirDestin=/prd
for line in `ls -C1 $DirOrigen/*`; do
  line=${line##/*/}
  if ls -C1 $DirDestin/$line &>/dev/null; then
    tamanio_archivo1=$(stat -c %s "$DirOrigen/$line")
    tamanio_archivo2=$(stat -c %s "$DirDestin/$line")
  else
    echo " El archivo $line no existe en la ruta destino $DirDestin" >> archivos_faltantes.txt
    continue
  fi

# Comparar los tamaños de los archivos
if [[ $tamanio_archivo1 -eq $tamanio_archivo2 ]]; then
    echo "El archivo $line tienen el mismo tamaño en bytes." >> archivos_copiados_correctamente.txt
else
    echo "El archivo $line tienen tamaños diferentes en bytes." >> archivos_copiados_con_error.txt
fi
done
echo "archivos copiados correctamente: "
echo "---------------------------------"
cat archivos_copiados_correctamente.txt
echo "###############################################"
echo "archivo copiados que no tienen el mismo sizing"
echo "----------------------------------------------"
cat archivos_copiados_con_error.txt
echo "###############################################"
echo "archivos que faltan en el servidor remoto"
echo "-----------------------------------------"
cat archivos_faltantes.txt