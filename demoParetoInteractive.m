function demoParetoInteractive()
% DEMOPARETOINTERACTIVE  Interactive Pareto-front demo with arrow toggle
%   Draws three non-dominated fronts, adds arrows from F2->F1 and F3->F2,
%   and provides a button to hide/show the arrows.

%% 1) Define fronts (rows = [f1, f2])
F1 = [1.0 2.0; 1.5 2.5; 2.0 1.5];   % Pareto-optimal front
F2 = [2.8 3.2; 3.2 2.4; 2.6 3.5];   % dominated by F1
F3 = [4.0 4.0; 3.8 4.5];            % dominated by F2

dominates = @(a,b) all(a<=b) && any(a<b);  % strict Pareto dominance

%% 2) Create figure and scatter
fig = figure('Color','w','Position',[100 100 800 600]);
ax = axes('Parent',fig); hold(ax,'on'); grid(ax,'on');
scatter(ax, F1(:,1), F1(:,2), 80, 'o', 'filled', ...
    'MarkerFaceColor', '#FFC20A', 'DisplayName', 'Front F1');
scatter(ax, F2(:,1), F2(:,2), 80, '^', 'filled', ...
    'MarkerFaceColor', '#FF7F0E', 'DisplayName', 'Front F2');
scatter(ax, F3(:,1), F3(:,2), 80, 's', 'filled', ...
    'MarkerFaceColor', '#E24A4A', 'DisplayName', 'Front F3');
xlabel(ax,'f_1 (to minimize)'); ylabel(ax,'f_2 (to minimize)');
legend(ax,'Location','northwest');
title(ax,'Domination across consecutive Pareto fronts');

%% 3) Normalize figure coordinates for arrows
ax.Units = 'normalized';
fig.Units = 'normalized';
posAx = ax.Position;   % [left bottom width height]
xlim = ax.XLim; ylim = ax.YLim;

toFig = @(x,y) deal( posAx(1) + (x-xlim(1))/(xlim(2)-xlim(1))*posAx(3), ...
                     posAx(2) + (y-ylim(1))/(ylim(2)-ylim(1))*posAx(4) );

%% 4) Add arrows: collect handles
arrowHandles = gobjects(0);
for i = 1:size(F2,1)
    p = F2(i,:);
    d = F1(find(arrayfun(@(j) dominates(F1(j,:), p), 1:size(F1,1)), 1), :);
    [ax0, ay0] = toFig(d(1), d(2));
    [ax1, ay1] = toFig(p(1), p(2));
    arrowHandles(end+1) = annotation(fig, 'arrow', [ax0 ax1], [ay0 ay1], ...
        'Color', [0.2 0.2 0.2], 'LineWidth', 1, 'HeadLength', 8);
end
for i = 1:size(F3,1)
    p = F3(i,:);
    d = F2(find(arrayfun(@(j) dominates(F2(j,:), p), 1:size(F2,1)), 1), :);
    [ax0, ay0] = toFig(d(1), d(2));
    [ax1, ay1] = toFig(p(1), p(2));
    arrowHandles(end+1) = annotation(fig, 'arrow', [ax0 ax1], [ay0 ay1], ...
        'Color', [0.2 0.2 0.2], 'LineWidth', 1, 'HeadLength', 8);
end

%% 5) Add toggle button
btn = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Hide arrows', ...
    'Units', 'normalized', 'Position', [0.05 0.02 0.12 0.05], ...
    'FontSize', 10, 'Callback', @toggleArrows);

    function toggleArrows(src, ~)
        visNow = strcmp(arrowHandles(1).Visible, 'on');
        if visNow
            set(arrowHandles, 'Visible', 'off');
            src.String = 'Show arrows';
        else
            set(arrowHandles, 'Visible', 'on');
            src.String = 'Hide arrows';
        end
    end

%% 6) Export to standalone HTML via Plotly Toolbox
fig2plotly(fig, ...
    'filename', 'pareto_consecutive_demo', ...   % writes pareto_consecutive_demo.html
    'fileopt', 'overwrite', ...
    'showLink', false, ...
    'offline', true);
end
