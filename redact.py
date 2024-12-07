#!/usr/bin/env python3
import argparse
import pathlib
import sys

import dotenv


class EnvDictionary:
    def __init__(self, env_dict=None):
        if env_dict is None:
            self.env_dict = self._load_env_dict()
        else:
            self.env_dict = {v: k for k, v in env_dict.items()}

    def _load_env_dict(self):
        return {v: k for k, v in dotenv.dotenv_values().items()}

    def keys(self):
        return self.env_dict.keys()

    def get(self, value):
        return self.env_dict.get(value)


class LogFileProcessor:
    def __init__(self, log_file_path, env_dictionary):
        self.log_file_path = log_file_path
        self.env_dictionary = env_dictionary

    def _read_log_file(self):
        if self.log_file_path == "-":
            return sys.stdin.read()
        else:
            try:
                return pathlib.Path(self.log_file_path).read_text()
            except UnicodeDecodeError:
                return pathlib.Path(self.log_file_path).read_bytes().decode("latin1")

    def _write_log_file(self, log_text):
        if self.log_file_path != "-":
            pathlib.Path(self.log_file_path).write_text(log_text)
        else:
            sys.stdout.write(log_text)

    def redact_log_file(self, inplace=False):
        log_text = self._read_log_file()
        for value in sorted(self.env_dictionary.keys(), key=len, reverse=True):
            if value in log_text:
                log_text = log_text.replace(
                    value, f"[{self.env_dictionary.get(value)} REDACTED]"
                )
        if inplace:
            self._write_log_file(log_text)
        else:
            sys.stdout.write(log_text)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Replace .env values in log file with their keys"
    )
    parser.add_argument("log_file", type=str, help="Path to log file or - for stdin")
    parser.add_argument(
        "-i", "--inplace", action="store_true", help="Modify file in place"
    )
    return parser.parse_args()


def main():
    args = parse_args()
    env_dictionary = EnvDictionary()
    log_file_processor = LogFileProcessor(args.log_file, env_dictionary)
    log_file_processor.redact_log_file(args.inplace)


if __name__ == "__main__":
    main()
