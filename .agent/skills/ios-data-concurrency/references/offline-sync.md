# Offline and synchronization

Use this guide only when offline availability, cross-launch caching, or durable synchronization is required.

- Choose one authoritative source. For offline-first reads, a durable local store is commonly the observable source; define cache lifetime and invalidation if memory or HTTP caching is enough.
- Define freshness, staleness disclosure, mutation ownership, ordering, idempotency, retries, and conflict policy before adding sync.
- Treat reachability as a hint, not proof a request will succeed. Use bounded backoff for transient errors; do not blindly retry authorization, validation, or permanent server failures.
- Use `BGTaskScheduler` or background URLSession only when work must survive suspension/termination and the platform permits it. Keep immediate user work in its owned task.
- Test restart, duplicate delivery, cancellation, partial failure, conflict resolution, and recovery after connectivity returns without logging sensitive data.
