# Working with Forms in Camunda 7

## Form Types

### 1. Embedded Forms
```html
<form name="loanApplication">
  <div class="form-group">
    <label>Amount</label>
    <input type="number" 
           cam-variable-name="amount"
           cam-variable-type="Double"
           required />
  </div>
</form>
```

### 2. Generated Forms
```xml
<camunda:formData>
  <camunda:formField id="amount" 
                     label="Loan Amount" 
                     type="long" 
                     required="true" />
</camunda:formData>
```

### 3. Custom Forms
- External form applications
- REST API integration
- Custom UI frameworks

## Form Elements

### 1. Basic Input Types
```xml
<!-- String -->
<camunda:formField id="name" type="string" />

<!-- Number -->
<camunda:formField id="amount" type="long" />

<!-- Boolean -->
<camunda:formField id="approved" type="boolean" />

<!-- Date -->
<camunda:formField id="dueDate" type="date" />
```

### 2. Complex Types
```xml
<!-- Enumeration -->
<camunda:formField id="status" type="enum">
  <camunda:value id="new" name="New Application" />
  <camunda:value id="review" name="Under Review" />
  <camunda:value id="approved" name="Approved" />
</camunda:formField>
```

## Form Implementation

### 1. Start Form
```xml
<bpmn:startEvent id="StartEvent_1">
  <bpmn:extensionElements>
    <camunda:formData>
      <camunda:formField id="applicantName" 
                        label="Applicant Name" 
                        type="string" />
    </camunda:formData>
  </bpmn:extensionElements>
</bpmn:startEvent>
```

### 2. Task Form
```xml
<bpmn:userTask id="ReviewTask">
  <bpmn:extensionElements>
    <camunda:formData>
      <camunda:formField id="decision" 
                        label="Approval Decision" 
                        type="boolean" />
    </camunda:formData>
  </bpmn:extensionElements>
</bpmn:userTask>
```

## Form Validation

### 1. Built-in Validation
```xml
<!-- Required Field -->
<camunda:formField id="email" 
                   type="string" 
                   required="true" />

<!-- Value Constraints -->
<camunda:formField id="age" 
                   type="long" 
                   required="true">
  <camunda:validation>
    <camunda:constraint name="min" config="18" />
    <camunda:constraint name="max" config="100" />
  </camunda:validation>
</camunda:formField>
```

### 2. Custom Validation
```javascript
// Form validation script
if (form.getValue('amount') > 1000000) {
  form.setFieldValue('requiresExtraApproval', true);
}
```

## Form Variables

### 1. Variable Access
```javascript
// Get variable
execution.getVariable('applicationId');

// Set variable
execution.setVariable('status', 'approved');
```

### 2. Variable Scope
- Process Instance
- Task
- Local

## Best Practices

### 1. Form Design
- Clear labels
- Logical grouping
- Proper validation
- Responsive layout

### 2. Implementation
- Reuse common forms
- Maintain consistency
- Handle all cases
- Validate input

### 3. Security
- Input sanitization
- Access control
- Data validation

## Examples

### 1. Basic Form
See [User Tasks Example](../examples/02-user-tasks)

### 2. Complex Form
```xml
<camunda:formData>
  <!-- Personal Information -->
  <camunda:formField id="fullName" type="string" />
  <camunda:formField id="dateOfBirth" type="date" />
  
  <!-- Contact Information -->
  <camunda:formField id="email" type="string" />
  <camunda:formField id="phone" type="string" />
  
  <!-- Application Details -->
  <camunda:formField id="loanAmount" type="long" />
  <camunda:formField id="loanPurpose" type="enum">
    <camunda:value id="home" name="Home Loan" />
    <camunda:value id="car" name="Car Loan" />
    <camunda:value id="personal" name="Personal Loan" />
  </camunda:formField>
</camunda:formData>
```

## Troubleshooting

### 1. Common Issues
- Form not loading
- Variable type mismatch
- Validation errors
- Browser compatibility

### 2. Solutions
- Check variable names
- Verify form deployment
- Test in different browsers
- Validate JSON/XML syntax

## Next Steps
1. Try [Service Integration](./06-service-integration.md)
2. Implement custom forms
3. Add form validation
