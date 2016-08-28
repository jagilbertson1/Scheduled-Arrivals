maxA = 10;
h = 0.01;

n = 3;
k = 2;
aOptimal = 1.90481;
costOptimal = 4.32169;

cost0 = Cost_3_2(0);

a = 0:h:maxA;
N = length(a);

costVec = zeros(N, 1);

for i = 1:N
    costVec(i, 1) = Cost_3_2(a(i));
end

figure()
hold on

plot(a, costVec, 'LineWidth', 4)

scatter([0, aOptimal], [cost0, costOptimal], 300, [1, 0.54902, 0], ...
    'filled')

ylim([0, 10])
xlabel('a')
ylabel(sprintf('C_{%d} (a, %d)', n, k))

set(gca, 'FontSize', 30)

hold off