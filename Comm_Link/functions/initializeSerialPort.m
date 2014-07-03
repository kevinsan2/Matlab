function sport = initializeSerialPort
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
sport.Timeout = .5;

% =========================================================================
% Method #1 uses fgets to read controller response. Since the Prologix
% controller always terminates internal query responses with CR/LF which is
% same as the currently specified serial port terminator, this method will
% work fine.
% =========================================================================

% Open virtual serial port
fopen(sport);
fprintf(sport, '++mode 1');
fprintf(sport, '++addr 15');
fprintf(sport, '++auto 1');
fprintf(sport, '++clr');
