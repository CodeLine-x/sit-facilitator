# Deployment Guide for x402 Facilitator on Render

This guide will help you deploy the x402 Facilitator service on Render.

## Prerequisites

1. A Render account (sign up at https://render.com)
2. At least one of the following blockchain credentials:
   - **Hedera**: Account ID and ECDSA private key
   - **EVM**: Private key for an EVM network (e.g., Base Sepolia)
   - **Solana**: Private key and optional RPC URL

## Quick Deploy on Render

### Option 1: Using render.yaml (Recommended)

1. **Push your code to GitHub**

   ```bash
   git add .
   git commit -m "Add Render deployment configuration"
   git push origin main
   ```

2. **Import your repository to Render**

   - Go to https://dashboard.render.com
   - Click "New +" → "Blueprint"
   - Connect your GitHub repository
   - Render will automatically detect `render.yaml`

3. **Configure Environment Variables**

   - In the Render dashboard, go to your service → "Environment"
   - Add at least ONE set of the following credentials:

   **For Hedera:**

   - `HEDERA_ACCOUNT_ID`: Your Hedera account ID (e.g., `0.0.1234567`)
   - `HEDERA_PRIVATE_KEY`: Your ECDSA private key

   **For EVM (Base Sepolia):**

   - `EVM_PRIVATE_KEY`: Your private key (starts with `0x`)

   **For Solana:**

   - `SVM_PRIVATE_KEY`: Your base58-encoded Solana private key
   - `SVM_RPC_URL`: Optional custom RPC URL

   **Optional:**

   - `PORT`: Default is `3000` (Render will provide this automatically)

4. **Deploy**
   - Click "Apply Changes"
   - Wait for the build to complete
   - Your facilitator will be available at `https://your-service.onrender.com`

### Option 2: Manual Setup

If you prefer not to use `render.yaml`:

1. **Create a new Web Service on Render**

   - Go to https://dashboard.render.com
   - Click "New +" → "Web Service"
   - Connect your GitHub repository

2. **Configure the service:**

   - **Name**: `x402-facilitator` (or your preferred name)
   - **Runtime**: `Node`
   - **Build Command**: `./build.sh`
   - **Start Command**: `cd examples/typescript/facilitator && pnpm start`
   - **Instance Type**: Free tier is sufficient for testing

3. **Add Environment Variables** (same as Option 1)

4. **Deploy**
   - Click "Create Web Service"
   - Render will automatically deploy

## Testing Your Deployment

Once deployed, test the facilitator endpoints:

### 1. Check if the service is running

```bash
curl https://your-service.onrender.com/supported
```

You should get a response with the supported payment kinds.

### 2. Test the verify endpoint

```bash
curl https://your-service.onrender.com/verify
```

You should see an information response about the verify endpoint.

### 3. Test the settle endpoint

```bash
curl https://your-service.onrender.com/settle
```

You should see an information response about the settle endpoint.

## Local Testing Before Deploy

To test the deployment setup locally:

1. **Set up environment variables:**

   ```bash
   cd examples/typescript/facilitator
   cp .env-local .env
   # Edit .env with your credentials
   ```

2. **Build the project:**

   ```bash
   cd ../../..
   ./build.sh
   ```

3. **Start the facilitator:**

   ```bash
   cd examples/typescript/facilitator
   pnpm start
   ```

4. **Test locally:**
   ```bash
   curl http://localhost:3000/supported
   ```

## Environment Variables Reference

| Variable             | Required        | Description        | Example                               |
| -------------------- | --------------- | ------------------ | ------------------------------------- |
| `HEDERA_ACCOUNT_ID`  | If using Hedera | Hedera account ID  | `0.0.1234567`                         |
| `HEDERA_PRIVATE_KEY` | If using Hedera | ECDSA private key  | `302e...`                             |
| `EVM_PRIVATE_KEY`    | If using EVM    | EVM private key    | `0x1234...`                           |
| `SVM_PRIVATE_KEY`    | If using Solana | Solana private key | Base58 encoded                        |
| `SVM_RPC_URL`        | Optional        | Custom Solana RPC  | `https://api.mainnet-beta.solana.com` |
| `PORT`               | Optional        | Server port        | `3000` (Render provides this)         |

**Note**: You must provide at least ONE set of blockchain credentials (Hedera, EVM, or Solana).

## Troubleshooting

### Build Fails

- **Error**: "pnpm: command not found"

  - **Solution**: The build script installs pnpm automatically, but you can also ensure Node.js 18+ is installed.

- **Error**: "Module not found"
  - **Solution**: Make sure both `typescript/` and `examples/typescript/` packages are built.

### Service Crashes on Start

- **Error**: "Missing required environment variables"

  - **Solution**: Add at least one set of blockchain credentials in Render's environment variables.

- **Error**: "HEDERA_ACCOUNT_ID is required when HEDERA_PRIVATE_KEY is provided"
  - **Solution**: If using Hedera, you must provide both `HEDERA_ACCOUNT_ID` and `HEDERA_PRIVATE_KEY`.

### Service Times Out

- **Issue**: Service goes to sleep on free tier
  - **Solution**: Free tier services sleep after 15 minutes of inactivity. Consider upgrading to a paid plan or use a monitoring service to ping your endpoint.

## Advanced Configuration

### Using Multiple Blockchains

You can configure the facilitator to support multiple blockchains by providing credentials for each:

```env
# Hedera
HEDERA_ACCOUNT_ID=0.0.1234567
HEDERA_PRIVATE_KEY=302e...

# EVM
EVM_PRIVATE_KEY=0x1234...

# Solana
SVM_PRIVATE_KEY=base58...
SVM_RPC_URL=https://api.devnet.solana.com
```

The facilitator will automatically expose all configured payment kinds in the `/supported` endpoint.

### Custom RPC URLs

For Solana, you can use a custom RPC URL:

```env
SVM_RPC_URL=https://api.mainnet-beta.solana.com
```

For EVM networks, the facilitator uses public RPC endpoints by default.

## Monitoring

- **Render Dashboard**: Check service logs and metrics
- **Logs**: Access logs in the Render dashboard
- **Health Check**: Use the `/supported` endpoint as a health check

## Security Notes

- **Never commit private keys to git**
- **Use Render's Environment Variables** for all sensitive credentials
- **Test on testnets** before using mainnet credentials
- **Rotate keys regularly** in production environments

## Next Steps

After deploying your facilitator:

1. Test the endpoints to ensure they're working
2. Integrate with your resource server
3. Share your facilitator URL with your clients
4. Monitor for any payment verification issues

## Support

- [x402 Protocol Documentation](https://x402.org)
- [Render Documentation](https://render.com/docs)
- [Project Issues](https://github.com/your-repo/issues)
