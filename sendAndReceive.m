function response = sendAndReceive( serialPort,commands, state )
if nargin < 3
    state = 'S';
end
if state == 's' | 'S<' | 's<';
    state = 'S';
elseif state == 'l' | 'L<' | 'L<';
    state = 'L';
else
    state = '';
end
fprintf(serialPort, 'H<')
fprintf(serialPort, [state])
for p = 1:length(commands)
    fprintf(serialPort, commands{p});
    pause(.5);
    fprintf(serialPort, '++spoll');
    disp(['Command sent: ' commands{p}]);
    pause(0.5);
    while serialPort.BytesAvailable ~= 0
        response{p} = fgets(serialPort);
        % Display id
        displayEventMessage(response{p})
        pause(0.5);
    end
end
if state == 'L'
    fprintf(serialPort, 'G<');
    pause(1);
end
fprintf(serialPort, 'H<')
end

