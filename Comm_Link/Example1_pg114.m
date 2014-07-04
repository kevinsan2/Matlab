% Doc. No. MAL-4706-3A
% - 114 - Rev: A
% Setting up a Track to Target movement Example No:1
%
% ****************************************************************
% *** WARNING *** * Be sure to adapt the loaded parameters to your
% system: * - axis selection, according to the connected axes *
% - position targets, according to the limit switches * Assure
% that the configuration parameters are set correctly *
% ****************************************************************
sport = initializeSerialPort;							
fprintf(sport, 'H<' );		% Turn CONTROLLER to 'STAND-BY' State 	
fprintf(sport, 'L<' );       % Turn CONTROLLER to 'LOAD' State
fprintf(sport, 'Aa1<');     % Select first rotation axis No:1
pause(.1);
fprintf(sport, 'Ae0<');     % Select second rotation axis No:3
fprintf(sport, 'Pat00000<');% Set target of first axis :50.00 deg  
% fprintf(sport, 'Pet00000<');% Set target of first axis:351.8 deg ELEVATION COMMAND
fprintf(sport, 'Dad<');     % Set direction of first axis: forward  
% fprintf(sport, 'Def<');     % Set direction of second axis: reverse
fprintf(sport, 'Va00870<'); % Set travel velocity of axis a: 87.6% 
% fprintf(sport, 'Ve00564<'); % Set travel velocity of axis e: 56.4% 
fprintf(sport, 'MT');       % Set the motion mode : Track
fprintf(sport, 'H');        % Return to 'STAND-BY'
pause(.5)                   % Wait 50 msec between 'H' & 'G'
disp('run')
fprintf(sport, 'G<');        % Turn CONTROLLER to 'RUN': Start motion
% commands with e are for elevation
pause(.5)
fprintf(sport, 'H<');
fprintf(sport, 'S<');
fprintf(sport, 'X1<')
fprintf(sport, '++spool')
fgets(sport)
