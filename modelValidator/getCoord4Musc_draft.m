function muscleCoordinates = getCoord4Musc_draft(myModel,state,muscleName)
% Muscle Coordinate finder
%   Find the coordinate's that each muscle crosses. This is done by
%   examining the moment arm contribution of the muscle across all
%   coordinates. A muscle will contribute to any coodinate when the moment
%   arm is non-zero.

import org.opensim.modeling.*      % Import OpenSim Libraries


nCoord = myModel.getCoordinateSet().getSize();
% get the muscleCoordinates type buy getting the concrete Class Name
myForce = myModel.getMuscles().get(muscleName);

% get a reference to the concrete muscle class in the model
muscleType = char(myForce.getConcreteClassName);
eval(['myMuscle =' muscleType '.safeDownCast(myForce);'])

% get a fresh matrix to dump coordinate values into 
momentArm_aCoord =[];

% iterate through coordinates, finding non-zero moment arm's
for k = 0 : nCoord -1
    % get a reference to a coordinate
    aCoord = myModel.getCoordinateSet.get(k);
    % compute the moment arm of the muscle for that coordinate given
    % the state. 
    momentArm_aCoord(k+1) = myMuscle.computeMomentArm(state,aCoord);
end

% round the numbers. This is needed because at some coordinates there
% are moments generated at the e-18 level. This is most likely
% numerical error. So to deal with this I round to 4 decimal points. 
x = round((momentArm_aCoord*1000))/1000;
% Find the coordinate index's that are non-zero
muscCoord = find(x ~= 0)-1;

% Cycle through each available coordinate and save its range values.
% These will get used later to run calculate muscle force and each
% coordinate value. 
for u = 1 : length(muscCoord)
    % Get a reference to the coordinate
    aCoord = myModel.getCoordinateSet.get(muscCoord(u));
    % Create an arrary of radian value's for the range
    coordRange = (aCoord.getRangeMin:0.01:aCoord.getRangeMax)';
    % add the coordinate's and their range values to the structure
    eval(['muscleCoordinates.' char(myModel.getCoordinateSet.get(muscCoord(u))) '.coordValue = [coordRange];' ])
end
    


end

