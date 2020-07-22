NeuronalNetworkCasADi

## DEpendencias 

- Es necesario tener casadi agregado en el path de MATLAB
- Esta hecho en MATLAB R2020a (por si hay alguna cosa que no es compatible)
## pic2data.m: 

Script que transforma las imagenes en un data set manejable. Este dataset esta 'DigitDataset/DataSet.mat'
    En cada componte contiene una base de datos de cada numero

```matlab
>> DataSet

DataSet = 

  1×10 struct array with fields:

    YData
    XData
```

Por ejemplo para extraer los datos del numero 2 

```matlab
>> DataSet(3)

ans = 

  struct with fields:

    YData: 2
    XData: [28×28×1000 double]
```

Para el número 2 hay 1000 ejemplos de matrix 28x28 donde esta dibujado a mano el numero 2.

Para verolo podemos hacer 

```
figure(1)
clf
number = 2;
for i = 1:16
    subplot(4,4,i)
    surf(DataSet(number+1).XData(:,:,i))
    view(0,-90)
    shading interp
end
```

![bla bla](https://i.ibb.co/xHy02j4/ejemplo.jpg)



## NNCas.m: 

Implementacion de Red Neuronal en CasaDi ....
