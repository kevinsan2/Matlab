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
sport = serial('/dev/cu.usbserial-PXHD6DXX');

% Prologix Controller 4.2 requires CR as command terminator, LF is
% optional. The controller terminates internal query responses with CR and
% LF. Responses from the instrument are passed through as is. (See Prologix
% Controller Manual)
sport.Terminator = 'CR/LF';

% Reduce timeout to 0.5 second (default is 10 seconds)
sport.Timeout = 4;

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
% fclose(sport);
% =========================================================================
% Method #2 uses fread to read instrument response. In this case we read
% until the specified number of bytes are received or until timeout occurs.
% If the specified number of bytes are not received before timeout MATLAB
% will generate a "not enough data read before timeout" warning.
% =========================================================================

% Suppress "not enough data read before timeout" warning
warning('off','MATLAB:serial:fread:unsuccessfulRead');

% fopen(sport);

% Configure as Controller (++mode 1), instrument address 5, and with
% read-after-write (++auto 1) enabled
fprintf(sport, '++mode 1');
fprintf(sport, '++addr 15');
fprintf(sport, '++auto 1');
% Send id query command to HP54201A
fprintf(sport, 'IDN?')
id = fread(sport,60);
% Read 20 bytes or until timeout expires
% fgets(sport);
% fclose(sport);
% 
% =========================================================================
% Method #3 also uses fread to read instrument response. However, the
% read-after-write feature is disabled and an explicit ++read command is
% used. See Prologix Controller Manual for when to use the ++read command.
% =========================================================================
% fopen(sport);

% Turn off read-after-write feature
fprintf(sport, '++auto 0');

% Send serial number query command
fprintf(sport, 'OPT?');

% Tell Prologix controller to read until EOI is asserted by instrument
fprintf(sport, '++read eoi');

% Read 20 bytes or until timeout expires
ser = fgets(sport);

% fclose(sport);

%% 

% Specify the virtual serial port created by USB driver. Other serial port
% parameters don't matter
% sport = serial('/dev/cu.usbserial-PXHD6DXX');

% Prologix Controller 4.2 requires CR as command terminator, LF is
% optional. The controller terminates internal query responses with CR and
% LF. Responses from the instrument are passed through as is. (See Prologix
% Controller Manual)
% sport.Terminator = 'CR/LF';
% %set(sport,'BaudRate',9600,'Terminator','LF','Parity','None');
% % Reduce timeout to 0.5 second (default is 10 seconds)
% sport.Timeout = 10;
% 
% % Open virtual serial port. If a port is not available, use fclose(instrfind) and try again or exit
% % matlab and plug the usb device out and in before starting matlab again.
% fopen(sport);



% Configure as Controller (++mode 1), instrument address 5, and with
% read-after-write (++auto 1) enabled
fprintf(sport, '++mode 1');
fprintf(sport, '++addr 15');
fprintf(sport, '++auto 1');
% % Send id query command to HP54201A
% fprintf(sport, 'FT1<') 
% id = fread(sport,60);
% fclose(sport)
%% This command returns the version string of the Prologix GPIB-ETHERNET controller. 

% Send Prologix Controller query version command
fprintf(sport, '++ver');

% Read and display response
ver = fgets(sport);
disp(ver);


%% FT1 < TEST command; Intiiate a CONTROLLER self-test. 
% clc
% fprintf(sport, 'FT1<');

fprintf(sport, 'X1<');

% Read and display response
ver = fscanf(sport);
% disp(ver);

%% S READ command; Read parameters (Previously lodaded by load)
% fprintf(sport, 'H<')
% fprintf(sport, 'S<');

% Read and display response
% ver = fgets(sport);
% disp(ver);

%% -> S 

fprintf(sport, 'X1<')


% readasync(sport)
% sport.ValuesReceived
% 
% out = fscanf(sport)

ver = fgets(sport);
sport.ValuesReceived
disp(ver)

% ver = fread(sport)
% disp(ver)

% ver = fgetl(sport);
% disp(ver);

% pause(.5);
% A = fscanf(sport)



%fread, fscanf, fgets...
%%
fprintf(sport, 'H<')
fprintf(sport, 'L<')
fprintf(sport, 'Aa1<')
fprintf(sport, 'Pat01234<')
fprintf(sport, 'Dad<')
fprintf(sport, 'Va00376<')
fprintf(sport, 'MT<')

pause(0.1)

fprintf(sport, 'G<')


%% print test
fprintf(sport,'RS232?')
out = fscanf(sport)


%% X1< 
fprintf(sport, 'X1<');

ver = fgets(sport);
disp(ver);

%% Go into run state

fprintf(sport, 'S');

ver = fgets(sport);
disp(ver);


%% close

fclose(instrfind)
delete(instrfind)
clear sport
clear all

