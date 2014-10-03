function [ B ] = RebuildField7bis(bc,bs,rhoReference,rk,mode )
% Calculate the fields at given position
% the list rk gives each position
numberDregree = max(size(bc(1).coefficient,2),size(bs(1).coefficient,2))-1;
numberOrder = max(size(bc(1).coefficient,1),size(bs(1).coefficient,1))-1;

if size(rk,2) <6
    for i=1:size(rk,1)
        x = rk(i,1);
        y = rk(i,2);
        z = rk(i,3);
        rk(i,4) = sqrt(x^2+y^2+z^2); % rho
        rk(i,6) = acos(z/rk(i,4)); % theta
        rk(i,5) = atan2(y,x); % phi
    end
end

B = zeros(3,size(rk,1));
for i=1:size(rk,1)
    rho = rk(i,4);
    phi = rk(i,5);
    theta = rk(i,6);
        for l=0:numberDregree
            scaling=(rho/rhoReference)^(l);
            L = legendre(l,cos(theta));
            %calculate the minimum between l and maxM
            maxOrder = min(l,numberOrder);
            for m=0:maxOrder
                if strcmp(mode,'norm')
                    K = sqrt((2*l+1)*factorial(l-m)/(factorial(l+m)*4*pi)); %mathematical normalization
                elseif strcmp(mode,'sch')
                    K = sqrt(factorial(l-m)/(factorial(l+m))); % schmidt quasi normal without the factor (2*l+1)/(4*pi)
                else
                    disp('error, the normalization is not recognized')
                    K = 0;
                end
                if m>0
                    Yc = sqrt(2)*K*L(m+1)*cos(m*phi);
                    Ys = sqrt(2)*K*L(m+1)*sin(m*phi);
                else
                    Yc = K*L(m+1)*cos(m*phi);
                    Ys = 0; % This one is just impossible (i.e. m<0 and m=0)
                end
                B(1,i) = B(1,i) + bc(1).coefficient(l+1,m+1)*scaling*Yc;
                B(2,i) = B(2,i) + bc(2).coefficient(l+1,m+1)*scaling*Yc;
                B(3,i) = B(3,i) + bc(3).coefficient(l+1,m+1)*scaling*Yc;

                B(1,i) = B(1,i) + bs(1).coefficient(l+1,m+1)*scaling*Ys;
                B(2,i) = B(2,i) + bs(2).coefficient(l+1,m+1)*scaling*Ys;
                B(3,i) = B(3,i) + bs(3).coefficient(l+1,m+1)*scaling*Ys;
            end
        end
end


