```mermaid
stateDiagram-v2
	Initial --> Unauthenticated
	Initial --> Authenticated

	Unauthenticated --> Authenticated
	Unauthenticated --> Failure

	Authenticated --> Unauthenticated
	Authenticated --> Failure
```
