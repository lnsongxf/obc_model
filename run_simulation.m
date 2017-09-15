clear; close all;

if exist('results_irf')~=7
    mkdir('results_irf')
end
if exist('results_sim')~=7
    mkdir('results_sim')
end

%% IRF simulations

cd('model')
   
try 
    dynareOBC rbc_psi slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=-5000 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/rbc_KQ5pc.mat')
catch
   disp('****------- Error solving IRF to negative KQ shock (RBC model) -------****');
end
clear;
try 
    dynareOBC gkq_psi slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=-5000 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/gkq_KQ5pc.mat')
catch
   disp('****------- Error solving IRF to negative KQ shock (GKQ model) -------****');
end
clear;
try 
    dynareOBC obc_psi slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=-5000 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/obc_KQ5pc.mat')
catch
   disp('****------- Error solving IRF to negative KQ shock (OBC model) -------****');
end
clear;

try 
    dynareOBC rbc_psi slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=5000 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/rbc_posKQ5pc.mat')
catch
   disp('****------- Error solving IRF to positive KQ shock (RBC model) -------****');
end
clear;
try 
    dynareOBC gkq_psi slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=5000 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/gkq_posKQ5pc.mat')
catch
   disp('****------- Error solving IRF to positive KQ shock (GKQ model) -------****');
end
clear;
try 
    dynareOBC obc_psi slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=5000 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/obc_posKQ5pc.mat')
catch
   disp('****------- Error solving IRF to positive KQ shock (OBC model) -------****');
end
clear;

try 
    dynareOBC rbc_a slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=-1 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/rbc_negA1sd.mat')
catch
   disp('****------- Error solving IRF to negative prod shock (RBC model) -------****');
end
clear;
try 
    dynareOBC gkq_a slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=-1 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/gkq_negA1sd.mat')
catch
   disp('****------- Error solving IRF to negative prod shock (GKQ model) -------****');
end
clear;
try 
    dynareOBC obc_a slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=-1 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/obc_negA1sd.mat')
catch
   disp('****------- Error solving IRF to negative prod shock (OBC model) -------****');
end
clear;

try 
    dynareOBC rbc_a slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=1 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/rbc_A1sd.mat')
catch
   disp('****------- Error solving IRF to positive prod shock (RBC model) -------****');
end
clear;
try 
    dynareOBC gkq_a slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=1 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/gkq_A1sd.mat')
catch
   disp('****------- Error solving IRF to positive prod shock (GKQ model) -------****');
end
clear;
try 
    dynareOBC obc_a slowIRFs NoCubature OrderOverride=2 FirstOrderConditionalCovariance shockscale=1 TimeToEscapeBounds=40 omega=10000 CompileSimulationCode;
    save('../results_irf/obc_A1sd.mat')
catch
   disp('****------- Error solving IRF to positive prod shock (OBC model) -------****');
end
clear;


%% Time-series simulation

clear;

try 
    dynareOBC rbc_sim NoCubature OrderOverride=2 FirstOrderConditionalCovariance TimeToEscapeBounds=60 TimeToReturnToSteadyState=20 omega=10000 CompileSimulationCode Sparse;
    save('../results_sim/rbc.mat')
catch
   disp('****------- Error Error solving simulated time-series (RBC model) -------****');
end
try 
    dynareOBC gkq_sim NoCubature OrderOverride=2 FirstOrderConditionalCovariance TimeToEscapeBounds=60 TimeToReturnToSteadyState=20 omega=10000 CompileSimulationCode Sparse;
    save('../results_sim/gkq.mat')
catch
   disp('****------- Error Error solving simulated time-series (GKQ model) -------****');
end
try 
    dynareOBC obc_sim NoCubature OrderOverride=2 FirstOrderConditionalCovariance TimeToEscapeBounds=60 TimeToReturnToSteadyState=20 omega=10000 CompileSimulationCode Sparse;
    save('../results_sim/obc.mat')
catch
   disp('****------- Error Error solving simulated time-series (OBC model) -------****');
end

%% Clean up

warning('off','all')
delete *_IRF_*
delete *Temp*
delete dynareOBCTemp*
delete *_dynamic.m
delete *_static.m
delete *.jnl
delete *.log
delete *.eps
delete *.pdf
delete *_set_auxiliary_variables.m
delete all_models_results.mat
delete all_models.m
warning('on','all')
cd('../');
clear;

