%% Plot the quantum bit state (either mixed state or pure state) in a
%%% Bloch sphere
%%% Written by Guoqing Wang gq_wang@mit.edu in Feb-2020
%%% modified by Kunaal Verma vermakun@umich.edu in Apr-2021
%%% Input "state" should be unit cell
%%% i.e. {[1; 0]} for {[a; b]} - alpha and beta (complex numbers)
%%%      {[1; 0; 0]}  for {[x; y; z]} - cartesian (real numbers)
%%% A figure handle can be passed in as well for the second argument.
%%% A flag to turn on or off the figure axis labels is available for the
%%%     third argument.
function [figure1,x,y,z] = BlochSphere(state,fig,labelsw)
if nargin<2
    figure1 = figure;
    labelsw = 0;
elseif nargin == 2
    figure(fig)
    figure1=fig;
    labelsw = 0;
else
    figure(fig)
    figure1=fig;
end
    [x,y,z] = sphere();
    hold on;
    mesh(x,y,z,...
        'FaceLighting','none',...
        'EdgeLighting','flat',...
        'FaceAlpha',0.1,...
        'EdgeAlpha',0.25,...
        'FaceColor',[0.83 0.81 0.78],...
        'EdgeColor',[0.49 0.49 0.49]);
    alpha(0.1);

curve_nbs = length(state);
x={};y={};z={};
for jj = 1:curve_nbs
    [m,n] = size(state{jj});
    if m==2 %% unitary, need to convert to xyz axis
        [x{jj},y{jj},z{jj}] = BlochSphere_Conversion(state{jj});
    else %%m=3, already xyz axis
        x{jj} = state{jj}(1,:);
        y{jj} = state{jj}(2,:);
        z{jj} = state{jj}(3,:);
    end
    plot3(x{jj},y{jj},z{jj},'o','linewidth',2.8);  % Plot
%     quiver3(zeros(size(x{jj})),zeros(size(y{jj})),zeros(size(z{jj})),...
%         x{jj},y{jj},z{jj},...
%                 'b','LineWidth',3,'Color',[0, 0.4470, 0.7410]);
    col_arr = lines(n);
    for ii = 1:n
        x_temp = x{jj};
        y_temp = y{jj};
        z_temp = z{jj};
        quiver3(0,0,0,x_temp(ii),y_temp(ii),z_temp(ii),...
            'Color',col_arr(ii,:),'LineWidth',3);
    end
end

quiver3(0,0,0,1,0,0,1.2,'k','filled','LineWidth',0.2);
quiver3(0,0,0,-1,0,0,1.2,'k','filled','LineWidth',0.2);
quiver3(0,0,0,0,1,0,1.2,'k','filled','LineWidth',0.2);
quiver3(0,0,0,0,-1,0,1.2,'k','filled','LineWidth',0.2);
quiver3(0,0,0,0,0,1,1.2,'k','filled','LineWidth',0.2);
quiver3(0,0,0,0,0,-1,1.2,'k','filled','LineWidth',0.2);
if labelsw == 0
    text( 1.75,0,0,'$|+\rangle$','FontSize',18,'interpreter','latex');
    text(-1.25,0,0.1,'$|-\rangle$','FontSize',18,'interpreter','latex');
    text(0,1.25,0,'$|\,i\,\rangle$','FontSize',18,'interpreter','latex');
    text(0,-1.75,0,'$|-i\,\rangle$','FontSize',18,'interpreter','latex');
    text(0,-0.1,1.35,'$|0\rangle$','FontSize',18,'interpreter','latex');
    text(0,-0.1,-1.35,'$|1\rangle$','FontSize',18,'interpreter','latex');
elseif labelsw == 'cart'
	text(1.45,-0.2,0,'+x','FontSize',18);
    text(0,1.25,0,'+y','FontSize',18);
    text(0,-0.1,1.35,'+z','FontSize',18);
end
view([116.74 16.56]);
axis equal;
axis off
hold off
end

%% This function converts a 2-by-1 qubit state to its 3D xyz coordinates
function [x,y,z,aa_phi,aa_theta] = BlochSphere_Conversion(aa)
    aa_phi = angle(aa(2,:))-angle(aa(1,:));
    aa_theta = 2*acos(abs(aa(1,:)));
    x = sin(aa_theta).*cos(aa_phi);
    y = sin(aa_theta).*sin(aa_phi);
    z = cos(aa_theta);
end