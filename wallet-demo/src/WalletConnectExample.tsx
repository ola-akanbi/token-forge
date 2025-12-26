import React, { useState } from 'react'

const PROJECT_ID = '<YOUR_WALLETCONNECT_PROJECT_ID>'

export default function WalletConnectExample(): JSX.Element {
  const [connected, setConnected] = useState(false)
  const [peerMeta, setPeerMeta] = useState<string | null>(null)
  const [uri, setUri] = useState<string | null>(null)
  const [usingWalletKit, setUsingWalletKit] = useState(false)

  async function connect() {
    try {
      const SignClientModule = await import('@walletconnect/sign-client')
      const SignClient = SignClientModule.default ?? SignClientModule
      const client = await SignClient.init({ projectId: PROJECT_ID })

      client.on('session_update', (args: any) => console.log('session_update', args))
      client.on('session_delete', () => {
        setConnected(false)
        setPeerMeta(null)
      })

      const { uri: pairingUri, approval } = await client.connect({
        requiredNamespaces: {
          stacks: {
            methods: ['stacks_sign', 'stacks_getAddress'],
            chains: ['stacks:mainnet'],
            events: ['chainChanged'],
          },
        },
      })

      if (pairingUri) setUri(pairingUri)

      if (approval) {
        const session = await approval()
        setConnected(true)
        setPeerMeta(JSON.stringify(session.peer.metadata, null, 2))
      }
    } catch (err: any) {
      console.error('connect error', err)
      alert('Failed to connect: ' + (err?.message || String(err)))
    }
  }

  // Optional: wire @reown/walletkit if available for smoother Stacks UX
  async function openWithWalletKit() {
    if (!uri) return alert('No pairing URI available — start connect first')
    try {
      const wk = await import('@reown/walletkit')
      // Many walletkit helpers are framework-specific; attempt a safe open
      const opener = (wk as any).openWallet || (wk as any).connect || (wk as any).default?.open
      if (typeof opener === 'function') {
        setUsingWalletKit(true)
        await opener(uri)
      } else {
        alert('WalletKit imported but no compatible open/connect function was found.');
      }
    } catch (err: any) {
      console.error('walletkit error', err)
      alert('Failed to load @reown/walletkit: ' + (err?.message || String(err)))
    }
  }

  return (
    <div style={{ padding: 12, fontFamily: 'Arial, sans-serif' }}>
      <h3>WalletConnect — Stacks (demo standalone)</h3>
      <p>Replace <strong>PROJECT_ID</strong> with your WalletConnect project id in this file.</p>
      <div style={{ marginTop: 12 }}>
        <button onClick={connect} disabled={connected}>
          {connected ? 'Connected' : 'Connect Wallet (WalletConnect)'}
        </button>
        <button style={{ marginLeft: 12 }} onClick={openWithWalletKit} disabled={!uri}>
          Open in WalletKit (optional)
        </button>
      </div>

      {uri && (
        <div style={{ marginTop: 12 }}>
          <strong>Pairing URI (open in wallet):</strong>
          <div style={{ wordBreak: 'break-all' }}>{uri}</div>
        </div>
      )}

      {peerMeta && (
        <div style={{ marginTop: 12 }}>
          <strong>Peer metadata:</strong>
          <pre>{peerMeta}</pre>
        </div>
      )}

      {usingWalletKit && <div style={{ marginTop: 8 }}>Opened via WalletKit (attempted)</div>}
    </div>
  )
}
