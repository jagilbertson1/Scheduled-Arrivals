function res = Cost_3_2(a)
    if (a == 0)
        res = 4.94061;
    else
        res = 2.76002 + 0.5 * a + (2.18058 + (1.64681 + 0.25 * a) * a) * exp(-a) - 0.5 * a^2 / (exp(a) - 1);
    end
end