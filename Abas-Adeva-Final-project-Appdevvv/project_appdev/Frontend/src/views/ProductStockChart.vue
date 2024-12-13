<template>
    <div class="card">
      <div class="card-header">
        <h5>Stock Changes Over Time by Product</h5>
      </div>
      <div class="card-body">
        <!-- Render the chart only when chartData is ready -->
        <BarChart v-if="chartData && chartData.labels.length" :data="chartData" :options="chartOptions"
          class="chart-small" />
        <p v-else>Loading chart data...</p>
      </div>
    </div>
  </template>
  
  <script>
  import { Bar } from 'vue-chartjs';
  import {
    Chart as ChartJS,
    Title,
    Tooltip,
    Legend,
    BarElement,
    CategoryScale,
    LinearScale,
  } from 'chart.js';
  
  ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);
  
  export default {
    components: {
      BarChart: Bar,
    },
    data() {
      return {
        chartData: {
          labels: [], // Product names
          datasets: [
            {
              label: 'Stock',
              data: [], // Stock values
              backgroundColor: '#007bff',
            },
          ],
        },
        chartOptions: {
          responsive: true,
          plugins: {
            legend: {
              display: true,
              position: 'top',
            },
          },
        },
      };
    },
    async mounted() {
      try {
        const response = await fetch('http://localhost:5555/products/stock-overview');
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Fetched data:', data); // Check the response content
  
        if (data && Array.isArray(data.stockOverview)) {
          this.chartData.labels = data.stockOverview.map(product => product.name);
          this.chartData.datasets[0].data = data.stockOverview.map(product => product.stock);
        } else {
          console.error("Expected stockOverview to be an array:", data);
          this.chartData.labels = [];
          this.chartData.datasets[0].data = [];
        }
      } catch (error) {
        console.error('Failed to fetch product stock data:', error);
        // Set default values to avoid crashing the component
        this.chartData.labels = [];
        this.chartData.datasets[0].data = [];
      }
    },
  };
  </script>
  