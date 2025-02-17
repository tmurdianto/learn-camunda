# Basic Process Example: Loan Approval

This example demonstrates a simple loan approval process using Camunda 7. It includes user tasks, gateways, and basic decision-making.

## Process Overview
![Loan Approval Process](loan-approval.png)

The process includes:
1. Start event when loan request is received
2. User task for application review
3. Decision gateway
4. Separate paths for approval and rejection
5. End events for both outcomes

## How to Run

1. Ensure Camunda is running:
```bash
cd ../../resources
docker-compose -f docker-compose.dev.yml up -d
```

2. Deploy the Process:
   - Open Camunda Modeler
   - Open `loan-approval.bpmn`
   - Click "Deploy"
   - Select your local Camunda engine

3. Start a Process Instance:
   - Open Camunda Tasklist (http://localhost:8080/camunda/app/tasklist)
   - Click "Start Process"
   - Select "Loan Approval Process"
   - Click "Start"

4. Work on Tasks:
   - Log in as 'demo' user
   - Find the "Review Loan Application" task
   - Claim and complete it
   - Set the 'approved' variable to true/false
   - Complete the following task based on your decision

## Process Variables
- `approved` (boolean): Determines if loan is approved

## Learning Points
1. Basic BPMN elements
2. User task implementation
3. Gateway usage
4. Process variables
5. Task forms

## Next Steps
- Add form fields
- Implement service tasks
- Add business rules
