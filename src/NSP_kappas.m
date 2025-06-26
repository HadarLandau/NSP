kappa_25=[12.8; 2.55; 2.13; 2.04; 2; 2];
kappa_1=[2.35; 2.08; 2.04; 2; 2; 2];
kappa_3i=[1.19; 1.62; 1.87; 2; 2; 2];
kappa_7i=[1.004; 1.12; 1.51; 1.85; 1.96; 2];
k=[1; 2; 3; 4; 5; 6];

figure
plot(k,kappa_25)
ylim([1 14])
title('theta=2.5','FontSize', 19)
xlabel('k','FontSize', 19)
ylabel('kappa', 'FontSize', 19)

figure
plot(k,kappa_1)
ylim([1.5 2.5])
title('theta=1','FontSize', 19)
xlabel('k','FontSize', 19)
ylabel('kappa','FontSize', 19)

figure
plot(k,kappa_3i)
ylim([1 2.1])
title('theta=3i','FontSize', 19)
xlabel('k','FontSize', 19)
ylabel('kappa','FontSize', 19)

figure
plot(k,kappa_7i)
ylim([1 2.1])
title('theta=7i','FontSize', 19)
xlabel('k','FontSize', 19)
ylabel('kappa','FontSize', 19)
