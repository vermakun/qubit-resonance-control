% Kunaal Verma
% 2021.04.25
% ECE 560 - Rotational Control of Qubit - Apply H Gate

function Si_P_Hgate(larmor,pulse)

if nargin<2
    pulse = 'I';
end

% Disable console output
sys.output='hush';

% Isotopes
sys.isotopes={'29Si','31P','29Si'};

% Magnetic induction (static field)
sys.magnet=6.0;

% Chemical shifts
inter.zeeman.scalar={0.0 20.0 0.0};

% Scalar couplings
inter.coupling.scalar=cell(3,3);
inter.coupling.scalar{1,2}=256.0; 

% Basis set
bas.formalism='sphten-liouv';
bas.approximation='none';

% Spinach housekeeping
spin_system=create(sys,inter);
spin_system=basis(spin_system,bas);

%%% Initial state (observe 31P isotope)
rho=state(spin_system,'Lz','31P');

% Observable states
coil_x1=(state(spin_system,{'L+'},{1})+state(spin_system,{'L-'},{1}))/2;
coil_x2=(state(spin_system,{'L+'},{2})+state(spin_system,{'L-'},{2}))/2;
coil_y1=(state(spin_system,{'L+'},{1})-state(spin_system,{'L-'},{1}))/2i;
coil_y2=(state(spin_system,{'L+'},{2})-state(spin_system,{'L-'},{2}))/2i;
coil_z1=state(spin_system,{'Lz'},{1});
coil_z2=state(spin_system,{'Lz'},{2});

% Pulse operators
Lp = operator(spin_system,'L+','all');
Lx = (Lp+Lp')/2;
Ly = (Lp-Lp')/2i;

% Hamiltonian
H = hamiltonian(assume(spin_system,'nmr'));

%%% Larmor Driving frequency
H = H+2*pi*larmor*Ly;

%%% Apply control pulses (if requested)
if pulse == 'H'
    rho = step(spin_system,Lx,rho,pi);    % Apply   pi  rotation about X
    rho = step(spin_system,Ly,rho,-pi/2); % Apply  pi/2 rotation about Y
end

% Time evolution
answer = evolution(spin_system,H,...
                   [coil_x1 coil_y1 coil_z1 coil_x2 coil_y2 coil_z2],...
                   rho,1e-4,1000,'multichannel');

% Bloch sphere plot
[X,Y,Z]=sphere; surf(X,Y,Z,'FaceAlpha',0.5,'EdgeAlpha',0.1);
answer=abs(answer)'; hold on; colormap bone;
plot3(answer(:,1),answer(:,2),answer(:,3),'b-','linewidth',1.5);
plot3(answer(:,4),answer(:,5),answer(:,6),'r-','linewidth',1.5);
axis([-1 1 -1 1 -1 1]); axis square;
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')
view([116.74 16.56]);

end