% Καθορισμός των παραμέτρων του φίλτρου
fc = 1100;  % Συχνότητα αποκοπής σε Hz
fs = 14000; % Συχνότητα δειγματοληψίας σε Hz
order = 2; % Τάξη του φίλτρου

% Υπολογισμός κανονικοποιημένης συχνότητας αποκοπής
Wn = fc / (fs / 2);

% Σχεδιασμός του IIR High-Pass φίλτρου Butterworth
[b, a] = butter(order, Wn, 'high');

% Προβολή των συντελεστών του φίλτρου
disp('Συντελεστές b (Numerator):');
disp(b);
disp('Συντελεστές a (Denominator):');
disp(a);

% Κανονικοποίηση συντελεστών σε Q15
b_q15 = round(b * 2^15);
a_q15 = round(a * 2^15);

% Προβολή των κανονικοποιημένων συντελεστών
disp('Συντελεστές b (Numerator) σε Q15:');
disp(b_q15);
disp('Συντελεστές a (Denominator) σε Q15:');
disp(a_q15);

% Απόκριση συχνότητας του φίλτρου
[H, f] = freqz(b, a, 1024, fs);

% Σχεδίαση της απόκρισης συχνότητας
figure;
plot(f, 20*log10(abs(H)));
title('Απόκριση Συχνότητας του IIR High-Pass Φίλτρου');
xlabel('Συχνότητα (Hz)');
ylabel('Κέρδος (dB)');
grid on;

% Μονάδα χρόνου
n = 0:(1/fs):0.05;
% Κύρια συχνότητα
f1 = 200;
amplitude1 = 50;
x1 = round(amplitude1 * sin(2 * pi * f1 * n));
% Θόρυβος
f2 = 1500;
amplitude2 = 5;
x2 = round(amplitude2 * sin(2 * pi * f2 * n));
% Συνολικό σήμα
x = x1 + x2;
stem(n, x); axis([0 n(length(n)) -127 127]);
% Αποθήκευση τιμών σε αρχείο
fp = fopen('datain.dat','w');
for k = 1:length(x)
 fprintf(fp, "%d\n", x(k));
end
fclose(fp);

