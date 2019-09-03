d22 = sqrt(20^2+10^2);
d12 = sqrt(30^2+10^2);
d21 = sqrt(20^2+40^2);
d11 = sqrt(30^2+40^2);
d33 = 92.1954;
d23 = 63,2456;

energy = [60,50,40,30,20];

water22_1 = [79,82,79,76,66]/2;
water22_2 = [28,21,16,8,16]/2;
water22_3 = [15,7,2,0,4]/2;
water11_1 = [128,123,114,94,61]/2;
water11_2 = [45,49,38,10,6]/2;
water11_3 = [11,8,5,0,0]/2;
water21_1 = [113,135,130,122,72]/2;
water21_2 = [55,58,56,38,16]/2;
water21_3 = [20,21,18,5,2]/2;
water12_1 = [112,119,108,95,83]/2;
water12_2 = [51,54,36,24,30]/2;
water12_3 = [26,14,11,4,3]/2;
water23_1 = [119,102,60,44,17]/2;
water23_2 = [41,28,8,2,0]/2;
water23_3 = [12,7,2,0,0]/2;
water33_1 = [14,2,0,0,0]/2;
water33_2 = [0,0,0,0,0]/2;
water33_3 = [0,0,0,0,0]/2;

figure(1)
subplot(1,3,1)
hold on
plot(energy,water22_1);
plot(energy,water12_1);
plot(energy,water21_1);
plot(energy,water11_1);
plot(energy,water23_1);
plot(energy,water33_1);
ylim([0,80]);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title("Percentsge of Event vs. Energy (One-PMT Threshold)")
legend({sprintf('%.2fm',d22),sprintf('%.2fm',d12)...
     sprintf('%.2fm',d21),sprintf('%.2fm',d11)...
    sprintf('%.2fm',d23),sprintf('%.2fm',d33)},'Location','northwest')

subplot(1,3,2)
hold on
plot(energy,water22_2);
plot(energy,water12_2);
plot(energy,water21_2);
plot(energy,water11_2);
plot(energy,water23_2);
plot(energy,water33_2);
ylim([0,80]);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title("Percentsge of Event vs. Energy (Two-PMT Threshold)")
legend({sprintf('%.2fm',d22),sprintf('%.2fm',d12)...
     sprintf('%.2fm',d21),sprintf('%.2fm',d11)...
    sprintf('%.2fm',d23),sprintf('%.2fm',d33)},'Location','northwest')

subplot(1,3,3)
hold on
plot(energy,water22_3);
plot(energy,water12_3);
plot(energy,water21_3);
plot(energy,water11_3);
plot(energy,water23_3);
plot(energy,water33_3);
ylim([0,80]);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title("Percentsge of Event vs. Energy (Three-PMT Threshold)")
legend({sprintf('%.2fm',d22),sprintf('%.2fm',d12)...
     sprintf('%.2fm',d21),sprintf('%.2fm',d11)...
    sprintf('%.2fm',d23),sprintf('%.2fm',d33)},'Location','northwest')


figure(2)
subplot(2,2,1)
hold on
plot(energy,water22_1);
plot(energy,water22_2);
plot(energy,water22_3);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title(sprintf('Distance %.2fm',d22))
legend({'One PMT', 'Two PMTs', 'Three PMTs'},'Location','northwest')

subplot(2,2,2)
hold on
plot(energy,water21_1);
plot(energy,water21_2);
plot(energy,water21_3);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title(sprintf('Distance %.2fm',d21))
legend({'One PMT', 'Two PMTs', 'Three PMTs'},'Location','northwest')

subplot(2,2,3)
hold on
plot(energy,water12_1);
plot(energy,water12_2);
plot(energy,water12_3);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title(sprintf('Distance %.2fm',d12))
legend({'One PMT', 'Two PMTs', 'Three PMTs'},'Location','northwest')

subplot(2,2,4)
hold on
plot(energy,water11_1);
plot(energy,water11_2);
plot(energy,water11_3);
xlabel('Energy (TeV)');
ylabel('Percentage (%)');
title(sprintf('Distance %.2fm',d11))
legend({'One PMT', 'Two PMTs', 'Three PMTs'},'Location','northwest')