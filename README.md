# token-forge

TokenForge is a Clarity smart-contract project that implements an enhanced token trading contract and a small test harness. This repository includes:

- The Clarity contract: [contracts/token-forge.clar](contracts/token-forge.clar)
- Unit tests: [tests/token-forge.test.ts](tests/token-forge.test.ts)
- A small React WalletConnect demo: [wallet-demo/](wallet-demo)
- Starter integration helpers: [src/wallet/](src/wallet)

## Features

- ERC20-like token operations (buy, sell, transfer, approve, transfer-from)
- Owner-only admin controls (pause trading, set price, trade limits, whitelist)
- Transaction recording and per-user transaction counts
- Example WalletConnect + Stacks integration and a runnable Vite demo

## Prerequisites

- Node.js (16+ recommended)
- npm
- (Optional) Clarinet if you want to run Clarity/Simnet commands locally: https://github.com/hirosystems/clarinet

## Quickstart — repository (tests & contract)

1. Install root dependencies:

```bash
npm install
```

2. Run the unit tests:

```bash
npm test
```

3. Contract source is located at: `contracts/token-forge.clar`.

If you use Clarinet you can also run simulation and contract checks with Clarinet commands (see `Clarinet.toml`). Example if Clarinet is installed:

```bash
clarinet check
clarinet test
```

## WalletConnect + Stacks integration

This repo includes a minimal WalletConnect + Stacks example. Two locations hold helper/example code:

- Starter docs and placeholder: `src/wallet/INTEGRATE_WALLETCONNECT.md` and `src/wallet/walletConnect.ts`
- A React demo (standalone) ready to run: `wallet-demo/`

### Install WalletConnect packages (if you need them at project root)

```bash
npm install @reown/walletkit @walletconnect/utils @walletconnect/core @walletconnect/sign-client
```

### Run the demo (standalone Vite + React app)

1. Open the demo folder, install dependencies and run the dev server:

```bash
cd wallet-demo
npm install
npm run dev
```

2. Edit the demo file and set your WalletConnect project id:

- `wallet-demo/src/WalletConnectExample.tsx` — replace `<YOUR_WALLETCONNECT_PROJECT_ID>` with your Project ID.

3. The demo shows a pairing URI and can optionally open `@reown/walletkit` (dynamic import). Use the pairing URI or a QR/deep-link to connect a Stacks-capable wallet.

Documentation and further references:

- WalletConnect Web SDK: https://docs.walletconnect.network/wallet-sdk/web/installation
- Stacks chain support: https://docs.walletconnect.network/wallet-sdk/chain-support/stacks#stacks

## Files of interest

- `contracts/token-forge.clar`: main Clarity contract implementing TokenForge.
- `tests/token-forge.test.ts`: Vitest tests that run in the Clarinet environment.
- `src/wallet/INTEGRATE_WALLETCONNECT.md`: integration guidance and starter snippets.
- `wallet-demo/`: small Vite + React demo that imports a standalone `WalletConnectExample`.

## Next steps / Suggestions

- If you want a production-ready dApp UX, I can wire `@reown/walletkit` more tightly, add signing flows that call the contract, and add QR/deep-link handling in the demo.
- I can also add CI steps to run `vitest` and `clarinet` checks on push.

---

If you want, I can now update this README with any extra sections you prefer (API reference, deployment notes, or a short developer guide to calling the contract from the demo).
