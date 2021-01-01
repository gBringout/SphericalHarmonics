function [ B ] = RebuildField7(bc,bs,rhoReference,x,y,z,mode )
% Calculate the fields on a grid
% define by the vector x,y and z
numberDregree = max(size(bc(1).coefficient,2),size(bs(1).coefficient,2));

%activate the parallel function if available
if license('test','Distrib_Computing_Toolbox')
    matlabVersion = version;
    matlabVersion = str2num(matlabVersion(1:3));
    if matlabVersion < 8.2
        [TF,~] = license('checkout', 'Distrib_Computing_Toolbox');
        if TF
            schd = findResource('scheduler', 'configuration', 'local');
            numWorkers = schd.ClusterSize;
        end

        if matlabpool('size') == 0  && TF && numWorkers >1
            % checking to see if the pool is already open and of we have the licence
            % and at least 2 cores
            matlabpool open
        end
    elseif matlabVersion >= 8.2 
        poolobj = gcp('nocreate'); % If no pool, do not create new one.
        if isempty(poolobj)
            parpool;
        end
    end
end

B = zeros(3,size(x,2),size(y,2),size(z,2));
Bx = zeros(size(x,2),size(y,2),size(z,2));
By = zeros(size(x,2),size(y,2),size(z,2));
Bz = zeros(size(x,2),size(y,2),size(z,2));
parfor i=1:size(x,2)
%for i=1:size(x,2)
    Tempx = zeros(size(y,2),size(z,2));
    Tempy = zeros(size(y,2),size(z,2));
    Tempz = zeros(size(y,2),size(z,2));
    for j=1:size(y,2)
        for k=1:size(z,2)
            rho = sqrt(x(i)^2+y(j)^2+z(k)^2);
            theta = acos(z(k)/rho);
            %To correct the phase stuff
            phi = atan2(y(j),x(i));
            if rho<rhoReference
                for l=0:numberDregree-1
                    scaling=(rho/rhoReference)^(l);
                    L = legendre(l,cos(theta));
                    for m=0:l
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
                            Tempx(j,k) = Tempx(j,k) + bc(1).coefficient(l+1,m+1)*scaling*Yc;
                            Tempy(j,k) = Tempy(j,k) + bc(2).coefficient(l+1,m+1)*scaling*Yc;
                            Tempz(j,k) = Tempz(j,k) + bc(3).coefficient(l+1,m+1)*scaling*Yc;

                            Tempx(j,k) = Tempx(j,k) + bs(1).coefficient(l+1,m+1)*scaling*Ys;
                            Tempy(j,k) = Tempy(j,k) + bs(2).coefficient(l+1,m+1)*scaling*Ys;
                            Tempz(j,k) = Tempz(j,k) + bs(3).coefficient(l+1,m+1)*scaling*Ys;
                    end
                end

            end
        end
    end
    Bx(i,:,:) = Tempx;
    By(i,:,:) = Tempy;
    Bz(i,:,:) = Tempz;
end
B(1,:,:,:) = Bx;
B(2,:,:,:) = By;
B(3,:,:,:) = Bz;

end

