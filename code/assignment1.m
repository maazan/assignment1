% The first task of this assaignment is to simulate electrons inside
% a finite semiconductor region. The region was set to be 200nm x 100nm. 

clearvars
clearvars -GLOBAL
close all
format shorte 

set(0, 'DefaultFigureWindowStyle', 'docked')
global C

% First, we define all the constants:

C.q_0 = 1.60217653e-19;             % electron charge
C.hb = 1.054571596e-34;             % Dirac constant
C.h = C.hb * 2 * pi;                % Planck constant
C.m_0 = 9.10938215e-31;             % rest electron mass
C.m = 0.26*C.m_0;                     % effective electron mass
C.kb = 1.3806504e-23;               % Boltzmann constant
C.eps_0 = 8.854187817e-12;          % vacuum permittivity
C.mu_0 = 1.2566370614e-6;           % vacuum permeability
C.c = 299792458;                    % speed of light
C.g = 9.80665;                      %metres (32.1740 ft) per s²
C.am = 1.66053892e-27;




%-----------  Initilize ------------

% The temperture is set to 300K, and the electron are given a constant
% thermal velocity Vth. 
%Each particle is given a random direction and starting position. 

T = 300;
x_size = 200e-9;
y_size = 100e-9;

No_particles = 1000; 
dt = 1e-14;
timesteps = 200;

vth = sqrt((2*T*C.kb)/(C.m));

angle = randi([1 90],1,No_particles);
randx = rand(1,No_particles);
randy = rand(1,No_particles);

x = randx * x_size;
y = randy * y_size;
Vx = cosd(angle) * vth * dt; 
Vy = sind(angle) * vth * dt;

figure
xlabel('X')
ylabel('Y')
title('Electrons')
hold on

%-----------------------------------

%---------------  Loop -------------

%In every iteration, the location of the particles is updated based on the
%velocity - wich is constant. the boundry conditions were set to elastic
%reflection on the top and botom boundries and a loop around the sides. 

for i = 1:timesteps 
    
    x_out_right = (x + Vx) > x_size; 
    x(x_out_right) = x(x_out_right) + Vx(x_out_right) - x_size;

    x_out_left =  (x + Vx) < 0;
    x(x_out_left) = x(x_out_left) + Vx(x_out_left) + x_size;

    x_in= ~(x_out_left|x_out_right);
    x(x_in) = x(x_in) + Vx(x_in);
    
    y_out = ((y + Vx) < 0 | (y +Vx) > y_size);
    y_in = ~y_out;
    
    Vy(y_out) = Vy(y_out) *-1; 
    y = y + Vy;
    
    x_trace(i,:) = x;
    y_trace(i,:) = y;
    
    
    
   %Movie Time! this piece of code is used to simulate the electrons moving
   %around in the semiconductor. The location is updated every 500us.
   
  
   
%    for j = 1:10:No_particles
%        plot(x_trace(:,j),y_trace(:,j),'-')
%    end
%         pause(0.0005)
    
end

%------------- Plot -----------------

% The following figure shows the final plot of the electron paths. 
for i = 1:No_particles
   plot(x_trace(:,i),y_trace(:,i),'-')
   xlim([0 x_size])
   ylim([0 y_size])
   xlabel('X')
   ylabel('Y')
   title('Electrons')
   hold on
end


