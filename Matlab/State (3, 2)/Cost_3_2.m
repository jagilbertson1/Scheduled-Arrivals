function res = Cost_3_2(a)
    if (a == 0)
        res = 9.88121;
    else
        res = exp(-a) * (-4.36117 + (-3.29362 - 0.5 * a) * a - 1.15888 * exp(a) + (2.29362 - 0.5 * a) * a * exp(a) + (5.52005 + a) * exp(2 * a)) / (exp(a) - 1);
    end
end