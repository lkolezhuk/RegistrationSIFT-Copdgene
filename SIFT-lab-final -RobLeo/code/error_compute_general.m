function [error] = error_compute_general(features, matches, H)
%work with a cell total_point that it is a matrix whit all the trasformed
%point for all the image


result_point_direct = [];
for n=1:size(features, 1)
        x = [features(n,:), 1];
        y = [matches(n,:),1];
        x_temp = H * x';
        y_temp = inv(H) * y';
        result_point_direct(n,:) = x_temp(1:2);
        result_point_inverse(n,:) = y_temp(1:2);
end

error = immse(result_point_direct, matches) + immse(result_point_inverse, features);

end

   