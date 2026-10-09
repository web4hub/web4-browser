# Web4 identity, wallet, and transaction lifecycle

## Status

This document defines the integration boundary for future implementation. The current static browser prototype does **not** implement DID verification, wallet connection, key custody, message signing, transaction submission, or blockchain settlement.

## Trust and identity model

A profile is a local UI context, not an authenticated identity. Never infer authorization from a profile name, a `did:` string, a local-storage value, or a UI badge.

A future identity adapter should expose explicit operations such as:

- `resolve(did)`: resolve using a configured, trusted DID method resolver.
- `verifyDocument(document)`: verify document proofs and controller relationships using method-specific rules.
- `requestAuthentication(challenge)`: request a fresh, origin-bound challenge signature only after explicit user consent.
- `disconnect()`: clear in-memory session state and stop using the connected provider.

Authentication challenges must include the requesting origin, a cryptographically random nonce, issued-at and expiry timestamps, and the exact requested action. Reject expired or reused nonces, unexpected domains, invalid signatures, and unsupported DID methods. A resolved document alone does not prove that the current user controls its keys.

## Wallet provider boundary

For EVM-compatible wallets, an adapter may use the EIP-1193 provider interface exposed by the user's wallet. It must:

1. Detect provider availability without treating provider presence as authentication.
2. Request account access only after a user gesture and explain what the wallet will disclose.
3. Read the active chain ID and reject networks outside an explicit allowlist.
4. Handle account and chain changes by invalidating stale previews and pending authorization state.
5. Request message signatures only for a displayed, origin-bound challenge. Never sign opaque or server-supplied payloads without showing the decoded intent.
6. Never request, store, log, or transmit private keys or seed phrases.
7. Treat provider errors, user rejection, and timeouts as normal states; do not silently retry a signing request.

Wallet connection is not equivalent to identity verification, and signing a message is not the same as authorizing a transaction.

## Transaction lifecycle

Use an explicit state machine. State changes must be driven by verified adapter results, not UI optimism.

```text
draft
  -> validated
  -> awaiting_user_approval
  -> signature_requested
  -> submitted
  -> confirmed

Any nonterminal state may transition to cancelled or failed where appropriate.
A submitted transaction may remain pending or be replaced; it must not be marked confirmed without a receipt verified against the expected chain and transaction hash.
```

Each intent should carry an immutable intent ID, profile/session reference, chain ID, account, decoded action, asset identifiers, amount, slippage/deadline constraints where relevant, quote timestamp, quote source, and a digest of the exact payload shown to the user. Revalidate account, chain, quote freshness, balances/allowances, and constraints immediately before requesting approval. Do not treat an indicative quote as a guarantee.

For on-chain transactions, track at minimum:

- `draft`
- `validated`
- `awaiting_user_approval`
- `signature_requested`
- `submitted`
- `pending_confirmation`
- `confirmed`
- `cancelled`
- `failed`
- `replaced` (when the provider/network reports replacement)

Use idempotency keys for backend submission paths, validate transaction receipts and expected events, and handle reorgs/timeouts without duplicating actions. Never expose a “settled” state based only on a successful wallet prompt.

## Data isolation and privacy

Profile switching in the current prototype changes only visual context. Production profile isolation requires a deliberate storage model, separate permission scopes, clear origin boundaries, and an explicit policy for shared history/bookmarks. Do not promise anonymity from a private label or temporary profile. Avoid persistent tracking identifiers and keep secrets out of browser storage.

## Release gate

Before enabling a live adapter, require chain-specific configuration, threat modeling, dependency review, provider-mock tests, rejection and network-switch tests, stale-quote tests, transaction receipt verification, and an independent security review. Until then, keep the UI read-only or explicitly simulated and label every simulated result.
