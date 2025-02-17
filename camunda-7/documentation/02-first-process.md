# Creating Your First Process in Camunda 7

## Prerequisites
- Camunda environment running (see 01-getting-started.md)
- Camunda Modeler installed (download from [Camunda Modeler](https://camunda.com/download/modeler/))

## Step-by-Step Guide

### 1. Create a New BPMN Diagram
1. Open Camunda Modeler
2. Click "Create new BPMN diagram"
3. Save as `loan-approval.bpmn`

### 2. Model Basic Process
```xml
<?xml version='1.0' encoding='UTF-8'?>
<bpmn2:definitions xmlns:bpmn2='http://www.omg.org/spec/BPMN/20100524/MODEL'>
  <bpmn2:process id='loan-approval' name='Loan Approval Process'>
    <bpmn2:startEvent id='start'/>
    <bpmn2:sequenceFlow sourceRef='start' targetRef='approveTask'/>
    <bpmn2:userTask id='approveTask' name='Approve Loan'/>
    <bpmn2:sequenceFlow sourceRef='approveTask' targetRef='end'/>
    <bpmn2:endEvent id='end'/>
  </bpmn2:process>
</bpmn2:definitions>
```

### 3. Deploy the Process
1. Save the BPMN file
2. Open Camunda Cockpit (http://localhost:8080/camunda/app/cockpit)
3. Go to Deployments
4. Click "Deploy New Process"
5. Upload your BPMN file

### 4. Start a Process Instance
1. Go to Camunda Tasklist
2. Click "Start Process"
3. Select "Loan Approval Process"
4. Click "Start"

### 5. Work on Tasks
1. In Tasklist, you'll see the "Approve Loan" task
2. Click on the task
3. Claim it
4. Complete the task

## Monitoring
1. Open Camunda Cockpit
2. Navigate to "Process Definitions"
3. Click on "Loan Approval Process"
4. View running instances and history

## Next Steps
1. Add form fields to the user task
2. Add service tasks
3. Implement business logic
4. Add decision gateways
