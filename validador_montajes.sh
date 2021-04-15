#
# Validador de FS montados e Intefridad de /etc/fstab
# Para validar montajes lee el archivo /opt/vmonatjes/montajes.txt y los compara con los FS activados
# Para Comprobar Integridad calcula el md5 del archivo /etc/fstab y del archivo /opt/vmonatjes/fstab 
# Requisitos: Crear carpeta en /opt/vmonatjes/ y colocar los archivos montajes.txt y fstab validados
#
#
#!/bin/bash
function rev_integridad(){
echo "- revision  --> /etc/fstab"
echo
ft_control=$(md5sum /opt/vmonatjes/fstab|awk {'print $1'})

ft_actu=$(md5sum /etc/fstab|awk {'print $1'})


if [  $ft_control ==  $ft_actu ]
        then
            echo FSTAB CORRECTO
        fi
        if [  $ft_control !=  $ft_actu  ]
        then
             echo FSTAB MODIFICADO!!! 
             echo
        fi          

}

function rev_montajes(){
my_array=( $(cat /opt/vmonatjes/montajes.txt) )            
tLen=${#my_array[@]}
my_array2=( $(df -Pm |awk '{print  $NF}'  ) )            
tLen2=${#my_array2[@]}
for (( i=0; i<${tLen}; i++ ));
do 
    echo "- revision  --> ${my_array[$i]}"
contador=0    
        for (( l=0; l<${tLen2}; l++ ));
    do
        if [  ${my_array[$i]} ==  ${my_array2[$l]} ]
        then
            echo
            echo MONTAJE OK ${my_array[$i]}
        fi
        if [  ${my_array[$i]} !=  ${my_array2[$l]} ]
        then      
     let contador=$contador+1
        fi          
    done
    echo " "
  if [  $contador -eq  ${tLen2} ]
        then
            echo NO SE DETECTO MONTAJE ${my_array[$i]} 
            echo
          fi   
done

}
clear
echo -------------------------------------------------
echo "1) Revisando archivo FSTAB"
echo -------------------------------------------------
rev_integridad
echo -------------------------------------------------

echo "2) Revisando Montajes"
echo -------------------------------------------------

rev_montajes