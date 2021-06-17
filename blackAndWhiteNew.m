function blackAndWhiteNew()
%% papameters
n = 120; % start populaton MUST BE EVEN
pk = 0.99; % probability of crossover
pm = 0.08 ;% probability of mutation
maxSteps = 3000; % Maximal number of iterations
k = 10; % elite succesion
%% load image and create population
name = 'iet.png';
I = imread(name);
h = height(I);
w = length(I);
I = rgb2gray(I);
I = imcomplement(I);
tresh = graythresh(I);
I = imbinarize(I,tresh);
Im = zeros(1,h*w);
for i = 1:h
    Im((i-1)*w+1:i*w) = I(i,:);
end 

%% create start population
Cost = zeros(n,1);
newCost = zeros(n,1);
P = randi([0,1],n,h*w);
for i = 1:n  
    Cost(i) = -sum(abs(Im-P(i,:)));
end

%% Main loop
for j = 1:maxSteps
    % sorting
    P(:,h*w+1) = Cost;
    P = sortrows(P,h*w+1,'descend');
    P(:,h*w+1) = '';
    Cost = sort(Cost,'descend');
    % --- 
    % random pairing
    perm = randperm(n);
    for iter = 1:n
        Pairs(iter,:) = P(perm(iter),:);
    end 
    % ------ 
%     % roulette
%     numbers = roulatte(Cost,n);
%     for iter = 1:n
%         Pairs(iter,:) = P(numbers(iter),:);
%     end 
    % ------ 
    % tournament 
%     numbers = tournament(Cost,n);
%     numbers = numbers(randperm(height(numbers)));
%     for iter = 1:n
%         Pairs(iter,:) = P(numbers(iter),:);
%     end 
    % ------ 
    newPop = zeros(n,h*w);
    for i = 2:2:n
        if rand <= pk
            a = Pairs(i,:);
            b = Pairs(i-1,:);
            % two points crossing
            point = randi([1,h*w],1);
            point2 = randi([point,h*w],1);
            C1 = a;
%             C1(1:point) = b(1:point);
            C1(point:point2) = b(point:point2);
            C2 = b;
%             C2(1:point) = a(1:point);
            C2(point:point2) = a(point:point2);
            newPop(i,:) = C1;
            newPop(i-1,:) = C2;
        end
    end
    for i =1:n
        if rand <= pm
            m = floor(pm*h*w);
            toMutate = randi([1,h*w],1,m);
            for iter = 1:m
                if newPop(i,toMutate(iter)) == 1
                   newPop(i,toMutate(iter)) = 0;
                else
                    newPop(i,toMutate(iter)) = 1;
                end    
            end    
        end    
    end 
    
    for i = 1:n
        newCost(i,1) = -sum(abs(Im-newPop(i,:)));
    end 
    newPop(:,h*w+1) = newCost;
    newPop = sortrows( newPop,h*w+1,'descend');
    newPop(:,h*w+1) = '';
    newCost = sort(newCost,'descend');
       
    P(k+1:n,:) = newPop(1:n-k,:);
    Cost(k+1:n) = newCost(1:n-k);
    
    P(:,h*w+1) = Cost;
    P = sortrows(P,h*w+1,'descend');
    P(:,h*w+1) = '';
    Cost = sort(Cost,'descend');
       
    BestHistory(j) = Cost(1);
    CurrentHistory(j) = Cost(fix(height(Cost)));
    % show plot
    if mod(j,500) == 0 
        figure(2);
        plot(CurrentHistory,':r'); hold on
        plot(BestHistory,'r'); hold on
        xlabel('Iteration');
        ylabel('OF value');
        legend('Current result','Best result');
    end
       max(Cost)
       if ( Cost(1) == 0)
           break; % widze brek
       end    
end
%% Końcowy wykres
figure(2);
plot(CurrentHistory,':r'); hold on
plot(BestHistory,'r'); hold on
xlabel('Iteration');
ylabel('OF value');
legend('Current result','Best result');
%% Pokaż najlepszego osobnika
P(:,h*w+1) = Cost;
P = sortrows(P,h*w+1,'descend');
P(:,h*w+1) = '';
I = P(1,:);
I = imcomplement(I);
tresh = graythresh(I);
I = imbinarize(I,tresh);
A = reshape(I,h,w);
A = flip(A);
A = imrotate(A,-90);
figure;
imshow(A);

