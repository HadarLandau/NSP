lambda_25=[0.5631; 0.2298; 0.1868; 0.1764; 0.1716; 0.1716];
lambda_1=[0.2104; 0.1811; 0.1764; 0.1716; 0.1716; 0.1716];
lambda_3i=[0.0435; 0.1200; 0.1552; 0.1716; 0.1716; 0.1716];
lambda_7i=[0.0009; 0.0283; 0.1027; 0.1526; 0.1666; 0.1716];
k=[1; 2; 3; 4; 5; 6];

figure
plot(k,lambda_25)
hold on
plot(k,lambda_1)
ylim([0.1 0.6])
legend('theta=2.5', 'theta=1','FontSize', 19)
xlabel('k','FontSize', 19)
ylabel('\lambda', 'FontSize', 25)

figure
plot(k,lambda_3i)
hold on
plot(k,lambda_7i)
legend('theta=3i', 'theta=7i','FontSize', 19)
xlabel('k','FontSize', 19)
ylabel('\lambda', 'FontSize', 25)
