import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter } from 'k6/metrics';

// Custom metrics
const processInstancesStarted = new Counter('process_instances_started');
const tasksCompleted = new Counter('tasks_completed');

// Test configuration
export const options = {
    scenarios: {
        stress_test: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '1m', target: 50 },    // Fast ramp-up
                { duration: '2m', target: 50 },    // Steady state
                { duration: '1m', target: 100 },   // Ramp-up to high load
                { duration: '2m', target: 100 },   // Sustained high load
                { duration: '30s', target: 200 },  // Spike
                { duration: '1m', target: 200 },   // Hold spike
                { duration: '30s', target: 50 },   // Quick recovery
                { duration: '1m', target: 0 },     // Gradual ramp-down
            ],
        },
    },
    thresholds: {
        http_req_duration: ['p(95)<3000'],        // 95% of requests should be below 3s
        http_req_failed: ['rate<0.05'],           // Allow up to 5% failure rate
        'process_instances_started': ['count>1000'], // Ensure we start enough processes
        'tasks_completed': ['count>800'],         // Ensure most tasks complete
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
    // Get base URL from environment variable or use default
    const baseUrl = __ENV.CAMUNDA_URL || 'http://host.docker.internal:8080';
    const headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    };

    // 1. Start process instance
    let processResponse = http.post(
        `${baseUrl}/engine-rest/process-definition/key/loan_application_process/start`,
        JSON.stringify(generateLoanData()),
        { headers }
    );

    check(processResponse, {
        'process started successfully': (r) => r.status === 200,
    });

    if (processResponse.status === 200) {
        processInstancesStarted.add(1);
        const processInstanceId = JSON.parse(processResponse.body).id;

        // 2. Get task for the process instance
        let taskResponse = http.get(
            `${baseUrl}/engine-rest/task?processInstanceId=${processInstanceId}`,
            { headers }
        );

        check(taskResponse, {
            'task retrieved successfully': (r) => r.status === 200 && JSON.parse(r.body).length > 0,
        });

        if (taskResponse.status === 200) {
            const tasks = JSON.parse(taskResponse.body);
            if (tasks.length > 0) {
                const taskId = tasks[0].id;

                // 3. Complete the task
                let completeResponse = http.post(
                    `${baseUrl}/engine-rest/task/${taskId}/complete`,
                    JSON.stringify({
                        variables: {
                            approved: { value: true, type: 'Boolean' },
                            comments: { value: 'Approved in k6 test', type: 'String' },
                        },
                    }),
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

    // Wait between iterations
    sleep(1);
}
