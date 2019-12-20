from sys import argv

# Note - the command line parameters are [Input file], [Output file], [Exclusion file (Optional)]

clusters = argv[1] 
output_file = argv[2] 

try:
    scaffolds_to_exclude = argv[3]
except:
    scaffolds_to_exclude = None

exclude_list = []

if scaffolds_to_exclude:
    with open(scaffolds_to_exclude, 'r') as exc:
        for line in exc:
            exclude_list.append(line.strip())


with open(clusters, 'r') as f:

    with open(output_file, 'w') as output:

        for line in f:
            ls = line.strip().split("\t")
            scaffold = ls[0]
            if scaffold not in exclude_list:
                start = int(ls[1]) + 1
                end = ls[2]
                output_string = "{}:{}-{}\n".format(scaffold, start, end)
                #print(output_string)
                output.write(output_string)
