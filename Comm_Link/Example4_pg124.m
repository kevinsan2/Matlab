% Doc. No. MAL-4706-3A
% - 114 - Rev: A
% Setting up a SECTOR SCAN movement
% ****************************************************************
% *** WARNING *** * Be sure to adapt the loaded parameters to your
% system: * - axis selection, according to the connected axes *
% - position targets, according to the limit switches * Assure
% that the configuration parameters are set correctly *
% ****************************************************************
% The TTL Increment Pulses may be seen on a oscilloscope connected
% to J1 connector on the rear panel
clear all;clc;
sport = initializeSerialPort;
fprintf(sport, 'H<' );		 % Turn CONTROLLER to 'STAND-BY' State
fprintf(sport, 'L<' );       % Turn CONTROLLER to 'LOAD' State
fprintf(sport, 'Aa3<');      % Select scan axis No:2
fprintf(sport, 'Az3<');      % Select step axis No:0
fprintf(sport, 'H<');
pause(0.5);
fprintf(sport, 'G<');
pause(0.5);
fprintf(sport, 'H<');
pause(0.5);
fprintf(sport, 'L<');
fprintf(sport, 'Pas03544<'); % Set scan starting point:33.44 deg
fprintf(sport, 'Pet21212<'); % Set scan ending point: 212.12 deg
fprintf(sport, 'Daf<');      % Set number of scans: 7
fprintf(sport, 'Der<');      % Increments Gap: .05 deg
fprintf(sport, 'J00007<');		 % Set number of scans: 7
fprintf(sport, 'I00050<');      % Increments Gap: .05 deg
fprintf(sport, 'Fz<');  % Disable GPIB Increments
fprintf(sport, 'Va00500<');  % Set scan velocity: half speed
fprintf(sport, 'MN<');        % Set the motion mode : Raster_B (could be A)
fprintf(sport, 'H<');         % Return to “STAND-BY”
pause(.5)                    % Wait 10 msec between ‘H’ & ‘G’
fprintf(sport, 'G<');         % Turn CONTROLLER to “RUN”: Start motion
for i = 1:10
    response{i,:} = sendAndReceiveX1X2X3(sport, {'X3<'});
end
%%
count = 1;
for i = 1:length(response)
    if length(response{i,:}{1,1}) > 4
        dataResponse{count,:} = textscan(response{i,:}{1,1},'%2c%d%c%d%2c%d%c%d');
        count = count + 1;
    end
end






