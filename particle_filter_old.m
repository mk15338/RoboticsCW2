function [predicted_location, predicted_angle] = particle_filter(robot, map)   
 
NUMBER_OF_SCANS = 20;
NUMBER_OF_PARTICLES = max(max(map)-min(map)) * 5;
MAX_NUMBER_OF_ITERATIONS = 300;
STD_THRESHOLD = 5;
BEST_PARTICLE_DISTANCE_THRESHOLD = 4;
RANDOM_POSE_FOR_PARTICLES = 0.05;
MOTION_NOISE = 0.1;
TURNING_NOISE = 0.05;
OFFSET_LOCATION = 1;

robot.setScanConfig(robot.generateScanConfig(NUMBER_OF_SCANS));

%Initialize and set up randomly posed particles inside the map
particles(NUMBER_OF_PARTICLES,1) = BotSim;
for i = 1:NUMBER_OF_PARTICLES
    particles(i) = BotSim(map);
    particles(i).randomPose(0);
    particles(i).setMotionNoise(MOTION_NOISE);
    particles(i).setTurningNoise(TURNING_NOISE);
    particles(i).setScanConfig(particles(i).generateScanConfig(NUMBER_OF_SCANS));
end

        
converged = 0;
n = 0;
best_particle = robot;

while(converged ~= 1 && n < MAX_NUMBER_OF_ITERATIONS)
    
    n = n + 1;
    bot_scan=robot.ultraScan();
    % Write code for updating your particles scans and scoring particles 
    
    
    var = 5;
    
    for i = 1:NUMBER_OF_PARTICLES
        particle_scan = particles(i).ultraScan();
        particle_weights(i,:) = [i, 0];
        max_weight = 0;
        lowest_difference = intmax('int8');
        for scan = 1:NUMBER_OF_SCANS
            current_scan = circshift(particle_scan, scan);
            %var = std(current_scan)^2;
            w = (1/sqrt(2*pi*var))*exp(-(sum((current_scan-bot_scan).^2)/(2*var)));
            if( w > max_weight )
                max_weight = w;
                best_ang = getBotAng(particles(i)) - ((scan-1) * 2 * pi / NUMBER_OF_SCANS);
            end
            if( (current_scan-bot_scan).^2 < lowest_difference )
                best_particle = particles(i);
            end
        end
        particle_weights(i,:) = [i, max_weight];
        particles(i).setBotAng(mod(best_ang, 2*pi));
    end
    

    
    normalized_particle_weights(:, 2) = particle_weights(:,2)/sum(particle_weights(:,2));

    %create roulette wheel
    summative = 0;
    for i = 1:NUMBER_OF_PARTICLES
        roulette_wheel(i) = normalized_particle_weights(i, 2) + summative;
        summative = summative + normalized_particle_weights(i, 2);
    end
    
    size(roulette_wheel)
    
    
    %% Write code for resampling your particles
    new_particles = particles;
    for i = 1:NUMBER_OF_PARTICLES
        rand_number = rand();
        index = -1;
        for j = 1:NUMBER_OF_PARTICLES
            if( roulette_wheel(j) > rand_number)
                index = j;
                break;
            end
        end
        new_particles(i).setBotPos(particles(index).getBotPos() + [-OFFSET_LOCATION+rand()*2*OFFSET_LOCATION, -OFFSET_LOCATION+rand()*2*OFFSET_LOCATION]);
        new_particles(i).setBotAng(particles(index).getBotAng() + (-(2*pi / 32) + (rand(1) * (2*pi / 32) * 2)));
        points(i,:) = new_particles(i).getBotPos();
        angles(i,:) = new_particles(i).getBotAng();
    end
    particles = new_particles;
    
    %% Write code to check for convergence   
	s_deviation = std(points);
    if(s_deviation(1) < STD_THRESHOLD && s_deviation(2) < STD_THRESHOLD)
        
        average_particle_pos = mean(points);
        average_particle_ang = mean(angles);
        if(sqrt(sum((average_particle_pos - best_particle.getBotPos()) .^ 2)) < BEST_PARTICLE_DISTANCE_THRESHOLD)
            converged = 1;
        end 
        
        predicted_location = average_particle_pos;
        predicted_angle = average_particle_ang;  
              
        if(converged)
            particle_orientation = BotSim(map);
            particle_orientation.setBotPos(predicted_location);
            particle_orientation.setBotAng(predicted_angle);
            particle_orientation.setScanConfig(particles(i).generateScanConfig(NUMBER_OF_SCANS));
            
            particle_scan = particle_orientation.ultraScan();
            max_weight = 0;
            for scan = 1:100
                current_scan = circshift(particle_scan, scan);
                var = std(current_scan)^2;
                w = (1/sqrt(2*pi*var))*exp(-(sum((current_scan-bot_scan).^2)/(2*var)));
                if( w > max_weight )
                    max_weight = w;
                    best_ang = getBotAng(particle_orientation) - ((scan-1) * 2 * pi / NUMBER_OF_SCANS);
                end
            end
            
            predicted_angle = best_ang;
            return 
        end
        
       
    end
      
    %% Write code to decide how to move next
    if(converged ~= 1)       
     
        turn = -(2*pi / 32) + (rand(1) * (2*pi / 32) * 2);
        move = 5 * rand();
               
        forward_scans = [];
        for i = NUMBER_OF_SCANS : NUMBER_OF_SCANS
           forward_scans(end + 1) = bot_scan(i);
        end
        for i = 1:floor(NUMBER_OF_SCANS/8)
            forward_scans(end + 1) = bot_scan(i);
        end
       
        left_scan = bot_scan(floor(NUMBER_OF_SCANS/4) + 1);
        right_scan = bot_scan(floor(NUMBER_OF_SCANS/4 * 3) + 1);
        
        move_forward = true;
        for i=1: length(forward_scans)
            if(forward_scans(i) < 10)
                move_forward = false;
            end
        end
        
        if(~move_forward)
            if(left_scan >= right_scan)
                turn = turn + (2*pi / 8);
            else
                turn = turn + -(2*pi / 8);
            end
        end

           
        robot.turn(turn);
        robot.move(move);    
        
        %reverses bot if he does leave the map.
        inside_map = robot.insideMap();
        while (~inside_map)
            robot.move(-move);
            for i = 1:NUMBER_OF_PARTICLES
                particles(i).move(-move);
            end
            inside_map = robot.insideMap();
        end
 
        
        for i = 1:NUMBER_OF_PARTICLES
            particles(i).turn(turn);
            particles(i).move(move);
            pos = particles(i).getBotPos();
            while (~particles(i).pointInsideMap(pos))
                particles(i).setBotPos(best_particle.getBotPos());
                pos = particles(i).getBotPos();
            end
            if (rand() < RANDOM_POSE_FOR_PARTICLES)
                particles(i).randomPose(0);
            end
        end
        
    end
    
    
    if robot.debug()
        hold off; %the drawMap() function will clear the drawing when hold is off
        robot.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
        robot.drawBot(20,'g'); %draw robot with line length 30 and green
        for i = 1:NUMBER_OF_PARTICLES
            particles(i).drawBot(1); %draw particle with line length 3 and default color
        end
        drawnow;    
    end
    
    
end

if(~converged)
   error('Did not converge');
end

%end
%MOVEMENT - bot goes forward and curves away from corners.
