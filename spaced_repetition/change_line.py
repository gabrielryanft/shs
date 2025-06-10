import sys

if len(sys.argv) < 3:
    print("Usage: python script.py <file_path> <line_num>")
    sys.exit(1)

file_path = sys.argv[1]  # Get file path from command argument
line_num = int(sys.argv[2]) -1 # Get line number from command argument (0-based index)

# Read all lines from the file
with open(file_path, "r") as file:
    lines = file.readlines()

# Modify the specific line
if 0 <= line_num < len(lines):
    parts = lines[line_num].strip().split(",")  # Splitting by comma
    if len(parts) >= 2:
        num_x = int(parts[1].split("-")[0])  # Extract x (before "-"s)
        num_y = int(parts[1].split("-")[1])  # Extract y (between "-"s)

        num_x *= 2  # Double x

        # if day is more then 365, add 1 to the year field
        # and get the result of current_day + num_x - 365 to be the result of num_y
        if (num_x + num_y) > 365:
            num_z = int(parts[1].split("-")[2])  # Extract z (after  "-"s)
            num_z += 1
            num_y = (num_y + num_x) % 365

            parts[1] = f"{num_x}-{num_y}-{num_z}"  # Reconstruct the second field
        else:
            num_y += num_x  # Add x to w
            parts[1] = f"{num_x}-{num_y}-{parts[1].split('-')[2]}"  # Reconstruct the second field

        lines[line_num] = ",".join(parts) + "\n"  # Update the line

# Write back the modified content
with open(file_path, "w") as file:
    file.writelines(lines)

