function [out_map] = reduce_map( botRadius, map)

    disp('REDUCING MAP BY ' + botRadius);
    num_of_vertices = size(map,1);
    buf1 = zeros(num_of_vertices, 1);
    buf2 = zeros(num_of_vertices, 2);
    edges = buf1; 
    ang = buf1;
    v_1 = buf2;
    v_2 = buf2;
    unit = buf2;

    for v = 0:num_of_vertices-1   
        if v == num_of_vertices-1
            m1 = map(1,1) - map(v+1,1);
            m2 = map(1,2) + map(v+1,2);
            edges(v+1) = m1*m2;
        else
            m1 = map(v+2,1) - map(v+1,1);
            m2 = map(v+2,2) + map(v+1,2);
            edges(v+1) = m1*m2;
        end
    end

    for v = 1:num_of_vertices
        current = map(v,:);
        
        if v == 1
            prev_v = map(num_of_vertices, :);
        else
            prev_v = map(v-1,:);
        end
        
        if v == num_of_vertices
            next_v = map(1, :);
        else
            next_v = map(v+1, :);
        end
        
        v_1(v,:) = next_v - current; 
        v_2(v,:) = prev_v - current;
        unit(v,:) = v_1(v,:)/norm(v_1(v,:));
        
        x_1 = v_1(v,1);
        y_1 = v_1(v,2);
        
        x_2 = v_2(v,1);
        y_2 = v_2(v,2);
        
        ang1 = x_1*y_2-x_2*y_1;
        ang2 = x_1*x_2+y_1*y_2;
        ang(v) = 180* mod(atan2(ang1,ang2),2*pi)/pi;
    end

    offset = buf1;
    new_angle = ang./2; 
    
    new_v = buf2;
    out_map = buf2;
    
    
    for v = 1:num_of_vertices
        
        
        if (ang(v) > 270)
            rot = [cosd(new_angle(v)), sind(new_angle(v)); -sind(new_angle(v)), cosd(new_angle(v))];
            offset(v) = -(botRadius/sind(new_angle(v)-180));
     
            new_v(v,:) =  unit(v,:) * offset(v) * rot ;
            out_map(v,:) = new_v(v,:) + map(v,:);
            
        elseif (ang(v) > 180 && ang(v) <= 270)
            rot = [cosd(new_angle(v)), sind(new_angle(v)); -sind(new_angle(v)), cosd(new_angle(v))];
            offset(v) = -(botRadius/sind(new_angle(v)-180));
            
            new_v(v,:) =  unit(v,:) * offset(v) * rot ;
            out_map(v,:) = new_v(v,:) + map(v,:) ;
            
        elseif (ang(v) <= 180)
            rot = [cosd(new_angle(v)), sind(new_angle(v)); -sind(new_angle(v)), cosd(new_angle(v))];
            offset(v) = botRadius/sind(new_angle(v));
            
            new_v(v,:) =  unit(v,:)*offset(v) * rot ;
            out_map(v,:) = new_v(v,:)+ map(v,:);
        end
        
    end
end
%RETURN