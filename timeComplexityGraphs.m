z = 1:1:40;
x = 1:1:20;
bruteForce = zeros(20);
Held_Karp = zeros(20);

for i=1:20
    bruteForce(i) = factorial(x(i));
    Held_Karp(i) = x(i)^2 .* 2^x(i);
end

nearest = zeros(40);
clarke = zeros(40);

for i=1:40
    nearest(i) = z(i)^2;
    clarke(i) = z(i)^2;
end



subplot(1, 2, 1);
hold on
plot(z, clarke, 'LineWidth', 1.2, Color='k')
plot(z, nearest, 'LineWidth', 1.2, Color='k')
legend('Nearest Neighbour', 'Clarke-Wright Savings')
title('Heuristics')
xlabel('Number of cities')
ylabel('Time')
ylim([0, 1000])
hold off

subplot(1, 2, 2);
hold on
plot(x, bruteForce, 'LineWidth', 1.2, Color='r')
plot(x, Held_Karp, 'LineWidth', 1.2, Color='k')
legend('Brute Force', 'Held-Karp')
title('Exact Algorithms')
xlabel('Number of cities')
ylabel('Time')
ylim([0, 1000000])
hold off