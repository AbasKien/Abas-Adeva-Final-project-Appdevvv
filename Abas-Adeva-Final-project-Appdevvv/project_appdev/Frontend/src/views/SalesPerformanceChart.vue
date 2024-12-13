<template>
  <div class="card">
    <div class="card-header">
      <h5>Sales Performance Over Time</h5>
    </div>
    <div class="card-body">
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
        labels: [],
        datasets: [{
          label: 'Total Sales',
          data: [],
          borderColor: '#3498db',
          backgroundColor: 'rgba(52, 152, 219, 0.1)',
          tension: 0.4,
          borderWidth: 2,
          fill: true,
        }],
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top',
          },
          tooltip: {
            mode: 'index',
            intersect: false,
            callbacks: {
              label: function(context) {
                const value = context.parsed.y;
                return `Total Sales: $${value.toFixed(2)}`;
              }
            }
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 'Date',
            },
            ticks: {
              maxRotation: 45,
              minRotation: 45,
            }
          },
          y: {
            title: {
              display: true,
              text: 'Total Sales ($)',
            },
            beginAtZero: true,
            ticks: {
              callback: function(value) {
                return '$' + value.toFixed(2);
              }
            }
          },
        },
      },
      pollingInterval: null,
    };
  },
  async mounted() {
    await this.fetchSalesData();
    // Set up polling to refresh data every minute
    this.pollingInterval = setInterval(this.fetchSalesData, 60000);
    // Listen for order completion events
    window.addEventListener('orderStatusUpdated', this.fetchSalesData);
  },
  beforeDestroy() {
    // Clean up polling interval
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval);
    }
    // Clean up event listener
    window.removeEventListener('orderStatusUpdated', this.fetchSalesData);
  },
  methods: {
    async fetchSalesData() {
      try {
        // Get the token from localStorage
        const token = localStorage.getItem('token');
        if (!token) {
          console.error('No authentication token found');
          return;
        }

        const response = await fetch('http://localhost:5555/products/sales-performance', {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          },
          credentials: 'include'
        });

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        console.log('Fetched sales performance data:', data);

        if (data.success && Array.isArray(data.salesPerformance)) {
          // Sort data by date
          const sortedData = [...data.salesPerformance].sort((a, b) => 
            new Date(a.date) - new Date(b.date)
          );

          // Format dates and prepare data
          this.chartData.labels = sortedData.map(item => {
            // Create date object (it will use local timezone)
            const date = new Date(item.date);
            // Format date in Manila time (UTC+8)
            return date.toLocaleDateString('en-US', {
              month: 'short',
              day: 'numeric',
              year: 'numeric',
              timeZone: 'Asia/Manila'
            });
          });
          this.chartData.datasets[0].data = sortedData.map(item => item.total_sales);
        }
      } catch (error) {
        console.error('Failed to fetch sales performance data:', error);
      }
    }
  }
};
</script>

<style scoped>
.card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin: 1rem;
}

.card-header {
  padding: 1rem;
  border-bottom: 1px solid #eee;
}

.card-header h5 {
  margin: 0;
  color: #2c3e50;
  font-weight: 600;
}

.card-body {
  padding: 1rem;
  height: 400px;
}
</style>
