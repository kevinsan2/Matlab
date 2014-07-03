% =========================================================================
% Sample MATLAB program to query HP54201A oscilloscope using Prologix
% GPIB-USB Controller 4.2.
%
% HP54201A is configured as TALKER/LISTENER and GPIB address 5.
%
% Output will be as follows:
%
% Prologix GPIB-USB Controller version 5.0
% "HP54201A"
% "2738A02659"
% =========================================================================
clearvars;clc;delete(instrfind);
% Specify the virtual serial port created by USB driver. Other serial port
% parameters don't matter
% sport = serial('COM4');
sport = serial('/dev/tty.usbserial-PXHD6DXX');
% Prologix Controller 4.2 requires CR as command terminator, LF is
% optional. The controller terminates internal query responses with CR and
% LF. Responses from the instrument are passed through as is. (See Prologix
% Controller Manual)
sport.Terminator = 'CR/LF';

% Reduce timeout to 0.5 second (default is 10 seconds)
sport.Timeout = .1;

% =========================================================================
% Method #1 uses fgets to read controller response. Since the Prologix
% controller always terminates internal query responses with CR/LF which is
% same as the currently specified serial port terminator, this method will
% work fine.
% =========================================================================

% Open virtual serial port
fopen(sport);
fprintf(sport, '++clr');
pause(2);

% Send Prologix Controller query version command
fprintf(sport, '++ver');

% Read and display response
ver = fgets(sport);
disp(ver);
% Close port

% =========================================================================
% Method #2 uses fread to read instrument response. In this case we read
% until the specified number of bytes are received or until timeout occurs.
% If the specified number of bytes are not received before timeout MATLAB
% will generate a "not enough data read before timeout" warning.
% =========================================================================

% Suppress "not enough data read before timeout" warning
warning('off','MATLAB:serial:fgets:unsuccessfulRead');
% Configure as Controller (++mode 1), instrument address 5, and with
% read-after-write (++auto 1) enabled
fprintf(sport, '++mode 1');
fprintf(sport, '++addr 15');
fprintf(sport, '++auto 1');
% fprintf(sport, 'FT1<');
% pause(5);
% fprintf(sport, '++spoll');
% response = fgets(sport);
% response = str2num(response);
% if response == 95
%     disp('Self-test failed');
% elseif response == 96
%     disp('Self-test passed');
% end
%% Commands
%
readPredefinedBoundaryPosition = {'Pas<', 'Pab<', 'Pes<',...
    'Peb<', 'Pat<', 'Pet<'};
readPredefinedVelocity = {'Va<', 'Ve<', 'Vz<'};
readPredefinedDirection = {'Da<', 'De<'};
xCommands = {'X1<','X2<','X3<'};
loadBoundaryPosition = {'Pas', 'Pab', 'Pes',...
    'Peb', 'Pat', 'Pet'};
sendAndReceive(sport,{'Pas01839<', 'Pab34854<', 'Pes00042<',...
    'Peb10200<', 'Pat27984<', 'Pet04201<'},'l');
sendAndReceive(sport, {'Aa2', 'Ae2'},'l')
% Send Commands
% %
pb1 = sendAndReceive(sport,readPredefinedBoundaryPosition);
vb1 = sendAndReceive(sport,readPredefinedVelocity);
db1 = sendAndReceive(sport,readPredefinedDirection);
xc1 = sendAndReceive(sport,xCommands);
%% Direct Mode
fprintf(sport,'MU');
fprintf(sport, 'L<');

%% Clear devices
fprintf(sport, '++clr');
fclose(sport);
delete(instrfind);
