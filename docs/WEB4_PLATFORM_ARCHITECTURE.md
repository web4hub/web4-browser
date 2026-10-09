# Web4 Workspace architecture and implementation boundary

## Product shape

The repository remains a static GitHub Pages prototype. The workspace entry point is static/workspace.html; it demonstrates a unified shell for:

- Authentication and account status UI (not real authentication).
- Public profile editing (local in-memory state only) and a separate identity integration boundary.
- AI command-center flow with a deterministic local planner (no model endpoint).
- User-requested page draft generation and navigation suggestions (not auto-published).
- Community chat UI (local messages only; no cross-user delivery).
- Browser speech synthesis / optional browser speech recognition for a sample AI-radio interface.
- Podcast discovery cards and local episode drafts (no RSS feed or media hosting).
- Currency conversion using bundled example rates, sample paper-note inventory, and links to existing gateway/marketplace demos.
- Automation draft creation (no scheduler or background execution).

## Production services to add

1. **Identity and sessions**: use a maintained OIDC/passkey provider; server-side session store; HTTPS; Secure, HttpOnly, SameSite cookies; CSRF defenses; short idle and absolute expirations; account recovery and MFA/passkey lifecycle. Do not store session tokens in local storage. See the [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html).
2. **Profile and DID service**: account-to-DID binding, DID method/resolver policy, key rotation and revocation, explicit profile visibility, export/delete flows, and verified-vs-unverified state.
3. **AI gateway**: server-side model keys, per-user quotas, input/output safety, tool allowlists, audit records, and explicit user approval for external actions. Generated pages remain drafts until reviewed and published.
4. **Pages/navigation**: draft API, isolated preview origin or strict sandbox, content sanitization, versioning, publish permissions, URL allowlists, and abuse/reporting workflow.
5. **Chat**: authenticated WebSocket gateway, room-level authorization, rate limits, message persistence policy, block/report/moderation controls, retention and deletion rules, and optional end-to-end encryption.
6. **Radio and podcasts**: audio storage/CDN, creator permissions, RSS/episode metadata, playback telemetry controls, transcript/caption workflow, and moderation. Speech APIs are browser-dependent and must be disclosed.
7. **Automation**: durable scheduler, scoped credentials, retries, cancellation, run history, quotas, and per-action authorization. Never let generated instructions silently trigger transfers or privileged operations.
8. **Wallet, tokens and fiat**: separate display-only balances from provider-confirmed balances; use audited wallet/provider integrations; show fees, quote source, quote timestamp, slippage and final confirmation; maintain idempotency, reconciliation, fraud monitoring, and required legal/compliance review. Paper-note artwork is a non-redeemable sample and must not be represented as official currency.
9. **Observability and governance**: privacy-conscious audit logs, incident response, backup/restore, data lifecycle, accessibility, localization and security testing.

## API contract outline (not implemented)

- POST /api/v1/auth/session, DELETE /api/v1/auth/session, GET /api/v1/me
- GET/PATCH /api/v1/profile; GET /api/v1/identity
- POST /api/v1/ai/plan; POST /api/v1/pages/drafts; POST /api/v1/pages/:id/publish
- GET /api/v1/chat/rooms; authenticated WebSocket for authorized room events
- GET /api/v1/podcasts; POST /api/v1/podcast-drafts
- POST /api/v1/automations; GET /api/v1/automations/:id/runs
- GET /api/v1/fx/quote; wallet/settlement endpoints only after provider and threat-model review

All authenticated routes must enforce authorization server-side. These endpoint names are proposals, not live APIs.

## Validation boundary

Static validation can check HTML IDs, duplicate IDs, and JavaScript syntax. It cannot prove authentication, authorization, data isolation, audio delivery, live messaging, real AI, wallet correctness, or settlement safety. Run browser interaction tests and a separate security review before public production use.
