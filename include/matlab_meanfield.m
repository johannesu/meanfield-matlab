% Matlab meanfield
% Use this only to compare solutions.
%%
function labelling = matlab_meanfield(unary,image, settings)

num_labels = size(unary,3);

assert(size(unary,1) == size(image,1));
assert(size(unary,2) == size(image,2));


% Define pairwise cost
square = @(x) x.^2;
bilateral_cost = @(x0, y0, x1, y1) ...
	exp( ...
	- ( square(x0-x1) / (2*settings.bilateral_x_stddev) ) ...
	- ( square(y0-y1) / (2*settings.bilateral_y_stddev) ) ...
	- ( square(image(x0,y0,1) - image(x1,y1,1))/ (2*square(settings.bilateral_r_stddev)) ) ...
	- ( square(image(x0,y0,2) - image(x1,y1,2))/ (2*square(settings.bilateral_g_stddev)) ) ...
	- ( square(image(x0,y0,3) - image(x1,y1,3))/ (2*square(settings.bilateral_r_stddev)) ) ...
	);

gaussian_cost = @(x0, y0, x1, y1) ...
	exp( ...
	- ( square(x0-x1)/(2* square(settings.gaussian_x_stddev) ) ) ...
	- ( square(y0-y1)/(2* square(settings.gaussian_y_stddev) ) )...
	);


pairwise = @(x0, y0, x1, y1)	settings.gaussian_weight*gaussian_cost(x0, y0, x1, y1) + ...
	settings.bilateral_weight*bilateral_cost(x0, y0, x1, y1);


% unayr cost is just lookup

% Noramlize.
normalize = @(Q) bsxfun(@rdivide, Q, sum(Q,3));

% Init
Q = normalize(exp(-unary));

% Constant for every iteration


for iteration = 1:settings.iterations
	Qt = Q;
	for label_self = 1:num_labels
		
		% Second part of sum
		pw = zeros(size(unary,1),size(unary,2));
		
		for  label_target = 1:num_labels
			
			% negative potts when labels are the same.
			if (label_self == label_target)
				for x_self = 1:size(unary,1)
					for y_self = 1:size(unary,2)
						for x_target = 1:size(unary,1)
							for y_target = 1:size(unary,2)
								pw(x_self,y_self) = 	pw(x_self,y_self)  ...
									- pairwise(x_self,y_self, x_target, y_target)*Qt(x_target,y_target,label_target);
							end
						end
					end
				end
				
			end
		end
		
		Q(:,:,label_self) = exp(-unary(:,:,label_self) - pw);
	end
	
	Q = normalize(Q);
	
	% Convergence test
	if norm(Q(:)-Qt(:)) < 1e-10
		break;
	end
	
end

[~,labelling] = max(Q,[],3);