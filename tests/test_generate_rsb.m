function tests = test_generate_rsb
% Resource-block demand bounds from generateRSB.
% From the repo root: matlab -batch "runtests('tests')"
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename("fullpath")));
addpath(root);
testCase.TestData.root = root;
end

function test_rsb_shape_and_bounds(testCase)
rng(1);
nVehicle = [1 2 5 10 50];
[T, B] = generateRSB(nVehicle, 1, 1, 1e9, 4);
verifySize(testCase, T, [4 1]);
verifySize(testCase, B, [4 1]);
verifyGreaterThanOrEqual(testCase, T, 0.1);
verifyLessThanOrEqual(testCase, T, 0.9);
verifyGreaterThanOrEqual(testCase, B, 1e8);
verifyLessThan(testCase, B, 9e8);
end

function test_resource_grid_constants(testCase)
DeltaT = 0.16e-6;
DeltaB = 25e3;
Ttot = 1;
Btot = 1e9;
RB = round([Ttot Btot] ./ [DeltaT DeltaB]);
verifyEqual(testCase, RB, [6250000 40000]);
end
