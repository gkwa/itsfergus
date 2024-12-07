import pytest

from redact import EnvDictionary, LogFileProcessor


@pytest.fixture
def env_dictionary():
    return EnvDictionary({"TEST_KEY": "test_value"})


@pytest.fixture
def log_file_processor(env_dictionary, tmp_path):
    log_file_path = tmp_path / "test.log"
    log_file_path.write_text("test_value\nother_value")
    return LogFileProcessor(str(log_file_path), env_dictionary)


def test_env_dictionary_keys(env_dictionary):
    assert "test_value" in env_dictionary.env_dict


def test_env_dictionary_get(env_dictionary):
    assert env_dictionary.get("test_value") == "TEST_KEY"


def test_log_file_processor_read_log_file(log_file_processor):
    assert "test_value" in log_file_processor._read_log_file()


def test_log_file_processor_redact_log_file(log_file_processor, capsys):
    log_file_processor.redact_log_file()
    captured = capsys.readouterr()
    assert "test_value" not in captured.out
    assert "[TEST_KEY REDACTED]" in captured.out


def test_log_file_processor_redact_log_file_inplace(log_file_processor):
    log_file_processor.redact_log_file(inplace=True)
    assert "test_value" not in log_file_processor._read_log_file()
    assert "[TEST_KEY REDACTED]" in log_file_processor._read_log_file()
