function [finalpos, finalang] = particle_filter(robot, map) 
echo on
    clf;
    COM_CloseNXT all 
    h =COM_OpenNXT();
    COM_SetDefaultNXT(h); 
    OpenUltrasonic(SENSOR_4);
    
    map = [0,0; 66,0; 66,44; 44,44; 44,66; 110,66; 110,110; 0,110];
    robot = BotSim (map);
    %robot.setBotPos([22, 22]);
    robot.setBotAng(3/2*pi);
    NUMBER_OF_SCANS = 6;
    STD_THRESHOLD = 2.5;
    robot.setScanConfig(robot.generateScanConfig(NUMBER_OF_SCANS));
    hold on;
    figure
    robot.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
    %  robot.drawBot(30,'g'); %draw robot with line length 30 and green
     %% setup code
    %you can modify the map to take account of your robots configuration space
    modifiedMap = map; %you need to do this modification yourself
    robot.setMap(modifiedMap);
    %generate some random particles inside the map
    num =500; % number of particles
    particles(num,1) = BotSim; %how to set up a vector of objects
    for i = 1:num
        particles(i) = BotSim(modifiedMap);  %each particle should use the same map as the botSim object
        particles(i).randomPose(0); %spawn the particles in random locations
        particles(i).setMotionNoise(0.01);
        particles(i).setTurningNoise(0.005);
        particles(i).setScanConfig(robot.generateScanConfig(NUMBER_OF_SCANS));
    end

    %% Localisation code
    maxNumOfIterations = 110;
    n = 0;
    resetcount = 0;
    converged =0; %The filter has not converged yet
    scan=zeros(NUMBER_OF_SCANS,num);
    scandiff=zeros(NUMBER_OF_SCANS,num);
    sumdiff=zeros(1,num);
    allavg = zeros(NUMBER_OF_SCANS,1);
    numturns=-1;
    limsMax = max(map);
    maxdimension=max(limsMax);
    while(converged == 0 && n < maxNumOfIterations) %%particle filter loop

        %pause(3)
        n = n+1;
         %% Write code for updating your particles scans

        %get bot scan
        botscan = robot_scan(NUMBER_OF_SCANS)
       
        %scan all particles
        for i = 1:num
            scan(:,i)=particles(i).ultraScan;  
        end


        %% Write code for scoring your particles   
        %difference between particle scan and botscan
        for i = 1:num
           for j = 1:NUMBER_OF_SCANS
               scandiff(j,i)=abs(scan(j,i)-botscan(j));
           end
        end

        %average scan difference
        for i = 1:num
           sumdiff(1,i) = sum(scandiff(:,i))/NUMBER_OF_SCANS;
        end

        %best particle difference
        [best,o] = min(sumdiff);

        %get best particles as parents for next generation
        ascendingdiff=sort(sumdiff);
        diffcutoff=ascendingdiff(1,abs(num/(num/20)));
        z=1;
        nextgencomp=0;
        for i = 1:num
           if sumdiff(1,i) < diffcutoff
                nextgencomp(1:2,z)=particles(i).getBotPos();
                nextgencomp(3,z)=particles(i).getBotAng();
                z=z+1;
                if particles(i).insideMap() == 0
                    particles(i).randomPose(0); 
                end
           end
        end

        %% Write code for resampling your particles

        %use parent particles to generate next generation particles
        [pointless,L]= size(nextgencomp);
        for i=1:num
            if sumdiff(1,i)>diffcutoff
                x=randn;
                y=randn;
                particles(i).setBotPos([nextgencomp(1,randi([1 L]))+x,nextgencomp(2,randi([1 L]))+y]);
                particles(i).setBotAng(nextgencomp(3,randi([1 L])));
                points(i,:) = particles(i).getBotPos();
            end
            %particles generated outside map remade inside map
            if particles(i).insideMap() == 0
               particles(i).randomPose(0); 
            end
        end

        %randomise some particles to prevent incorrect convergence
        for i = 1:30
            particles(i) = BotSim(modifiedMap);
            particles(randi(num)).randomPose(0);
        end

        for i =1:num
            if particles(i).insideMap() == 0
                    particles(i).randomPose(0); 
            end
        end

        
        mean_points = mean(points);
        actual = robot.getBotPos();
        
        %% Write code to check for convergence  

        for i = 1:NUMBER_OF_SCANS
            allavg(i,1) = sum(abs(scan(i,:)))/num;
        end

        convdiff = mean(sum(abs(allavg - botscan)));

        numturns=numturns+1;
        angturned=numturns*0.8;
        
        s_deviation = std(points);
        
        
        if(s_deviation(1) < STD_THRESHOLD && s_deviation(2) < STD_THRESHOLD)
            converged = 1;
            finalpos=0;
            finalang=0;
            ascendingdiff=sort(sumdiff);
            diffcutoff=ascendingdiff(1,round(abs(num/3)));
            for i = 1:num
                if sumdiff(1,i) < diffcutoff
                    finalpos=finalpos + particles(i).getBotPos();
                    finalang=finalang + particles(i).getBotAng();
                    angles(1,i) = particles(i).getBotAng();
                end
            end 
            finalpos=(finalpos/(num/3));
            finalang=(finalang/(num/3));
            finalang=finalang+0.4;
            if (finalang > (2*pi)) && (finalang < (4*pi))
                finalang=finalang-(2*pi);
            elseif (finalang > (4*pi)) && (finalang < (6*pi))
                finalang=finalang-(4*pi);
            elseif (finalang > (6*pi)) && (finalang < (8*pi))
                finalang=finalang-(6*pi);
            end
        end
        
        %% Write code to decide how to move next
        resetcount=resetcount+1;
        if resetcount > 12
            for i = 1:num
                particles(i) = BotSim(modifiedMap);
                particles(i).randomPose(0);
                resetcount = 0;
            end
        end
        for i=1:num
            if particles(i).insideMap() == 0
               particles(i).randomPose(0); 
            end
        end

        if converged == 0
            turn = 2*pi /7;
            rotate_robot(turn);
            robot.turn(turn); %turn the real robot.  
            for i =1:num %for all the particles. 
                particles(i).turn(turn); %turn the particle in the same way as the real robot
            end
        end


        %% Drawing
    %     only draw if you are in debug mode or it will be slow during marking
        if robot.debug()
            hold off; %the drawMap() function will clear the drawing when hold is off
            robot.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
            robot.drawBot(30,'g'); %draw robot with line length 30 and green
            for i =1:num
                particles(i).drawBot(3); %draw particle with line length 3 and default color
            end
            drawnow;
        end
    end
     
    %robot.getBotPos()
    finalpos
    finalang
    
    COM_CloseNXT(h)
end



