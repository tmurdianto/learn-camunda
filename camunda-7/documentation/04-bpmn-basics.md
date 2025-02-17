# BPMN Basics

## Core BPMN Elements

### 1. Flow Objects

#### Events
- **Start Events**: Begin process flow
  ```
  ○ Basic start event
  ⚡ Message start event
  ⌚ Timer start event
  ```

- **End Events**: Terminate process flow
  ```
  ⬤ Basic end event
  ✉ Message end event
  ⚠ Error end event
  ```

- **Intermediate Events**: Handle events during process
  ```
  ◇ Timer event
  ◇ Message event
  ◇ Signal event
  ```

#### Activities
- **Tasks**
  ```
  ▭ User Task
  ▭ Service Task
  ▭ Script Task
  ▭ Business Rule Task
  ```

- **Sub-Processes**
  ```
  ▭─── Embedded Sub-Process
  ▭... Call Activity
  ```

#### Gateways
- **Decision Points**
  ```
  ◇ Exclusive Gateway (XOR)
  ◇ Parallel Gateway (AND)
  ◇ Inclusive Gateway (OR)
  ```

### 2. Connecting Objects
```
→ Sequence Flow
⋯→ Default Flow
--→ Message Flow
```

## Common Patterns

### 1. Sequential Flow
```
Start → Task A → Task B → End
```

### 2. Parallel Processing
```
Start → Parallel Gateway (split) 
  → Task A
  → Task B
→ Parallel Gateway (join) → End
```

### 3. Exclusive Choice
```
Start → XOR Gateway
  → Condition A → Task A
  → Condition B → Task B
→ XOR Gateway → End
```

## Best Practices

### 1. Naming Conventions
- Use verb-noun format for tasks
- Clear gateway labels
- Descriptive event names

### 2. Process Structure
- Left-to-right flow
- Clear start and end
- Proper gateway pairs
- Reasonable process size

### 3. Documentation
- Process description
- Technical details
- Business rules

## Implementation Examples

### 1. Basic Approval Process
See [Basic Process Example](../examples/01-basic-process)
```
Start → Review Task → Approval Gateway → End
```

### 2. Error Handling
```
Service Task → Error Boundary Event → Error Handler → End
```

### 3. Timer Events
```
Start → Timer Event → Notification → End
```

## Common Issues

### 1. Gateway Mismatches
- Unpaired split/join gateways
- Wrong gateway types
- Missing default flows

### 2. Event Handling
- Unhandled errors
- Missing message correlations
- Timer format issues

### 3. Process Design
- Too complex processes
- Unclear business logic
- Poor documentation

## Next Steps
1. Try [User Tasks](./05-forms-guide.md)
2. Explore [Service Integration](./06-service-integration.md)
3. Implement practical examples
