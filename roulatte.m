function randNumbers = roulatte(Cost,n)
summ = sum(Cost);
prob = Cost*100/summ;
prob = [0;prob];
for i = 2:n+1
    prob(i) = prob(i-1) + prob(i);
end
randNumbers = randi([0,100],n,1);
prob(n+1) = prob(n+1) + 0.0001;
prob(1) = prob(1) - 0.0001;
for i = 1:1:n
    point = randNumbers(i);
    for j = 1:n
        if ( point > prob(j) && point <= prob(j+1))
            randNumbers(i) = j;
            break;
        end    
    end    
end
end