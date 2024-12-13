<template>
    <div class="card">
        <div class="card-header">
            <h5>Stock Changes Over Time by Product</h5>
        </div>
        <div class="card-body">
            <!-- Render the chart only when chartData is ready -->
            <LineChart v-if="chartData && chartData.labels.length" :data="chartData" :options="chartOptions" />
            <p v-else>Loading chart data...</p>
        </div>
    </div>
</template>

<script>
import { Line } from 'vue-chartjs';
import {
    Chart as ChartJS,
    Title,
    Tooltip,
    Legend,
    LineElement,
    PointElement,
    CategoryScale,
    LinearScale,
} from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, LineElement, PointElement, CategoryScale, LinearScale);

export default {
    components: { LineChart: Line },
    data() {
        return {
            chartData: {
                labels: [], // Time intervals (e.g., dates or weeks)
                datasets: [], // Array of datasets for each product
            },
            chartOptions: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                    },
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Time',
                        },
                    },
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Stock Change',
                        },
                    },
                },
            },
        };
    },
    async mounted() {
        try {
            const response = await fetch('http://localhost:5555/products/stock-changes-over-time');
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            const data = await response.json();
            console.log('Fetched stock changes data:', data);

            if (data && Array.isArray(data.stockChanges)) {
                const products = {};
                let allTimestamps = new Set();

                // Format the date and time for display
                const formatDate = (date) => {
                    return new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                        hour12: false, // 24-hour format
                    }).format(new Date(date));
                };

                // Organize data into products and collect all timestamps
                data.stockChanges.forEach(change => {
                    if (!products[change.product_name]) {
                        products[change.product_name] = {
                            label: change.product_name,
                            data: [],
                            borderColor: `hsl(${Math.random() * 360}, 100%, 50%)`, // Random color for each product
                            fill: false,
                        };
                    }
                    const formattedTimestamp = formatDate(change.created_at);
                    allTimestamps.add(formattedTimestamp);
                    products[change.product_name].data.push({
                        x: formattedTimestamp,
                        y: change.quantity_changed,
                    });
                });

                // Sort timestamps and assign them as labels
                this.chartData.labels = Array.from(allTimestamps).sort((a, b) => new Date(a) - new Date(b));

                // Sort the data in each dataset by formatted timestamp
                this.chartData.datasets = Object.values(products).map(dataset => {
                    dataset.data.sort((a, b) => new Date(a.x) - new Date(b.x));
                    return dataset;
                });

            } else {
                console.error("Expected stockChanges to be an array:", data);
                this.chartData.labels = [];
                this.chartData.datasets = [];
            }
        } catch (error) {
            console.error('Failed to fetch stock changes data:', error);
            this.chartData.labels = [];
            this.chartData.datasets = [];
        }
    },

};
</script>