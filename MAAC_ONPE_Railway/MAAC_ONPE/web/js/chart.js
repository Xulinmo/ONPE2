const ctx = document.getElementById('monthlyChart');

new Chart(ctx, {

    type: 'bar',

    data: {

        labels: [
            'Enero',
            'Febrero',
            'Marzo',
            'Abril',
            'Mayo'
        ],

        datasets: [

            {
                label: 'Aprobados',

                data: [31, 39, 28, 45, 50],

                backgroundColor: '#198754',

                borderRadius: 8
            },

            {
                label: 'Rechazados',

                data: [6, 8, 10, 7, 5],

                backgroundColor: '#dc3545',

                borderRadius: 8
            }

        ]

    },

    options: {

        responsive: true,

        maintainAspectRatio: false,

        plugins: {

            legend: {

                position: 'top'

            }

        },

        scales: {

            y: {

                beginAtZero: true

            }

        }

    }

});


