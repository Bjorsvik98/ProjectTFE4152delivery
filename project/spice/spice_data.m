load('a.csv');

x = a(:,1);
y = a(:,2);
y_2 = a(:,4);



plot(x,y);
plot(x,y_2, 'r');
grid;