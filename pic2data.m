clear
numbers = 0:9;

%% Para cada imagen de numeros creados matrices
for inumber = numbers
    DataSet(inumber+1).YData = inumber;
    path = fullfile('DigitDataset',num2str(inumber),'*.png');

    files = ls(path);
    % quitamos los enters y los remplazamos por espacios 
    files = replace(files,newline,' ');
    % remplazamos los retornos de carro
    files = replace(files,'	',' ');
    % dividimos la cadena en celdas 
    files = strsplit(files,' ');
    % quitamos el ultimo, siempre esta vacio
    files = files(1:end-1);
    %%
    DataSet(inumber+1).XData = zeros(28,28,length(files));

    it = 0;
    for ifile = files
        it = it + 1;
        DataSet(inumber+1).XData(:,:,it) = imread(ifile{:});
    end
end
%% Veamos los unos
figure(1)
clf
number = 1;
for i = 1:16
    subplot(4,4,i)
    surf(DataSet(number).XData(:,:,i))
    view(0,-90)
    shading interp
end
%% Veamos los dos
figure(2)
clf
number = 2;
for i = 1:16
    subplot(4,4,i)
    surf(DataSet(number).XData(:,:,i))
    view(0,-90)
    shading interp
end
%% Guardamos los datos
save('DigitDataset/DataSet','DataSet')

