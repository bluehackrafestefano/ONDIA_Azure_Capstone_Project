                    ┌───────────────────────────┐
                    │      Azure Load Balancer  │
                    │   (Public IP: GitLab LB)  │
                    └──────────────┬────────────┘
                                   │
                     ┌─────────────┴─────────────┐
                     │                           │
          ┌───────────────────────┐   ┌───────────────────────┐
          │       GitLab VM        │   │   (future) GitLab VM  │
          │  Ubuntu + GitLab CE    │   │  for 2nd customer     │
          │  Public IP via LB      │   │  (scaling concept)    │
          └───────────┬───────────┘   └───────────┬───────────┘
                      │                           │
                      │                           │
          ┌───────────▼───────────┐   ┌───────────▼───────────┐
          │ PostgreSQL Flexible DB │   │ PostgreSQL Flexible DB │
          │ (Customer 1 Database)  │   │ (Customer 2 Database)  │
          └────────────────────────┘   └────────────────────────┘

