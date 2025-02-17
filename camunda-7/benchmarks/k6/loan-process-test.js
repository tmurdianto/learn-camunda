import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter } from 'k6/metrics';

// Custom metrics
const processInstancesStarted = new Counter('process_instances_started');
const tasksCompleted = new Counter('tasks_completed');

// Test configuration
export const options = {
    stages: [
        { duration: '2m', target: 10 },  // Ramp-up
        { duration: '5m', target: 50 },  // Sustained load
        { duration: '2m', target: 100 }, // High load
        { duration: '1m', target: 0 },   // Ramp-down
    ],
    thresholds: {
        http_req_duration: ['p(95)<2000'], // 95% of requests should be below 2s
        http_req_failed: ['rate<0.01'],    // Less than 1% failure rate
    },
};

// Helper function to generate random loan data
function generateLoanData() {
    return {
        variables: {
            applicantName: { value: `Test User ${Math.floor(Math.random() * 10000)}`, type: 'String' },
            loanAmount: { value: Math.floor(Math.random() * 100000) + 10000, type: 'Long' },
            email: { value: `test${Math.floor(Math.random() * 10000)}@example.com`, type: 'String' },
            employmentStatus: { value: 'employed', type: 'String' },
        },
    };
}

// Main test scenario
export default function () {
    const baseUrl = 'http://localhost:8080/engine-rest';
    const headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    };

    // 1. Start process instance
    let processResponse = http.post(
        `${baseUrl}/process-definition/key/loan_application_process/start`,
        JSON.stringify(generateLoanData()),
        { headers }
    );

    check(processResponse, {
        'process started successfully': (r) => r.status === 200,
    });

    if (processResponse.status === 200) {
        processInstancesStarted.add(1);
        const processInstanceId = JSON.parse(processResponse.body).id;

        // 2. Get task for credit check
        let taskResponse = http.get(
            `${baseUrl}/task?processInstanceId=${processInstanceId}`,
            { headers }
        );

        if (taskResponse.status === 200) {
            const tasks = JSON.parse(taskResponse.body);
            if (tasks.length > 0) {
                const taskId = tasks[0].id;

                // 3. Complete credit check task
                const creditCheckData = {
                    variables: {
                        creditScore: { value: Math.floor(Math.random() * 300) + 500, type: 'Long' },
                        monthlyIncome: { value: Math.floor(Math.random() * 5000) + 3000, type: 'Long' },
                        existingDebts: { value: Math.floor(Math.random() * 20000), type: 'Long' },
                        creditCheckPassed: { value: true, type: 'Boolean' },
                    },
                };

                let completeResponse = http.post(
                    `${baseUrl}/task/${taskId}/complete`,
                    JSON.stringify(creditCheckData),
                    { headers }
                );

                check(completeResponse, {
                    'task completed successfully': (r) => r.status === 204,
                });

                if (completeResponse.status === 204) {
                    tasksCompleted.add(1);
                }
            }
        }
    }

    sleep(1);
}
