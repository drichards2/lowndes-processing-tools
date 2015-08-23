% Function LOWNDES.WRITE
% Argument:
%  infile - string with location
%  lowndes_data - structure with lowndes data
%
% Returns:
%  Structure with .info for metadata and .strike for strike information
function write( infile, lowndes_data )

fid = fopen( infile, 'wt');

if ~lowndes.isoctave
% Make sure that the Lowndes output is always closed in MATLAB
c = onCleanup(@()fclose(fid));
end

bell_identifiers = { '1', '2', '3', '4', '5', '6', '7', '8', '9', 'O', 'E', 'T' };

if isfield( lowndes_data.info, 'version' )
    fprintf(fid, '#. Lowndes: %s\n', lowndes_data.info.version);
end
if isfield( lowndes_data.info, 'creator' )
    fprintf(fid, '#. Creator: %s\n', lowndes_data.info.creator);
end
if isfield( lowndes_data.info, 'transcription_date' )
    fprintf(fid, '#. TranscriptionDate: %s\n', lowndes_data.info.transcription_date);
end
if isfield( lowndes_data.info, 'first_blow' )
    fprintf(fid, '#. FirstBlowMs: %d\n', lowndes_data.info.first_blow);
end


for index_strike = 1:length(lowndes_data.strike)
    this_strike = lowndes_data.strike(index_strike);
    
    if this_strike.handstroke
        hb_char = 'H';
    else
        hb_char = 'B';
    end
    
    wrapped_time = mod(this_strike.strike_time, 65536);
    fprintf(fid, '%s %s 0X%04x\n', hb_char, bell_identifiers{ this_strike.bell }, wrapped_time );
    
end

if lowndes.isoctave
    fclose(fid);
end

