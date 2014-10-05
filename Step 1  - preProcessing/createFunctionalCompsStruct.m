function createFunctionalCompsStruct

do.all = 1;
do.bySpectTopoDipole = 0;
do.bySpectTopoDipoleErsp = 0;

output_path = 'F:\Study 3 - MNS response to invisible actions\EEG\Data\';
subjects ={'348'};% {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
    %'342' '344' '345' '346' '347' '348' '350'};
comps = {'left_central_mu', 'right_central_mu', 'central_occipital_alpha'};
% subjects = {'329' '332' '334' '336' '340' '342'  '345' '347' '348' '350'};
% comps = {'left_central_mu', 'right_central_mu', ...
%     'left_occipital_alpha', 'right_occipital_alpha', 'central_occipital_alpha'};
comps_324 = [];
% save([output_path 'functional_components.mat'], 'comps_324');

for s = 1:size(subjects,2)
    eval(['comps_' subjects{s} ' = struct;']);
    eval(['comps_' subjects{s} '.all.all = [];']);
    if do.all
        for c = 1:size(comps,2)
        field = ['comps_' subjects{s} '.all.' comps{c}];
        ics = get_ics(0,1, field);
       eval([field ' = ics;']);
       eval(['comps_' subjects{s} '.all.all = [comps_' subjects{s} '.all.all, ' ...
           'comps_' subjects{s} '.all.' comps{c} '];']);
        end
    end
    save([output_path 'functional_components.mat'], ['comps_' subjects{s}], '-append'); 
end
end


function ics = get_ics(from_xls, from_user, command)
if from_xls
elseif from_user
    ics = input(['insert ' command ' : ']);
end
end
