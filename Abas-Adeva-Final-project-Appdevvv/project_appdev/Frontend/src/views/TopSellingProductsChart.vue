<template>
    <div class="card">
      <div class="card-header">
        <h5>Top Selling Products</h5>
      </div>
      <div class="card-body">
        <!-- Render the chart only when chartData is ready -->
        <BarChart v-if="chartData && chartData.labels.length" :data="chartData" :options="chartOptions" />
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
    components: { BarChart: Bar },
    data() {
      return {
        chartData: {
          labels: [], // Product names
          datasets: [{
            label: 'Total Sold',
            data: [],
            backgroundColor: 'rgba(75, 192, 192, 0.5)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1,
          }],
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
              title: {
                display: true,
                text: 'Products',
              },
            },
            y: {
              title: {
                display: true,
                text: 'Total Sold',
              },
              beginAtZero: true,
            },
          },
        },
      };
    },
    async mounted() {
      try {
        const response = await fetch('http://localhost:5555/products/top-selling-products');
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Fetched top selling products data:', data);
  
        if (data && Array.isArray(data.topSellingProducts)) {
          this.chartData.labels = data.topSellingProducts.map(product => product.product_name);
          this.chartData.datasets[0].data = data.topSellingProducts.map(product => product.total_sold);
        } else {
          console.error("Expected topSellingProducts to be an array:", data);
          this.chartData.labels = [];
          this.chartData.datasets[0].data = [];
        }
      } catch (error) {
        console.error('Failed to fetch top selling products data:', error);
        this.chartData.labels = [];
        this.chartData.datasets[0].data = [];
      }
    },
  };
  </script>
  