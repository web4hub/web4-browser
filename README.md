# Web4 Browser

A static browser-workspace prototype exploring profile-scoped UI, per-tab navigation, bookmarks, local history, and transparent identity boundaries.

## Run locally

Open `index.html` in a modern browser, or serve the repository root with any static HTTP server. GitHub Pages publishes the repository root through `.github/workflows/static.yml`, so `index.html` is the default entry point.

## Included

- Multiple tabs with independent back/forward history.
- URL entry and search-term fallback.
- HTTP(S) navigation in a sandboxed iframe with a no-referrer policy.
- IPFS gateway links in the form `ipfs://CID` (gateway-based, not native IPFS resolution).
- Local placeholder views for custom Web4-style schemes.
- Local profile contexts: Personal Core, Sovereign Work, and Ephemeral Shadow.
- Session-only bookmarks and history; no backend or tracking service.

## Important limitations

This is **not a production browser engine** and does not replace a native browser. Websites that prohibit framing may not load. Sandboxed pages have limited browser capabilities.

Profile selection changes the local UI context only. It does not authenticate a decentralized identifier, isolate browser storage or network traffic, create anonymity, or change cryptographic credentials. Wallet connectivity, secure signing, DID resolution, encrypted persistence, zero-knowledge proofs, and blockchain settlement are not implemented.

The token marketplace in `static/marketplace.html` is a separate local simulation. Its prices and balances are sample data; approval only updates in-memory demo state.

## Security notes

- Only HTTP(S) website URLs are navigated directly.
- Unknown/custom schemes are not silently sent to a third-party proxy; they render as local placeholders.
- External pages are framed with sandbox restrictions and no referrer.
- Do not enter secrets, seed phrases, passwords, or private keys into this prototype.
- Do not interpret the profile label, IPFS gateway result, or demo proof fingerprint as verified identity or trust evidence.

## Validation

The GitHub Actions workflow `validate-browser.yml` checks required entry-point controls and validates the inline JavaScript syntax. These static checks do not replace browser-based interaction tests or security review.
