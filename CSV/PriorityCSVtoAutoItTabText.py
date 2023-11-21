# import necessary modules
import os
import csv

# Get the directory path
dir_path = "C:\\Sam's Tool\\CSV"

# loop through each file in the directory
for file in os.listdir(dir_path):
    # get the file path
    file_path = os.path.join(dir_path, file)

    # check if the file is a csv file
    if file.endswith('.csv'):
        # open the csv file and read it
        with open(file_path, 'r') as csv_file:
            reader = csv.reader(csv_file)

            next(reader)
            next(reader)
            counter = 0
            # create a txt file with the same name as the csv file
            txt_path = os.path.splitext(file_path)[0] + '.txt'
            with open(txt_path, 'w') as out_file:
                prev_num = '0'
                for row in reader:
                    # grab the columns
                    machine_name = row[0]
                    name = row[1]
                    num = row[3]
                    iis = row[4]

                    # replace the "name" with "IIS" if the value of iis is 1
                    if iis == '1':
                        name = 'IIS'

                    # check if the current value of the num variable is different from the previous value
                    if num != prev_num:
                        # if the values are different, insert a blank line in the .txt file
                        out_file.write("Priority-"+ num + "\t\n")
                        out_file.write(f"{machine_name}\t{name}\n")
                    elif counter ==  0:
                        # if the values are different, insert a blank line in the .txt file
                        out_file.write("Priority-"+ num + "\t\n")
                        out_file.write(f"{machine_name}\t{name}\n")
                        counter +=1
                    else:
                        # write the data to the output file in the desired format
                        out_file.write(f"{machine_name}\t{name}\n")

                    # update the previous value of the num variable
                    prev_num = num
