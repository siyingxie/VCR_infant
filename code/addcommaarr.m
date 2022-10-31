function B = addcommaarr(A)
% Add comma in an array

B = strings(size(A));
for i = 1:size(A,1)
    for j = 1:size(A,2)
        B(i,j) = addComma(A(i,j));
    end
end
end

function numOut = addComma(numIn)
   jf=java.text.DecimalFormat; % comma for thousands, three decimal places
   numOut= char(jf.format(numIn)); % omit "char" if you want a string out
end

