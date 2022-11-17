function new_string_list = removeSpaces(old_string_list)
new_string_list = old_string_list;
for i = 1:length(new_string_list)
    new_string_list{i} = strrep(new_string_list{i},' ','_');
    new_string_list{i} = strrep(new_string_list{i},',','');
end