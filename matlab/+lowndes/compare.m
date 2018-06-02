
function compare( reference_file, comparison_files )
% COMPARE Quantatively compare the contents of one lowndes file to others
%  COMPARE( reference_file, comparison_files )
% reference_file is a filename containing Lowndes data
% comparison_files is either a single filename or a cell array of Lowndes
%                  data
if ~iscell( comparison_files )
    comparison_files = { comparison_files };
end

import lowndes.*

ref_lowndes = lowndes.read(reference_file);

for index_comparison = 1:length(comparison_files)
    if ~strcmp(comparison_files{index_comparison}, reference_file)
        test_lowndes = lowndes.read(comparison_files{index_comparison});
        compare_pair( ref_lowndes, test_lowndes);
    end
end



function comparison = compare_pair( lowndes1, lowndes2)


comparison = [];
disp( [ 'Comparison: ' lowndes1.info.basename ' vs ' lowndes2.info.basename ] );

if any(lowndes1.info.bells_present ~= lowndes2.info.bells_present)
    disp('Incompatible number of bells present');
    return;
end

lowndes1_bells = [ lowndes1.strike.bell ];
lowndes2_bells = [ lowndes2.strike.bell ];
disp( 'Differences in blows transcribed:')

bell_discrepancies = cell(length(lowndes1.info.bells_present),1);

differences = 0;
for index_bells = 1:length(lowndes1.info.bells_present)
    this_bell = lowndes1.info.bells_present(index_bells);
    lowndes1_mask = (lowndes1_bells == this_bell);
    lowndes2_mask = (lowndes2_bells == this_bell);
    
    bell_diffs = sum( lowndes1_mask ) - sum( lowndes2_mask );
    fprintf('%5d:  %3d\n', this_bell, bell_diffs);
    differences = differences + abs( bell_diffs);
    
    strike_time_1 = [ lowndes1.strike( lowndes1_mask ).actual_time ];
    strike_time_2 = [ lowndes2.strike( lowndes2_mask ).actual_time ];
    if abs(bell_diffs)<0.5
        bell_discrepancies{index_bells} = strike_time_1 - strike_time_2;
    else
        bell_discrepancies{index_bells} = [];
    end
end
fprintf('Total:  %3d\n', differences);

disp('Bell averages');
for index_bells = 1:length(lowndes1.info.bells_present)
    this_bell = lowndes1.info.bells_present(index_bells);
    fprintf('%5d:  %+6.1f  %6.1f\n', this_bell, mean(bell_discrepancies{index_bells}*1000), std(bell_discrepancies{index_bells}*1000) );
end


