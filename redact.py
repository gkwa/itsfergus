import argparse
import pathlib
import sys


def parse_args():
    parser = argparse.ArgumentParser(
        description="Replace .env values in log file with their keys"
    )
    parser.add_argument(
        "log_file", type=pathlib.Path, help="Path to the log file to process"
    )
    parser.add_argument(
        "-i", "--inplace", action="store_true", help="Modify file in place"
    )
    return parser.parse_args()


def main():
    args = parse_args()

    env_dict = {}
    for line in pathlib.Path(".env").read_text().splitlines():
        if "=" in line:
            key, value = line.strip().split("=", 1)
            env_dict[value] = key

    # Sort values by length to prevent partial matches
    values_sorted = sorted(env_dict.keys(), key=len, reverse=True)

    log_text = args.log_file.read_text()
    for value in values_sorted:
        if value in log_text:
            log_text = log_text.replace(value, f"[{env_dict[value]} REDACTED]")

    if args.inplace:
        args.log_file.write_text(log_text)
        return

    sys.stdout.write(log_text)


if __name__ == "__main__":
    main()
