# Testing the Facilitator Deployment

This guide helps you verify that your facilitator is working correctly after deployment.

## Prerequisites

- Your facilitator deployed and running on Render
- `curl` installed on your local machine (or use any HTTP client)
- At least one blockchain credential configured

## Quick Health Check

### 1. Check Service Status

```bash
curl https://x402-facilitator-3rz0.onrender.com/supported
```

**Expected Response:**

```json
{
  "kinds": [
    {
      "x402Version": 1,
      "scheme": "exact",
      "network": "hedera-testnet",
      "extra": {
        "feePayer": "0.0.1234567"
      }
    }
  ]
}
```

If you see this response, your facilitator is running and configured correctly!

### 2. Check Verify Endpoint

```bash
curl https://your-service.onrender.com/verify
```

**Expected Response:**

```json
{
  "endpoint": "/verify",
  "description": "POST to verify x402 payments",
  "body": {
    "paymentPayload": "PaymentPayload",
    "paymentRequirements": "PaymentRequirements"
  }
}
```

### 3. Check Settle Endpoint

```bash
curl https://your-service.onrender.com/settle
```

**Expected Response:**

```json
{
  "endpoint": "/settle",
  "description": "POST to settle x402 payments",
  "body": {
    "paymentPayload": "PaymentPayload",
    "paymentRequirements": "PaymentRequirements"
  }
}
```

## Full Integration Test

To fully test the facilitator, you'll need to:

1. **Deploy the facilitator** (already done)
2. **Deploy a resource server** (optional, can use the example)
3. **Run a client** that makes a payment

### Using the Example Client

If you want to test with the full payment flow:

1. **Set up environment for the client:**

   ```bash
   cd examples/typescript/clients/axios
   cp .env-local .env
   ```

2. **Update `.env` with your facilitator URL:**

   ```env
   RESOURCE_SERVER_URL=http://localhost:4021  # Your resource server
   FACILITATOR_URL=https://your-service.onrender.com  # Your facilitator
   PRIVATE_KEY=your-paying-account-private-key
   ```

3. **Run the client:**
   ```bash
   pnpm dev
   ```

This will:

- Request a protected resource
- Receive a 402 Payment Required
- Create a payment transaction
- Pay through the facilitator
- Retry the request and receive the resource

## Common Issues

### Service Not Responding

**Symptom**: `curl` returns connection refused or timeout

**Solutions:**

- Check Render dashboard for service status
- Verify the service isn't sleeping (free tier sleeps after 15 min)
- Check service logs in Render dashboard
- Verify environment variables are set correctly

### Missing Supported Networks

**Symptom**: `/supported` returns empty `kinds` array

**Solutions:**

- Verify you added environment variables in Render
- Check that your private keys are correct
- Review service logs for configuration errors

### Verify/Settle Returns 400

**Symptom**: POST to `/verify` or `/settle` returns 400 error

**Solutions:**

- Check the request body format matches the expected schema
- Verify the payment payload is valid
- Check service logs for specific error messages
- Ensure your facilitator has funds for testing

## Next Steps

Once your facilitator is working:

1. Share the URL with your resource server
2. Update clients to use your facilitator
3. Monitor logs for payment verification
4. Consider setting up alerts for failures

## Additional Resources

- [DEPLOYMENT.md](./DEPLOYMENT.md) - Full deployment guide
- [examples/typescript/facilitator/README.md](./examples/typescript/facilitator/README.md) - Facilitator documentation
- [x402 Protocol Specs](./specs/x402-specification.md) - Protocol details
