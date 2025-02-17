# User Tasks with Forms Example

This example demonstrates a comprehensive loan application process with embedded forms, user assignments, and complex decision making.

## Process Features

### 1. Form Implementation
- Start form for loan application
- Credit check form with detailed fields
- Approval form with loan terms
- Rejection form with feedback

### 2. Form Field Types
- String fields (names, notes)
- Numeric fields (amounts, scores)
- Enumeration (employment status)
- Boolean fields (decisions)
- Required vs optional fields

### 3. Process Flow
1. **Start Form**
   - Applicant details
   - Loan amount request
   - Employment information

2. **Credit Check Task**
   - Credit score input
   - Income verification
   - Debt assessment

3. **Decision Gateway**
   - Automated routing based on credit check

4. **Final Tasks**
   - Approval with loan terms
   - Rejection with feedback

## How to Run

1. **Deploy the Process**
```bash
# Start Camunda
cd ../../resources
docker-compose -f docker-compose.dev.yml up -d
```

2. **Access Camunda**
- Open http://localhost:8080/camunda
- Login with demo/demo

3. **Deploy the BPMN**
- Open Camunda Modeler
- Load `loan-application-with-forms.bpmn`
- Click Deploy
- Select local engine

4. **Start a Process**
- Go to Tasklist
- Click "Start Process"
- Select "Loan Application with Forms"
- Fill in the start form

5. **Work on Tasks**
- Check Tasklist for new tasks
- Claim tasks
- Complete forms
- Observe process flow

## Form Fields Reference

### Start Form
```json
{
  "applicantName": "string",
  "loanAmount": "long",
  "email": "string",
  "employmentStatus": "enum"
}
```

### Credit Check Form
```json
{
  "creditScore": "long",
  "monthlyIncome": "long",
  "existingDebts": "long",
  "creditCheckPassed": "boolean",
  "notes": "string"
}
```

### Approval Form
```json
{
  "approvedAmount": "long",
  "interestRate": "double",
  "loanTerm": "long",
  "approvalNotes": "string"
}
```

### Rejection Form
```json
{
  "rejectionReason": "string",
  "suggestionForImprovement": "string",
  "reapplyPeriod": "long"
}
```

## Process Variables

| Variable | Type | Description |
|----------|------|-------------|
| applicantName | string | Name of loan applicant |
| loanAmount | long | Requested loan amount |
| creditScore | long | Applicant's credit score |
| creditCheckPassed | boolean | Credit check decision |
| approvedAmount | long | Final approved amount |
| rejectionReason | string | Reason for rejection |

## Learning Points
1. Form field types and validation
2. User task assignment
3. Gateway decision making
4. Process variables usage
5. Form data persistence

## Next Steps
1. Add service task for credit score calculation
2. Implement email notifications
3. Add business rules for approval criteria
4. Create custom form layouts
5. Implement multi-user assignments
