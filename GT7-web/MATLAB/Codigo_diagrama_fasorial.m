%% 1. Carga de los datos reales extraídos de PicoScope

load('Carga III Equilibr.mat');

vA=A; 
vB=B; 
vC=C;

if exist('Tinterval', 'var')
    fs=1/Tinterval;
else
    fs=5000;
end

f_red=50;
t=(0:length(vA)-1)'/fs;

%% 2. Obtención de los fasores a partir de las ondas temporales

L=length(vA);
NFFT=2^nextpow2(L);
f_axis=fs*(0:(NFFT/2))/NFFT;

obtenerFasor=@(x) 2*fft(x, NFFT)/L;

FasorA_raw=obtenerFasor(vA);
FasorB_raw=obtenerFasor(vB);
FasorC_raw=obtenerFasor(vC);

[~, idx]=min(abs(f_axis - f_red));

Va=FasorA_raw(idx);
Vb=FasorB_raw(idx);
Vc=FasorC_raw(idx);

%% 3. Se establece la referencia de tensiones en la fase A (Fase A = 0°)

fase_ref=angle(Va);
Va=Va*exp(-1i * fase_ref);
Vb=Vb*exp(-1i * fase_ref);
Vc=Vc*exp(-1i * fase_ref);

%% 4. Visualización de los resultados de PicoScope

figure('Color', 'w', 'Position', [100, 100, 1000, 450]);

subplot(1,2,1);
plot(t, vA, 'r', t, vB, 'g', t, vC, 'b', 'LineWidth', 1.2);
grid on; 
xlim([0, 0.06]);
title('Señales de Tensión en el Tiempo');
xlabel('Tiempo (s)'); 
ylabel('Tensión (V)');
legend('Fase R', 'Fase S', 'Fase T');

subplot(1,2,2);
compass(Va, 'r'); hold on;
compass(Vb, 'g');
compass(Vc, 'b');
title(['Diagrama Fasorial a ', num2str(f_red), ' Hz']);
set(findobj(gca, 'type', 'line'), 'LineWidth', 2);

%% 5. Parámetros de la red

fprintf('--- ANÁLISIS SISTEMA TRIFÁSICO ---\n');
fprintf('V_pico A: %.2f V | Fase: %.2f°\n', abs(Va), rad2deg(angle(Va)));
fprintf('V_pico B: %.2f V | Fase: %.2f°\n', abs(Vb), rad2deg(angle(Vb)));
fprintf('V_pico C: %.2f V | Fase: %.2f°\n', abs(Vc), rad2deg(angle(Vc)));
fprintf('----------------------------------\n');
fprintf('Desfase AB: %.2f° (Ideal 120°)\n', abs(rad2deg(angle(Va) - angle(Vb))));
fprintf('Desfase BC: %.2f° (Ideal 120°)\n', abs(rad2deg(angle(Vb) - angle(Vc))));