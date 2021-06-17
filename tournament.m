function Pairs = tournament(Cost,n)
Pairs = zeros(n,1);

k = n*0.95;
k = ceil(k);
for i = 1:n
    best = 1;
    for j = 1:k
        ind = randi(n);
        new = Cost(ind);
        if new > best || best == 1
            best = new;
            Pairs(i,1) = ind;
        end    
    end    
end    
end