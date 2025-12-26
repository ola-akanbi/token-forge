import React, { useState } from 'react'

// Lightweight React example that demonstrates the WalletConnect pairing flow.
// This uses dynamic imports so you can adapt to the WalletConnect client you prefer
// (SignClient / core / web SDK). Fill `PROJECT_ID` with your WalletConnect project id.

const PROJECT_ID = '<YOUR_WALLETCONNECT_PROJECT_ID>'

export function WalletConnectExample(): JSX.Element {
  const [connected, setConnected] = useState(false)
  const [peerMeta, setPeerMeta] = useState<string | null>(null)
  const [uri, setUri] = useState<string | null>(null)

  async function connect() {
    try {
      // Try to dynamically import the official Sign Client (v2)
      // If you use another SDK adjust accordingly.
      const SignClient = (await import('@walletconnect/sign-client')).default

      const client = await SignClient.init({ projectId: PROJECT_ID })

      client.on('session_update', (args: any) => {
        // handle session updates
        console.log('session_update', args)
      })

      client.on('session_delete', () => {
        setConnected(false)
        setPeerMeta(null)
      })

      const { uri: pairingUri, approval } = await client.connect({
        requiredNamespaces: {
          stacks: {
            methods: [
              'stacks_sign',
              'stacks_getAddress'
            ],
            chains: ['stacks:mainnet'],
            events: ['chainChanged']
          }
        }
      })

      if (pairingUri) {
        // Show URI to user or open deep-link to wallet
        setUri(pairingUri)
      }

      if (approval) {
        const session = await approval()
        setConnected(true)
        setPeerMeta(JSON.stringify(session.peer.metadata, null, 2))
      }
    } catch (err: any) {
      console.error('WalletConnect connect error', err)
      alert('Failed to start WalletConnect: ' + (err?.message || String(err)))
    }
  }

  return (
    <div style={{ padding: 12, fontFamily: 'Arial, sans-serif' }}>
      <h3>WalletConnect — Stacks Example</h3>
      <p>
        This is a minimal example. Replace <code>PROJECT_ID</code> with your WalletConnect
        project id and ensure the installed SDK matches the dynamic import above.
      </p>
      <div style={{ marginTop: 12 }}>
        <button onClick={connect} disabled={connected}>
          {connected ? 'Connected' : 'Connect Wallet (WalletConnect)'}
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
    </div>
  )
}

export default WalletConnectExample
