# Lambda KMS Access Investigation

## Problem Description

During Lambda invocations using API Gateway with IAM auth, we encounter intermittent KMS access errors:

```
KMSAccessDeniedException: Lambda can't decrypt the container image because KMS access is denied.
KMS Exception: UnrecognizedClientException.
KMS Message: The security token included in the request is invalid.
```

## Key Observations

### Grant Behavior

1. Normal successful setup (`just setup-iam`) creates 2 grants
2. Running `kms-fix3` creates 2 additional grants
3. Grants persist even when they might be stale/invalid

### Error Pattern

1. Initial `just setup-iam` usually works but can occasionally fail with KMS access errors
2. Using `just test-multiple-iam` (which runs teardown/setup cycles):
   - Reliably fails after approximately 6 iterations
   - Provides a reproducible way to trigger the error state
3. `kms-fix3` script:
   - Sometimes temporarily resolves the KMS access errors
   - Sometimes fails to resolve the issue
   - Creates additional grants when run
4. Failures occur well before the 1-hour STS token expiration
5. Once in the error state, the system remains problematic until fully reset

### Reliable Reproduction Steps

1. Run `just test-multiple-iam`
2. Wait for failure (typically around iteration 6)
3. System is now in a consistently failed state for testing fixes

## Current Workaround Attempts

### kms-fix3 Script Behavior

1. Resets Lambda's KMS configuration to default
2. Performs role swap:
   - Creates temporary role
   - Switches Lambda to temp role
   - Switches back to original role
3. Forces new deployment
4. Results in additional grants being created

## Hypotheses

1. **Grant Propagation**

   - New grants might need time to fully propagate through AWS systems
   - Rapid sequential requests might race against propagation

2. **Rate Limiting/Throttling**

   - KMS or Lambda might be rate-limiting grant usage
   - Multiple invocations might overwhelm available grant capacity

3. **Grant State Management**

   - Accumulating stale grants might interfere with fresh ones
   - AWS services might get confused by multiple valid grants

4. **Security Token Handling**
   - Despite 1-hour lifetime, tokens might be handled differently for rapid requests
   - Token validation might be cached or throttled

## Investigation Plan

### 1. Baseline Testing

- [ ] Document exact state of grants at each iteration of test-multiple-iam
- [ ] Monitor KMS throttling metrics during iterations
- [ ] Capture all CloudWatch logs during iterations
- [ ] Determine if failure always occurs at exactly the 6th iteration

### 2. Grant Management Testing

- [ ] Test with cleanup of all grants between iterations
- [ ] Monitor grant creation/usage patterns
- [ ] Test with forced delays between iterations
- [ ] Analyze grant states before and after failures

### 3. Request Pattern Testing

- [ ] Vary intervals between iterations
- [ ] Test with different teardown/setup patterns
- [ ] Monitor API Gateway throttling metrics

### 4. Service Behavior Analysis

- [ ] Monitor Lambda cold starts vs KMS errors
- [ ] Track container reuse patterns
- [ ] Analyze correlation between errors and request timing

## Potential Solutions to Test

1. **Grant Cleanup Between Iterations**

```bash
# Add to test-multiple-iam loop
./cleanup_kms_grants.sh
sleep 30  # Allow propagation
```

2. **Forced Delays**

```bash
# Modify test-multiple-iam to add delays
sleep 60 between iterations
```

3. **Enhanced KMS Fix**

```bash
# Combine cleanup with existing fix
cleanup_kms_grants
sleep 30
kms-fix3
sleep 30
```

4. **Lambda Configuration Changes**

- Test with provisioned concurrency
- Adjust memory/timeout settings
- Try different container image sizes

## Next Steps

1. Instrument test-multiple-iam:
   - Add logging of grant states
   - Track timing of failures
   - Monitor AWS service metrics
2. Create test variations:

   - With grant cleanup
   - With various delays
   - With different KMS fix approaches

3. Document results:
   - Success/failure patterns
   - Grant states at each step
   - Effect of different fixes

## Success Criteria

A reliable solution should:

1. Allow full test-multiple-iam runs without KMS errors
2. Work consistently across multiple test runs
3. Not require manual intervention
4. Maintain reasonable performance
5. Be understandable and maintainable

## Current Status

We have:

- Reliable reproduction steps via test-multiple-iam
- Multiple hypotheses to test
- Several potential solutions to evaluate

Next immediate step is to instrument test-multiple-iam to gather more detailed data about the failure pattern.
