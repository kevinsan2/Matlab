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
clearvars;clc;
% Specify the virtual serial port created by USB driver. Other serial port
% parameters don't matter
sport = serial('COM4');

% Prologix Controller 4.2 requires CR as command terminator, LF is
% optional. The controller terminates internal query responses with CR and
% LF. Responses from the instrument are passed through as is. (See Prologix
% Controller Manual)
sport.Terminator = 'CR/LF';

% Reduce timeout to 0.5 second (default is 10 seconds)
sport.Timeout = 0.5;

% =========================================================================
% Method #1 uses fgets to read controller response. Since the Prologix
% controller always terminates internal query responses with CR/LF which is
% same as the currently specified serial port terminator, this method will
% work fine.
% =========================================================================

% Open virtual serial port
fopen(sport);

% Send Prologix Controller query version command
fprintf(sport, '++ver');

% Read and display response
ver = fgets(sport);
disp(ver);

% Close port
fclose(sport);

% =========================================================================
% Method #2 uses fread to read instrument response. In this case we read
% until the specified number of bytes are received or until timeout occurs.
% If the specified number of bytes are not received before timeout MATLAB
% will generate a "not enough data read before timeout" warning.
% =========================================================================

% Suppress "not enough data read before timeout" warning
% warning('off','MATLAB:serial:fgets:unsuccessfulRead');

fopen(sport);

% Configure as Controller (++mode 1), instrument address 5, and with
% read-after-write (++auto 1) enabled
fprintf(sport, '++mode 1');
fprintf(sport, '++addr 15');
fprintf(sport, '++auto 1');

% Send id query command to HP54201A
%%
fprintf(sport, 'X2<');
fprintf(sport, '++spoll');
% Read 20 bytes or until timeout expires
id = fread(sport);

% Display id
disp(sprintf('%c', id));
%%
fclose(sport);

% =========================================================================
% Method #3 also uses fread to read instrument response. However, the
% read-after-write feature is disabled and an explicit ++read command is
% used. See Prologix Controller Manual for when to use the ++read command.
% =========================================================================
% fopen(sport);
% 
% % Turn off read-after-write feature
% fprintf(sport, '++auto 0');
% 
% % Send serial number query command
% fprintf(sport, 'X4<');
% 
% % Tell Prologix controller to read until EOI is asserted by instrument
% fprintf(sport, '++read eoi');
% 
% % Read 20 bytes or until timeout expires
% ser = fgets(sport);
% 
% % Display serial number
% disp(sprintf('%c', ser));
% 
% fclose(sport);
