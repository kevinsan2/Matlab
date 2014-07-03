function response = sendAndReceiveX1X2X3( serialPort,commands )

for p = 1:length(commands)
    fprintf(serialPort, commands{p});
    pause(.5);
    fprintf(serialPort, '++spoll');
    disp(['Command sent: ' commands{p}]);
    pause(0.5);
    while serialPort.BytesAvailable ~= 0
        response{p} = fgets(serialPort);
        % Display id
        displayEventMessage(response{p});
        pause(0.5);
    end
end
end

