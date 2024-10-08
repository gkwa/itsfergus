import json
import logging
import sys

import numpy

logger = logging.getLogger()
logger.setLevel(logging.INFO)

stdout_handler = logging.StreamHandler(sys.stdout)
logger.addHandler(stdout_handler)


def handler(event, context):
    matrix = numpy.random.rand(2, 2)
    matrix_list = matrix.tolist()
    matrix_str = numpy.array2string(matrix, precision=2, separator=", ")
    logger.info("Random Matrix:")
    logger.info(matrix_str)
    print("Random Matrix (stdout):")
    print(matrix_str)
    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Matrix generated successfully",
                "matrix": matrix_list,
                "matrix_string": matrix_str,
            }
        ),
    }
