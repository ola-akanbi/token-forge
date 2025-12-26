// Starter placeholder for WalletConnect (Stacks) integration
// Implement connection logic following the Wallet Connect Wallet SDK docs:
// https://docs.walletconnect.network/wallet-sdk/web/installation
// https://docs.walletconnect.network/wallet-sdk/chain-support/stacks#stacks

export async function connectWithWalletConnect(): Promise<void> {
  // TODO: implement WalletConnect session creation, pairing and request handling.
  // Use @reown/walletkit for UI/Stacks helpers and @walletconnect/core + @walletconnect/utils for protocol.
  throw new Error('Not implemented: implement WalletConnect flow (see INTEGRATE_WALLETCONNECT.md)');
}

export function getInstallCommand(): string {
  return 'npm install @reown/walletkit @walletconnect/utils @walletconnect/core';
}
