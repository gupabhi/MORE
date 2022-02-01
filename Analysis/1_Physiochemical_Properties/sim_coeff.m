% WARNING: Make sure you have added the file containing simcoeff.py into system path
% If not, add using insert(py.sys.path, int32(0), <path_to_folder>);
%
% Calls python module simcoeff which calculates the tanimoto and dice coefficients
function [tanimoto, dice] = sim_coeff(smile1, smile2)

% reload the script
py.reload(py.importlib.import_module('simcoeff')); 

% import and use the module
sim = py.importlib.import_module('simcoeff');
smile_list = py.list({smile1, smile2});
t = sim.get_coefficients(smile_list);
tanimoto = t{1}; dice = t{2};

end




