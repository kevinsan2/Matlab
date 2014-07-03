function response = sendAndReceive( serialPort,commands, state )
if nargin < 3
    state = 'S';
end
if state == 's' | 'S<' | 's<';
    state = 'S';
end
if state == 'l' | 'L<' | 'L<';
    state = 'L';
end
fprintf(serialPort, 'H<')
fprintf(serialPort, [state])
for p = 1:length(commands)
    fprintf(serialPort, commands{p});
    pause(.1);
    fprintf(serialPort, '++spoll');
    disp(['Command sent: ' commands{p}]);
    while serialPort.BytesAvailable ~= 0
        response{p} = fgets(serialPort);
        % Display id
        displayEventMessage(response{p})
    end
end
if state == 'L'
    fprintf(serialPort, 'G<');
    pause(1);
end
fprintf(serialPort, 'H<')
end

