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
fprintf(sport, 'Dad<');     % Set direction of first axis: forward  
fprintf(sport, 'Va00990<'); % Set travel velocity of axis a: 99% 
fprintf(sport, 'MT');       % Set the motion mode : Track
for i = 1:20
    fprintf(sport, ['Pat' '10' '<']);
    fprintf(sport, 'H<');
    pause(.1)                   % Wait 50 msec between 'H' & 'G'
    fprintf(sport, 'G<');        % Turn CONTROLLER to 'RUN': Start motion
    pause(.1) 
    fprintf(sport, 'H<');
    pause(.1) 
    fprintf(sport, 'L<');
end